/// Which face this hub device shows — a **device property**, chosen once in
/// setup and stored locally (see `hub_face_store.dart`), never family data and
/// never written to Supabase (CONTRACT §1).
///
/// Sealed so the child variant can carry its `childId` and `switch` stays
/// exhaustive. First launch = unset (`null`) → the setup screen decides.
sealed class HubFace {
  const HubFace();

  /// Stable string for local persistence: `parent` | `child:<id>`.
  String encode();

  /// Decode a stored value; `null` when unset or malformed.
  static HubFace? decode(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    if (raw == 'parent') return const ParentFace();
    if (raw.startsWith('child:')) {
      final id = raw.substring('child:'.length);
      return id.isEmpty ? null : ChildFace(id);
    }
    return null;
  }
}

final class ParentFace extends HubFace {
  const ParentFace();

  @override
  String encode() => 'parent';
}

final class ChildFace extends HubFace {
  const ChildFace(this.childId);

  final String childId;

  @override
  String encode() => 'child:$childId';
}
