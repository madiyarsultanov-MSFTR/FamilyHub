import 'package:flutter/material.dart';

import '../../../core/models/quest.dart';
import '../../../core/theme/colors.dart';

/// One quest in the child's pulse — a solid emerald block, view-only (the hub
/// never mutates quests). Done quests read calmer; active ones carry the accent.
class PulseCard extends StatelessWidget {
  const PulseCard({super.key, required this.quest});

  final Quest quest;

  @override
  Widget build(BuildContext context) {
    final done = quest.isDone;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: HubColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: HubColors.line),
      ),
      child: Row(
        children: [
          Icon(
            done ? Icons.check_circle_rounded : Icons.bolt_rounded,
            color: done ? HubColors.inkDim : HubColors.emerald,
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              quest.title,
              style: TextStyle(
                color: done ? HubColors.inkDim : HubColors.ink,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                decoration: done ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
