import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/colors.dart';
import '../child_face_models.dart';
import '../child_face_providers.dart';

/// Jay the motivator — speaks TO the child. Loud & playful for KID (filled
/// emerald), quiet companion for Jeo (calm light block). No analysis about the
/// child (child-safety).
class JayMotivator extends ConsumerWidget {
  const JayMotivator({super.key, required this.tone});

  final ChildTone tone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = ref.watch(jayChildLinesProvider)[tone] ?? '';
    final kid = tone == ChildTone.kid;

    final bg = kid ? HubColors.emerald : HubColors.childCard;
    final fg = kid ? Colors.white : HubColors.paperInk;
    final avatarBg = kid ? Colors.white24 : HubColors.emerald.withValues(alpha: 0.16);
    final avatarFg = kid ? Colors.white : HubColors.emeraldDark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
        border: kid ? null : Border.all(color: HubColors.paperLine),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: avatarBg,
            child: Text('Дж',
                style: TextStyle(
                    color: avatarFg,
                    fontSize: 15,
                    fontWeight: FontWeight.w800)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    color: fg,
                    fontSize: kid ? 18 : 16,
                    height: 1.3,
                    fontWeight: kid ? FontWeight.w700 : FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
