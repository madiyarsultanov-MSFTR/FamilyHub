import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Central access to runtime configuration. Secrets NEVER live in git
/// (ARCH-RULE-001): values come from a gitignored `.env` (see `.env.example`)
/// or, for release builds, from `--dart-define`. FamilyHub uses only the anon
/// key + RLS for reads — a `service_role` key is a stop signal (CONTRACT §5).
class Env {
  const Env._();

  static String get supabaseUrl =>
      dotenv.maybeGet('SUPABASE_URL') ??
      const String.fromEnvironment('SUPABASE_URL');

  static String get supabaseAnonKey =>
      dotenv.maybeGet('SUPABASE_ANON_KEY') ??
      const String.fromEnvironment('SUPABASE_ANON_KEY');

  /// True once both values are present. When false the app still runs (the
  /// scaffold reads no DB yet) — Supabase init is simply skipped.
  static bool get hasSupabase =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
