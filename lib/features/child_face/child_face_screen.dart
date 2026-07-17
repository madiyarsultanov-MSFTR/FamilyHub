import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/child_profile.dart';
import '../../core/theme/colors.dart';
import '../setup/setup_providers.dart';
import 'child_face_models.dart';
import 'widgets/child_switcher.dart';
import 'widgets/jay_motivator.dart';
import 'widgets/jeo_face_view.dart';
import 'widgets/kid_face_view.dart';
import 'widgets/who_is_busy_view.dart';

/// The child face — one screen, two tones (KID / Jeo) driven by the child's
/// track (stub-proxied from age for now). Warm emerald-family surface. Fully
/// view-only: statuses, no checkboxes, no writes. Jay motivates the child.
class ChildFaceScreen extends ConsumerStatefulWidget {
  const ChildFaceScreen({super.key, required this.childId});

  final String childId;

  @override
  ConsumerState<ChildFaceScreen> createState() => _ChildFaceScreenState();
}

class _ChildFaceScreenState extends ConsumerState<ChildFaceScreen> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final children = ref.watch(stubChildrenProvider);
    final child = children.firstWhere(
      (c) => c.id == widget.childId,
      orElse: () => ChildProfile(id: widget.childId, name: widget.childId),
    );
    final tone = toneForAge(child.age ?? 0);
    final kid = tone == ChildTone.kid;

    return Scaffold(
      backgroundColor: kid ? HubColors.kidBg : HubColors.jeoBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 22, 28, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(child.name, tone, kid),
              const SizedBox(height: 20),
              Expanded(
                child: _busy
                    ? const SingleChildScrollView(child: WhoIsBusyView())
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            kid ? const KidFaceView() : const JeoFaceView(),
                            const SizedBox(height: 20),
                            JayMotivator(tone: tone),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(String name, ChildTone tone, bool kid) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(kid ? 'Привет, $name!' : 'Привет, $name',
                      style: TextStyle(
                          color: HubColors.paperInk,
                          fontSize: kid ? 34 : 30,
                          fontWeight: kid ? FontWeight.w800 : FontWeight.w700)),
                  if (!kid) ...[
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: HubColors.emeraldDark,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('JEO',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1)),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              _markInAppLabel(),
            ],
          ),
        ),
        ChildSwitcher(busy: _busy, onChanged: (v) => setState(() => _busy = v)),
      ],
    );
  }

  Widget _markInAppLabel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: HubColors.childCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: HubColors.paperLine),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.smartphone_rounded,
              size: 14, color: HubColors.paperInkDim),
          SizedBox(width: 6),
          Text('отмечай в приложении',
              style: TextStyle(color: HubColors.paperInkDim, fontSize: 12.5)),
        ],
      ),
    );
  }
}
