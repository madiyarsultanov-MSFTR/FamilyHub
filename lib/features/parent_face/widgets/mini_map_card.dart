import 'package:flutter/material.dart';

import '../../../core/theme/colors.dart';
import 'hub_panel.dart';

/// Mini-map — a STUB: a solid block + a dot + caption. No real geolocation, no
/// street rendering (deliberately not detailed).
class MiniMapCard extends StatelessWidget {
  const MiniMapCard({super.key});

  @override
  Widget build(BuildContext context) {
    return HubPanel(
      title: 'На карте',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: HubColors.personTeal.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: HubColors.paperLine),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: const Alignment(0.15, -0.1),
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: HubColors.emerald,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('5 мин назад',
                  style: TextStyle(
                      color: HubColors.paperInkDim, fontSize: 13)),
              const Spacer(),
              Text('Найти',
                  style: TextStyle(
                      color: HubColors.emeraldDark,
                      fontSize: 13,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}
