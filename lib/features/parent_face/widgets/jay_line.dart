import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/colors.dart';
import '../parent_face_providers.dart';

/// The Jay strip beneath the grid. On the PARENT face Jay is an analyst — the
/// remark is ABOUT the selected child, never addressed to them. Stub lines.
class JayLine extends ConsumerWidget {
  const JayLine({super.key, required this.childId});

  final String? childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lines = ref.watch(jayLinesProvider);
    final text = childId == null
        ? 'Выберите ребёнка, чтобы увидеть наблюдения Джея.'
        : lines[childId] ?? 'Пока нет наблюдений по этому ребёнку.';

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 4, 24, 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HubColors.paperCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: HubColors.paperLine),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: HubColors.emerald.withValues(alpha: 0.16),
            child: const Text('Дж',
                style: TextStyle(
                    color: HubColors.emeraldDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w800)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Джей · аналитик',
                    style: TextStyle(
                        color: HubColors.paperInkDim,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(text,
                    style: const TextStyle(
                        color: HubColors.paperInk,
                        fontSize: 14.5,
                        height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
