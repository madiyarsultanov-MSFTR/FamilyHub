import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/colors.dart';
import '../child_face_models.dart';
import '../child_face_providers.dart';

/// "Кто чем занят" — the shared family calendar, READ-ONLY. Same for both tones.
class WhoIsBusyView extends ConsumerWidget {
  const WhoIsBusyView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(sharedCalendarProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Кто чем занят сегодня',
            style: TextStyle(
                color: HubColors.paperInk,
                fontSize: 18,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 14),
        for (final e in entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _EntryRow(entry: e),
          ),
      ],
    );
  }
}

class _EntryRow extends StatelessWidget {
  const _EntryRow({required this.entry});
  final CalendarEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: HubColors.childCard,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: entry.color, width: 4)),
      ),
      child: Row(
        children: [
          Text(entry.time,
              style: const TextStyle(
                  color: HubColors.paperInkDim,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
          const SizedBox(width: 14),
          Text(entry.who,
              style: const TextStyle(
                  color: HubColors.paperInk,
                  fontSize: 15,
                  fontWeight: FontWeight.w700)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(entry.title,
                style: const TextStyle(
                    color: HubColors.paperInk, fontSize: 15)),
          ),
        ],
      ),
    );
  }
}
