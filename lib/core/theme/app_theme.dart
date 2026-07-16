import 'package:flutter/material.dart';

import 'colors.dart';

/// Landscape-first ambient theme. Dark emerald surfaces, generous type for a
/// panel read across a room, solid blocks (no gradients).
ThemeData buildHubTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: HubColors.emerald,
    brightness: Brightness.dark,
    primary: HubColors.emerald,
    surface: HubColors.surface,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: HubColors.bg,
    textTheme: const TextTheme(
      displaySmall: TextStyle(
          color: HubColors.ink, fontSize: 40, fontWeight: FontWeight.w700),
      titleLarge: TextStyle(
          color: HubColors.ink, fontSize: 24, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: HubColors.ink, fontSize: 18),
      bodyMedium: TextStyle(color: HubColors.inkDim, fontSize: 15),
    ),
  );
}
