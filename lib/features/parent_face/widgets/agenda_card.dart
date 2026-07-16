import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/colors.dart';
import '../parent_face_models.dart';
import '../parent_face_providers.dart';
import 'hub_panel.dart';

/// "Сегодня" — stub agenda. Each event carries a person-colour bar; the
/// `Google · чтение` tag is a visual label only (no calendar integration).
class AgendaCard extends ConsumerWidget {
  const AgendaCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(agendaEventsProvider);
    return HubPanel(
      title: 'Сегодня',
      child: Column(
        children: [
          for (final e in events)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _EventRow(event: e),
            ),
        ],
      ),
    );
  }
}

class _EventRow extends StatelessWidget {
  const _EventRow({required this.event});
  final AgendaEvent event;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: HubColors.paper,
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: event.color, width: 4)),
      ),
      child: Row(
        children: [
          Text(event.time,
              style: const TextStyle(
                  color: HubColors.paperInkDim,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(event.title,
                style: const TextStyle(
                    color: HubColors.paperInk,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
          ),
          if (event.sourceTag != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: HubColors.paperCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: HubColors.paperLine),
              ),
              child: Text(event.sourceTag!,
                  style: const TextStyle(
                      color: HubColors.paperInkDim, fontSize: 11)),
            ),
          ],
        ],
      ),
    );
  }
}
