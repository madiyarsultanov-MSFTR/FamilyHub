import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/colors.dart';
import '../setup/setup_providers.dart';
import 'parent_face_models.dart';

/// STUB providers for the parent face — zero live reads, zero Supabase. These
/// get swapped for `ReadRepository`-backed reads in a later ticket after schema
/// sync (CONTRACT §1/§3).

final familyMembersProvider = Provider<List<FamilyMember>>((_) {
  return const [
    FamilyMember(initial: 'П', color: HubColors.personBlue),
    FamilyMember(initial: 'М', color: HubColors.personRose),
    FamilyMember(initial: 'Т', color: HubColors.personAmber),
    FamilyMember(initial: 'Р', color: HubColors.personTeal),
  ];
});

final weatherStubProvider = Provider<String>((_) => '☀️ 31°');

final agendaEventsProvider = Provider<List<AgendaEvent>>((_) {
  return const [
    AgendaEvent(
        time: '08:00',
        title: 'Школа · Тогжан',
        color: HubColors.personAmber,
        sourceTag: 'Google · чтение'),
    AgendaEvent(
        time: '15:30',
        title: 'Тренировка · Райымбек',
        color: HubColors.personTeal),
    AgendaEvent(
        time: '18:00', title: 'Семейный ужин', color: HubColors.personBlue),
    AgendaEvent(
        time: '20:00',
        title: 'Чтение перед сном',
        color: HubColors.personRose,
        sourceTag: 'Google · чтение'),
  ];
});

/// Reuses [stubChildrenProvider] for identity (id/name/age), adds stub pulse
/// metrics + display track. Kept in sync with the setup roster.
final pulseChildrenProvider = Provider<List<ChildPulse>>((ref) {
  final children = ref.watch(stubChildrenProvider);
  const tracks = {'togzhan': 'Jeo', 'raiymbek': 'квесты'};
  const done = {'togzhan': 3, 'raiymbek': 4};
  const total = {'togzhan': 5, 'raiymbek': 4};
  const streaks = {'togzhan': 12, 'raiymbek': 5};
  return [
    for (final c in children)
      ChildPulse(
        childId: c.id,
        name: c.name,
        age: c.age ?? 0,
        track: tracks[c.id] ?? 'квесты',
        doneToday: done[c.id] ?? 0,
        totalToday: total[c.id] ?? 0,
        streak: streaks[c.id] ?? 0,
      ),
  ];
});

final rewardsProvider = Provider<List<ChildReward>>((_) {
  return const [
    ChildReward(childId: 'togzhan', name: 'Тогжан', stars: 3),
    ChildReward(childId: 'raiymbek', name: 'Райымбек', stars: 5),
  ];
});

/// Jay is the parent-facing analyst here — remarks ABOUT the child, not to them.
final jayLinesProvider = Provider<Map<String, String>>((_) {
  return const {
    'togzhan':
        'Тогжан две недели подряд закрывает Jeo — заметная динамика в логике.',
    'raiymbek':
        'Райымбек чаще выбирает творческие квесты. Хороший момент поддержать.',
  };
});
