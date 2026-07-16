import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/child_profile.dart';
import '../../core/models/quest.dart';

/// STUB DATA — the scaffold reads no DB (CONTRACT: reads land in a later ticket
/// via `readRepositoryProvider`, against `parents.auth_uid` / `quests_v3`, RLS).
/// These providers exist so the ambient UI renders and can be swapped to real
/// reads without touching the widgets.
final childProfileProvider = Provider<ChildProfile>((_) {
  return const ChildProfile(id: 'stub', name: 'Тогжан', age: 9);
});

final activeQuestsProvider = Provider<List<Quest>>((_) {
  return const [
    Quest(id: 'q1', title: 'Собери историю про космос', status: QuestStatus.active),
    Quest(id: 'q2', title: 'Нарисуй своего Фокса', status: QuestStatus.done),
    Quest(id: 'q3', title: 'Дыхательная гимнастика с Фоксом', status: QuestStatus.active),
  ];
});
