import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// The shared Supabase client for FamilyHub — **read-mostly**, anon key + RLS
/// (CONTRACT §1, §5). Initialized in `main.dart` only when config is present.
///
/// Access it through this provider; it throws if the client was never
/// initialized (i.e. no env), which keeps read code honest about requiring
/// config rather than silently no-op'ing.
final supabaseClientProvider = Provider<SupabaseClient>((_) {
  return Supabase.instance.client;
});
