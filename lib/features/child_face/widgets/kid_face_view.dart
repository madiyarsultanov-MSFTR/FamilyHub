import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/colors.dart';
import '../child_face_models.dart';
import '../child_face_providers.dart';

/// KID "Моё" — big fox + streak on the left, quests (as statuses) on the right.
/// View-only: no checkboxes.
class KidFaceView extends ConsumerWidget {
  const KidFaceView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quests = ref.watch(kidQuestsProvider);
    final streak = ref.watch(childStreakProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // fox + streak
        Column(
          children: [
            Container(
              width: 180,
              height: 180,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: HubColors.childCard,
                shape: BoxShape.circle,
                border: Border.all(color: HubColors.emerald, width: 3),
              ),
              child: const Text('🦊', style: TextStyle(fontSize: 96)),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🔥', style: TextStyle(fontSize: 30)),
                const SizedBox(width: 6),
                Text('$streak дней',
                    style: const TextStyle(
                        color: HubColors.paperInk,
                        fontSize: 24,
                        fontWeight: FontWeight.w800)),
              ],
            ),
          ],
        ),
        const SizedBox(width: 28),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Твои квесты',
                  style: TextStyle(
                      color: HubColors.paperInk,
                      fontSize: 18,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              for (final q in quests)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _QuestTile(quest: q),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuestTile extends StatelessWidget {
  const _QuestTile({required this.quest});
  final KidQuest quest;

  @override
  Widget build(BuildContext context) {
    final done = quest.status == TaskStatus.done;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: HubColors.childCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: HubColors.paperLine),
      ),
      child: Row(
        children: [
          Icon(
            done ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            color: done ? HubColors.emerald : HubColors.paperInkDim,
            size: 26,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(quest.title,
                style: TextStyle(
                    color: done ? HubColors.paperInkDim : HubColors.paperInk,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 10),
          Text('+${quest.stars}',
              style: const TextStyle(
                  color: HubColors.personAmber,
                  fontSize: 16,
                  fontWeight: FontWeight.w800)),
          const Icon(Icons.star_rounded,
              color: HubColors.personAmber, size: 20),
        ],
      ),
    );
  }
}
