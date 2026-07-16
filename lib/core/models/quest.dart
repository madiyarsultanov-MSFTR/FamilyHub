/// Thin copy of a quest as FamilyHub displays it (CONTRACT §3).
///
/// Source (read-only, RLS): **`quests_v3`** — the canon schema. FamilyHub never
/// reads or touches the legacy `quests` table (CONTRACT §2). Exact columns to be
/// confirmed against the main repo before any query is written.
enum QuestStatus { active, done }

class Quest {
  const Quest({
    required this.id,
    required this.title,
    required this.status,
  });

  final String id;
  final String title;
  final QuestStatus status;

  bool get isDone => status == QuestStatus.done;
}
