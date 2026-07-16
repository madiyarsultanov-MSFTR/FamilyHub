import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/child_profile.dart';
import '../models/quest.dart';
import 'supabase_client.dart';

/// The single read-only seam onto the shared OYNA data (CONTRACT §2, §3).
///
/// Rules baked in here:
///   • Reads only, through existing tables/views, respecting RLS.
///   • `parents` is keyed by `auth_uid` (NOT `auth_user_id`).
///   • Quests come from `quests_v3` (canon), never the legacy `quests` table.
///   • No writes to shared tables, ever.
///
/// The query bodies are intentionally NOT implemented in this scaffold: the
/// exact columns must be confirmed against the main OYNA repo / shared package
/// first (separate ticket). Until then FamilyHub renders stub data and touches
/// no rows.
class ReadRepository {
  ReadRepository(this._client);

  // ignore: unused_field — wired when queries land in a later ticket.
  final SupabaseClient _client;

  Future<ChildProfile> childProfile() {
    throw UnimplementedError(
        'Wire against the main repo schema (parents.auth_uid) before reading.');
  }

  Future<List<Quest>> activeQuests() {
    throw UnimplementedError(
        'Wire against quests_v3 (canon) before reading — never legacy quests.');
  }
}

final readRepositoryProvider = Provider<ReadRepository>((ref) {
  return ReadRepository(ref.watch(supabaseClientProvider));
});
