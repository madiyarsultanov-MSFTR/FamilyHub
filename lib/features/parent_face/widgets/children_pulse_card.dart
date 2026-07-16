import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/colors.dart';
import '../parent_face_models.dart';
import '../parent_face_providers.dart';
import 'hub_panel.dart';

/// "Дети" — stub pulse cards. Tapping a child selects it (drives the Jay line
/// below). Metrics are stub; no live reads.
class ChildrenPulseCard extends ConsumerWidget {
  const ChildrenPulseCard({
    super.key,
    required this.selectedChildId,
    required this.onSelect,
  });

  final String? selectedChildId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pulses = ref.watch(pulseChildrenProvider);
    return HubPanel(
      title: 'Дети',
      child: Column(
        children: [
          for (final p in pulses)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _PulseTile(
                pulse: p,
                selected: p.childId == selectedChildId,
                onTap: () => onSelect(p.childId),
              ),
            ),
        ],
      ),
    );
  }
}

class _PulseTile extends StatelessWidget {
  const _PulseTile(
      {required this.pulse, required this.selected, required this.onTap});

  final ChildPulse pulse;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: HubColors.paper,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? HubColors.emerald : HubColors.paperLine,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(pulse.name,
                      style: const TextStyle(
                          color: HubColors.paperInk,
                          fontSize: 15,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(width: 8),
                  Text('${pulse.age} · ${pulse.track}',
                      style: const TextStyle(
                          color: HubColors.paperInkDim, fontSize: 12.5)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('${pulse.doneToday} из ${pulse.totalToday} сегодня',
                      style: const TextStyle(
                          color: HubColors.paperInk, fontSize: 13)),
                  const Spacer(),
                  const Icon(Icons.local_fire_department_rounded,
                      color: HubColors.personAmber, size: 16),
                  const SizedBox(width: 3),
                  Text('${pulse.streak}',
                      style: const TextStyle(
                          color: HubColors.paperInkDim,
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
