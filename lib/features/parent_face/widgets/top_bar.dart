import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/colors.dart';
import '../parent_face_providers.dart';

/// Top bar: date + clock (stub — real DateTime.now(), not ticking), stub weather,
/// and the family avatars on the right.
class TopBar extends ConsumerWidget {
  const TopBar({super.key});

  static const _weekdays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
  static const _months = [
    'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
    'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final date =
        '${_weekdays[now.weekday - 1]}, ${now.day} ${_months[now.month - 1]}';
    final time =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final weather = ref.watch(weatherStubProvider);
    final family = ref.watch(familyMembersProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 8),
      child: Row(
        children: [
          Text(time,
              style: const TextStyle(
                  color: HubColors.paperInk,
                  fontSize: 24,
                  fontWeight: FontWeight.w700)),
          const SizedBox(width: 12),
          Text(date,
              style: const TextStyle(
                  color: HubColors.paperInkDim, fontSize: 15)),
          const Spacer(),
          Text(weather,
              style: const TextStyle(
                  color: HubColors.paperInk, fontSize: 16)),
          const SizedBox(width: 20),
          for (final m in family)
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: m.color,
                child: Text(m.initial,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700)),
              ),
            ),
        ],
      ),
    );
  }
}
