import 'package:flutter_riverpod/flutter_riverpod.dart';

/// FamilyHub is a single-form-factor build: the always-on hub surface. The
/// phone's other device modes live in the main OYNA repo, not here.
enum DeviceMode { hub }

/// Compile-time default for this build.
const DeviceMode kDeviceMode = DeviceMode.hub;

/// Read the active device mode anywhere. `main.dart` overrides this in the
/// root [ProviderScope] so `hub` is fixed at the entry point.
final deviceModeProvider = Provider<DeviceMode>((_) => kDeviceMode);
