# TIER-MAPPING-001 — Аудит (read-only)

> **Статус:** findings на ревью Айдару. **Ноль мутаций, ноль миграций** — только анализ.
> **Автор аудита:** Claude Code (Tab 2). **Ревью:** Айдар (Tab 1).
> **Дата:** 2026-07-18.

## Симптом (из тикета)

Семья `40e80091-…-dd3f`: `tier=premium`, `product_id=qa_edtech_58`, но `check_child_limit`
блокирует второго ребёнка. Webhook не обновил заряд от 17.07 (строка от 14.07).
RevenueCat показывает 1 active vs 2 premium в базе.

---

## 0. Метод и оговорка о верификации

- Целевой код — `is_premium()`, `check_child_limit()`, `resolveTier()`/revenuecat-webhook —
  живёт в **основном репо `Oyna-pre-production`**, НЕ в FamilyHub. FamilyHub (этот репо) —
  read-mostly дисплей без RevenueCat (CONTRACT §4); этих объектов не содержит и не изменяет.
  Он лишь *читает* те же данные, поэтому отобразил бы тот же неверный tier.
- Анализ по **файлам основного репо @ HEAD `2e360ab`** (добавлен в сессию read-only).
- **Доступа к живой PROD-БД и к дашборду RevenueCat из сессии нет.** Поэтому всё про
  «какая строка победила», значение `expires_at`, тип события 17.07 и `entitlement_ids`
  на событиях 14/17.07 — **выводы из кода + симптомов, помечены как inference.**
  Подтверждение требует read-only SQL на PROD (`pg_get_functiondef`,
  `select … from subscriptions where family_id=…`) и лога событий RC.
- `MIGRATION_HISTORY.md` **не фиксирует применение 034 на PROD** и признаёт, что 025–041
  не залогированы (дрейф). Значит по файлам **нельзя утверждать**, что на PROD стоит именно
  034-версия `is_premium` (с `premium_ai`), а не старая из `schema_v2`. Для этого инцидента
  неважно (см. §2), но проверить стоит.

---

## 1. Актуальные тела функций

### `is_premium()` — последняя редакция в коде

`supabase/migrations/034_is_premium_includes_premium_ai.sql:14`

```sql
create or replace function is_premium(p_family_id uuid)
returns boolean language sql stable as $$
  select coalesce(
    (select tier in ('premium', 'premium_ai')
            and (expires_at is null or expires_at > now() or is_lifetime)
     from subscriptions where family_id = p_family_id),
    false
  );
$$;
```

Старая версия (`schema_v2_subscription_ai.sql:27`) матчила только `tier = 'premium'`.
Обе читают **только** таблицу `subscriptions`: поле `tier` + срок (`expires_at`/`is_lifetime`).

### `check_child_limit()` — единственное определение

`supabase/schema_v3_bugfixes.sql:307`

```sql
create or replace function check_child_limit()
returns trigger language plpgsql as $$
declare current_count int; is_prem boolean;
begin
  select count(*) into current_count from children where family_id = new.family_id;
  select is_premium(new.family_id) into is_prem;          -- ← ключевая строка
  if is_prem and current_count >= 5 then
    raise exception 'Premium plan allows maximum 5 children';
  end if;
  if not is_prem and current_count >= 1 then
    raise exception 'Free plan allows 1 child. Upgrade to Premium for more.';
  end if;
  return new;
end; $$;
-- триггер child_limit_trigger BEFORE INSERT ON children (schema_v3_bugfixes.sql:325)
```

**Каветат:** подтвердить обе функции на PROD через `pg_get_functiondef` — журнал миграций
для них пуст.

---

## 2. Что реально проверяется

- **`check_child_limit` проверяет `is_premium()`, а НЕ поле `tier`** (`schema_v3_bugfixes.sql:314`).
  Колонка `tier='premium'` в строке семьи при проверке лимита **не читается вообще**.
  Гейт — булев результат `is_premium()`.
- **`is_premium()` не смотрит на `product_id` ни разу.** Он читает только `tier` и срок.
  **Никакого списка «признанных» `product_id` в слое БД нет.** `product_id` хранится для
  аудита/отображения, но энтайтлмент не гейтит. Единственное место, где `product_id`
  вообще интерпретируется, — `resolveTier()` на *записи* (webhook), и там тоже не allowlist,
  а подстроки.
- **Вывод:** `qa_edtech_58` для read-time гейта нерелевантен, «спутать» `is_premium` он не
  может. Блок второго ребёнка = `is_premium(40e80091)` вернул **false**, потому что при
  `tier='premium'` строка семьи имеет **`expires_at` в прошлом** (устаревшая строка от 14.07,
  не продлённая), а `is_lifetime=false`. И `tier='premium'`, и `product_id=qa_edtech_58` —
  оба **red herring** для гейта.

---

## 3. `resolveTier()` и upsert — почему заряд 17.07 не обновил строку

`resolveTier` (`supabase/functions/revenuecat-webhook/index.ts:44`): сначала `entitlement_ids`
(`premium_ai`→`premium`), затем **fallback по подстроке `product_id`**:

```ts
const pid = event.product_id ?? "";
if (pid.includes("premium_ai")) return "premium_ai";
if (pid.startsWith("oyna_premium") || pid.includes("premium")) return "premium";
return "free";
```

Для `product_id="qa_edtech_58"` без `entitlement_ids` → **возвращает `"free"`** (не матчит ни
один премиум-паттерн).

Значит комбинация в строке 14.07 (`tier='premium'` + `product_id=qa_edtech_58`) могла
получиться **только если событие 14.07 несло `entitlement_ids=['premium']`** (→ resolveTier=
'premium'), а `product_id` был тест-SKU `qa_edtech_58` (в RC этот продукт привязан к
энтайтлменту `premium`). `product_id` сохраняется дословно (`index.ts:156`) — косметически.

### Почему upsert 17.07 не обновил строку `40e80091` — кандидаты по убыванию согласованности с фактом «2 premium в базе / 1 active в RC»

**(A) Несовпадение ключа конфликта — основная гипотеза.** Ключ конфликта upsert —
`onConflict:"family_id"` (`index.ts:162`; `subscriptions.family_id UNIQUE`), а пишется
`family_id: event.app_user_id` (`:101/:154`). Если `app_user_id` события 17.07 ≠ `40e80091`,
upsert **вставляет новую строку**, а не обновляет строку семьи → **две строки**. Это ровно
тот баг, что уже описан в коде:

- `lib/main.dart:216-217` конфигурирует RC **без `appUserID`** (голый ключ), и лишь потом,
  fire-and-forget, алиасит через `Purchases.logIn(fid)` когда резолвится `familyIdProvider`
  (`:226-233`).
- `features/subscription/lib/src/data/subscription_repository.dart:19-25` прямым текстом:
  webhook «receives RC's anonymous UUID and writes **orphan rows** to the subscriptions table».
- Серверный **RENEWAL** (17.07) приходит асинхронно и может нести не тот `app_user_id`.
  Нюанс FK: `subscriptions.family_id references families(id)` — если `app_user_id` = не-UUID
  `$RCAnonymousID:…`, INSERT падает по FK → 500 → RC ретраит, строка 40e80091 не обновляется
  (сироты нет). Чтобы получить **валидную вторую строку**, `app_user_id` должен быть *другим
  валидным* `families.id` — например **QA/sandbox-семья**. Это связывает `qa_edtech_58`
  (QA-продукт) с дубликатом: «2 premium» = 1 реальная семья (14.07, протухла) + 1 QA-семья
  (17.07, свежая), а RC-prod показывает 1 active реального подписчика.

**(B) Тип события не обрабатывается.** upsert идёт только для
`INITIAL_PURCHASE|RENEWAL|UNCANCELLATION|REACTIVATION` (`:116`) или expiration-набора (`:123`).
Если 17.07 было `PRODUCT_CHANGE / SUBSCRIPTION_EXTENDED / TRANSFER / NON_RENEWING_PURCHASE /
PAUSED` — хендлер возвращает 200 и **не пишет ничего** → строка 14.07 не тронута. Объясняет
«не обновил», но не объясняет вторую строку.

**(C) resolveTier→`free` на renewal без entitlement_ids (латентный баг).** Если renewal 17.07
нёс `product_id=qa_edtech_58` и пустой `entitlement_ids`, resolveTier вернул бы `free`; попади
он в *правильную* строку — **понизил бы** её до free (тоже блок ребёнка). Для известного SKU
fallback по подстроке молча мис-тирит.

**(D) Семантика `expires_at`.** Даже успешный путь ставит `expires_at = expiration_at_ms`.
Sandbox-подписки живут минуты/часы; `expires_at` строки 14.07 к 18.07 давно в прошлом.
Продление должно было обновить `expires_at` именно этой строки — и не обновило (из-за A/B).

### Итог §3

Блокировка = **устаревшая/раздвоенная строка `subscriptions` для семьи**:
`is_premium(40e80091)=false`, т.к. `expires_at` у строки 40e80091 протух, а заряд 17.07 не
освежил его — потому что не срезолвился в конфликт-ключ `family_id=40e80091` (несовпадение
identity, вероятнее всего QA/sandbox `app_user_id`) и/или был необрабатываемым типом события.

---

## 4. Откуда `qa_edtech_58`

- **Ноль вхождений во всём коде** (оба репо, grep). Не константа, не в сид `payment_plans`
  (там `oyna_premium_monthly_uz`), не в тест-фикстурах, не в `.env`.
- `product_id` в `subscriptions` пишет **ровно один писатель** — revenuecat-webhook
  `index.ts:156` (`product_id: productId`). WLCM/Paylov-рельс
  (`056_handle_wlcm_webhook_event.sql:92-99`) `product_id` **не пишет вообще**.
- **Следовательно `qa_edtech_58` — идентификатор продукта RevenueCat, заведённый в дашборде
  RC** (префикс `qa_` ⇒ QA/sandbox тест-продукт), привязанный к энтайтлменту `premium`.
  Тест-SKU, протёкший в ту же таблицу `subscriptions`, которую читает PROD.

---

## 5. Fix-план (НЕ выполнено) + разделение test/prod

> Все правки — в **основном репо OYNA** (webhook/миграции/клиент), не в FamilyHub (CONTRACT §1).
> Разблокировка одной семьи — это **ручная data-коррекция строки 40e80091 на PROD** (освежить
> `expires_at`/`is_lifetime` либо удалить протухшую строку) — исполняет Madiyar, это мутация
> вне периметра аудита. Отмечено, не сделано.

### Минимальный фикс (робастность webhook)

| # | Действие | Риск |
|---|---|---|
| M1 | Явно обрабатывать «renewal-подобные» типы (`PRODUCT_CHANGE`, `TRANSFER`), чтобы освежали `expires_at` | низкий |
| M2 | `resolveTier` не понижать на renewal без entitlement — при `RENEWAL` без матча сохранять текущий tier (read-modify-write вместо `free`) | средний (read перед upsert, конкуренция) |
| M3 | Логировать warning на неизвестный `product_id` (тогда `qa_edtech_58` был бы виден) | низкий (observability) |

**Минус набора:** не чинит корень (identity-key) — сироты/дубли остаются.

### Правильный фикс (identity + маппинг)

| # | Действие | Риск |
|---|---|---|
| P1 | Чинить identity в источнике: `appUserID = family_id` при configure (мёртвый `initRevenueCat({userId})` про это), **или** гейтить paywall на `familyIdProvider != null`, чтобы `logIn(fid)` был до покупки | средний (порядок auth, бэкофилл анон-покупателей, alias-merge RC) |
| P2 | Server-authoritative маппинг `product_id → tier` (таблица-allowlist в духе `payment_plans`/054) вместо подстрок; неизвестный `product_id` → reject/log, а не молчаливый `free`/`premium` | средний (миграция в основном репо DEV→verify→PROD + гигиена дашборда RC) |
| P3 | Реконсиляция пропущенных вебхуков (RC REST `getSubscriber`) для строк с только что истёкшим `expires_at` | усилие выше |
| P4 | Унифицировать понятие premium — их уже три: `is_premium()` (лимит детей + AI), `has_premium_access()`/`private.push_family_is_premium()` (пуши, `048:344/370`), Flutter max-merge (`subscription_repository.dart:63`). Свести к одному | средний/крупный |

### Разделение тестовых и боевых подписок

**Корень:** события RC sandbox и production идут на **один webhook-URL → одну таблицу
`subscriptions`**, а webhook **никогда не смотрит `event.environment`** (RC шлёт
`"SANDBOX"|"PRODUCTION"`; в `index.ts` не упоминается).

| # | Вариант | Риск |
|---|---|---|
| S1 (интерим) | Гейт по `event.environment` в webhook — в prod игнорировать/маршрутизировать SANDBOX (или отдельная `subscriptions_sandbox`/колонка `environment`) | нужна колонка/таблица (миграция) или потеря QA-видимости |
| **S2 (рекомендую)** | Отдельные проекты RC + отдельные webhook-эндпоинты sandbox/prod, каждый в свой Supabase (DEV/PROD) — как гейт «DEV не может ходить в prod-backend» в `build_ios.sh` | настройка проектов/ключей RC |
| S3 | Колонка `environment`/`store` в `subscriptions` + фильтр в `is_premium()` (только `PRODUCTION` даёт prod-энтайтлмент) | миграция + редефиниция `is_premium` |
| S4 (belt-and-suspenders) | Запретить `qa_*`-SKU резолвиться в платный tier в prod (ложится на allowlist P2) | низкий |

**Рекомендация:** S2 как целевое, S1/S3 как временный барьер до BET-001.

---

## Что нужно, чтобы снять оставшиеся inference-каветаты

Read-only доступ к PROD:

1. `select pg_get_functiondef('is_premium(uuid)'::regprocedure);` и то же для `check_child_limit()` — подтвердить, что на PROD стоят именно эти тела.
2. `select family_id, tier, product_id, expires_at, is_lifetime, updated_at from subscriptions where product_id='qa_edtech_58' or family_id='40e80091-…-dd3f';` — увидеть обе строки и реальный `expires_at`.
3. Лог событий RevenueCat за 14–17.07 по этой семье: тип события, `app_user_id`, `entitlement_ids`, `environment` — подтвердить, какой из кандидатов (A/B/C) сработал.
