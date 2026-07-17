import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/colors.dart';
import '../child_face_models.dart';
import '../child_face_providers.dart';
import 'goal_ring.dart';

/// Jeo "Моё" — a savings goal with a progress ring on the left, "Мой день"
/// tasks (as statuses) on the right. Calmer, no cheerleading. View-only.
class JeoFaceView extends ConsumerWidget {
  const JeoFaceView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goal = ref.watch(jeoGoalProvider);
    final tasks = ref.watch(dayTasksProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // goal card
        Container(
          width: 260,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: HubColors.childCard,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: HubColors.paperLine),
          ),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Цель',
                    style: TextStyle(
                        color: HubColors.paperInkDim,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 14),
              GoalRing(progress: goal.progress),
              const SizedBox(height: 16),
              Text(goal.title,
                  style: const TextStyle(
                      color: HubColors.paperInk,
                      fontSize: 20,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(goal.todayLabel,
                  style: const TextStyle(
                      color: HubColors.emeraldDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Мой день',
                  style: TextStyle(
                      color: HubColors.paperInk,
                      fontSize: 18,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              for (final t in tasks)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _TaskRow(task: t),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({required this.task});
  final DayTask task;

  @override
  Widget build(BuildContext context) {
    final done = task.status == TaskStatus.done;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: HubColors.childCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: HubColors.paperLine),
      ),
      child: Row(
        children: [
          Icon(
            done ? Icons.check_circle_rounded : Icons.circle_outlined,
            color: done ? HubColors.emerald : HubColors.paperInkDim,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(task.title,
                style: TextStyle(
                    color: done ? HubColors.paperInkDim : HubColors.paperInk,
                    fontSize: 15,
                    decoration: done ? TextDecoration.lineThrough : null)),
          ),
          Text(done ? 'сделано' : 'осталось',
              style: const TextStyle(
                  color: HubColors.paperInkDim, fontSize: 12.5)),
        ],
      ),
    );
  }
}
