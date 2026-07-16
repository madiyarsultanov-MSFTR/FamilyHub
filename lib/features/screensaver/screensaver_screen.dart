import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';

/// Idle / screensaver surface — a calm solid emerald block for when the panel
/// is not actively showing the pulse. Placeholder for now (route `/idle`).
class ScreensaverScreen extends StatelessWidget {
  const ScreensaverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: HubColors.emeraldDark,
      body: Center(
        child: Text('OYNA Home', style: TextStyle(
            color: HubColors.ink,
            fontSize: 36,
            fontWeight: FontWeight.w700,
            letterSpacing: 2)),
      ),
    );
  }
}
