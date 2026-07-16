import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/colors.dart';
import '../parent_face_providers.dart';
import 'hub_panel.dart';

/// "Награды" — stub star totals per child.
class RewardsCard extends ConsumerWidget {
  const RewardsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rewards = ref.watch(rewardsProvider);
    return HubPanel(
      title: 'Награды',
      child: Column(
        children: [
          for (final r in rewards)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(r.name,
                        style: const TextStyle(
                            color: HubColors.paperInk,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                  ),
                  for (var i = 0; i < r.stars; i++)
                    const Icon(Icons.star_rounded,
                        color: HubColors.personAmber, size: 18),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
