import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/child_profile.dart';

/// STUB roster shown in setup until real children come from schema-confirmed
/// reads (CONTRACT §3 — no live query yet). Hardcoded for now.
final stubChildrenProvider = Provider<List<ChildProfile>>((_) {
  return const [
    ChildProfile(id: 'togzhan', name: 'Тогжан', age: 14),
    ChildProfile(id: 'raiymbek', name: 'Райымбек', age: 9),
  ];
});
