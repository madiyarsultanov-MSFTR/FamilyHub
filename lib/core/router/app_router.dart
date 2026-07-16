import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/ambient/ambient_screen.dart';
import '../../features/screensaver/screensaver_screen.dart';

/// Routing for the hub surface. `/` is the always-on ambient screen; `/idle`
/// is the screensaver. Kiosk/lockdown routes are deferred until after BET-001
/// (hardware gate, CONTRACT §7).
final appRouterProvider = Provider<GoRouter>((_) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, _) => const AmbientScreen()),
      GoRoute(path: '/idle', builder: (_, _) => const ScreensaverScreen()),
    ],
  );
});
