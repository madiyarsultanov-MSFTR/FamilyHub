import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/child_face/child_face_screen.dart';
import '../../features/parent_face/parent_face_screen.dart';
import '../../features/screensaver/screensaver_screen.dart';
import '../../features/setup/setup_screen.dart';
import '../device/device_mode.dart';
import '../device/hub_face_store.dart';

/// Routing for the hub. On start we read the locally-stored [HubFace]:
///   • unset → `/setup` (setup-first),
///   • parent → parent face, child → that child's face.
/// `/idle` is the screensaver. Ambient/child_pulse are unrouted for now — they
/// return as face content in later tickets. Kiosk deferred until after BET-001.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final face = ref.read(hubFaceControllerProvider);
      final atSetup = state.matchedLocation == '/setup';
      if (face == null) return atSetup ? null : '/setup';
      if (atSetup) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/setup', builder: (_, _) => const SetupScreen()),
      GoRoute(
        path: '/',
        builder: (_, _) {
          final face = ref.read(hubFaceControllerProvider);
          return switch (face) {
            ParentFace() => const ParentFaceScreen(),
            ChildFace(:final childId) => ChildFaceScreen(childId: childId),
            null => const SetupScreen(), // redirect covers this; safe fallback
          };
        },
      ),
      GoRoute(path: '/idle', builder: (_, _) => const ScreensaverScreen()),
    ],
  );
});
