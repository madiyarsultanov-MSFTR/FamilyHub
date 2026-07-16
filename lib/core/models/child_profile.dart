/// Thin copy of the child profile FamilyHub renders (CONTRACT §3 — no shared
/// package yet, so a local copy rather than importing the main repo's `lib/`).
///
/// Source (read-only, RLS): the family's child profile, reached via `parents`
/// keyed by `auth_uid`. Exact columns to be confirmed against the main repo
/// before any query is written.
class ChildProfile {
  const ChildProfile({
    required this.id,
    required this.name,
    this.age,
    this.avatarUrl,
  });

  final String id;
  final String name;
  final int? age;
  final String? avatarUrl;
}
