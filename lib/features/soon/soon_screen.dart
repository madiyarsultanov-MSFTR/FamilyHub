import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import '../parent_face/widgets/left_rail.dart';

/// Placeholder for rail destinations that aren't built yet (Календарь, Карта).
/// Keeps the rail so the parent can navigate back. Separate tickets fill these.
class SoonScreen extends StatelessWidget {
  const SoonScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HubColors.paper,
      body: Row(
        children: [
          const LeftRail(),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: HubColors.paperInk,
                          fontSize: 28,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: HubColors.emerald.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('скоро',
                        style: TextStyle(
                            color: HubColors.emeraldDark,
                            fontSize: 13,
                            fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
