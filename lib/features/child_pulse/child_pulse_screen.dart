import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/colors.dart';
import 'child_pulse_providers.dart';
import 'widgets/pulse_card.dart';

/// The "what's happening with the child" panel — the cognition loop, view-only.
/// Rendered inside the ambient surface. Reads stub providers for now.
class ChildPulseView extends ConsumerWidget {
  const ChildPulseView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quests = ref.watch(activeQuestsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Сегодня у Фокса', style: TextStyle(
            color: HubColors.inkDim, fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.separated(
            itemCount: quests.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, i) => PulseCard(quest: quests[i]),
          ),
        ),
      ],
    );
  }
}
