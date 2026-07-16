import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/colors.dart';
import 'parent_face_providers.dart';
import 'widgets/agenda_card.dart';
import 'widgets/children_pulse_card.dart';
import 'widgets/jay_line.dart';
import 'widgets/left_rail.dart';
import 'widgets/mini_map_card.dart';
import 'widgets/rewards_card.dart';
import 'widgets/top_bar.dart';

/// The parent face — a restrained light instrument (v2 mock "Главная"). Rail +
/// top bar + a 3-column grid (Сегодня / Дети / карта+награды), with the Jay
/// analyst strip below. All data is stub; no live reads (CONTRACT §1/§3).
class ParentFaceScreen extends ConsumerStatefulWidget {
  const ParentFaceScreen({super.key});

  @override
  ConsumerState<ParentFaceScreen> createState() => _ParentFaceScreenState();
}

class _ParentFaceScreenState extends ConsumerState<ParentFaceScreen> {
  String? _selectedChildId;

  @override
  void initState() {
    super.initState();
    final pulses = ref.read(pulseChildrenProvider);
    _selectedChildId = pulses.isEmpty ? null : pulses.first.childId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HubColors.paper,
      body: Row(
        children: [
          const LeftRail(),
          Expanded(
            child: Column(
              children: [
                const TopBar(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: SingleChildScrollView(
                            child: const AgendaCard(),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 4,
                          child: SingleChildScrollView(
                            child: ChildrenPulseCard(
                              selectedChildId: _selectedChildId,
                              onSelect: (id) =>
                                  setState(() => _selectedChildId = id),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 3,
                          child: SingleChildScrollView(
                            child: Column(
                              children: const [
                                MiniMapCard(),
                                SizedBox(height: 16),
                                RewardsCard(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                JayLine(childId: _selectedChildId),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
