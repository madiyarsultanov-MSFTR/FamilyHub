import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/config/env.dart';
import 'core/device/device_mode.dart';

/// Entry point. FamilyHub is the hub build: landscape-locked, always-on, and a
/// read-mostly Supabase client (anon + RLS) initialized only when configured.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Landscape-first lock (belt to the manifest's android:screenOrientation).
  await SystemChrome.setPreferredOrientations(const [
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Secrets from a gitignored .env (or --dart-define). Absent .env is fine —
  // the scaffold reads no DB, so we just skip Supabase init.
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // No .env bundled; config may arrive via --dart-define or be unset.
  }

  if (Env.hasSupabase) {
    await Supabase.initialize(
      url: Env.supabaseUrl,
      // Supabase renamed anon → publishable; it's the same read-only key.
      publishableKey: Env.supabaseAnonKey,
    );
  }

  runApp(
    ProviderScope(
      // Fix the device mode to hub at the single entry point.
      overrides: [deviceModeProvider.overrideWithValue(DeviceMode.hub)],
      child: const FamilyHubApp(),
    ),
  );
}
