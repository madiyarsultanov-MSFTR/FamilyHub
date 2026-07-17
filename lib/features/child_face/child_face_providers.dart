import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/colors.dart';
import 'child_face_models.dart';

/// STUB providers for the child faces — zero live reads, zero Supabase,
/// view-only. Swapped for real reads in a later ticket (CONTRACT §1/§3).

final childStreakProvider = Provider<int>((_) => 5);

/// Jay speaks TO the child (motivator), toned. No analyst-about-child here.
final jayChildLinesProvider = Provider<Map<ChildTone, String>>((_) {
  return const {
    ChildTone.kid: 'Пятый день — огонь! Ещё квест — и звезда твоя.',
    ChildTone.jeo: 'Пятый день откладываешь. Держишь темп.',
  };
});

// --- KID ---
final kidQuestsProvider = Provider<List<KidQuest>>((_) {
  return const [
    KidQuest(
        title: 'Собери историю про космос',
        status: TaskStatus.done,
        stars: 2),
    KidQuest(
        title: 'Нарисуй своего Фокса',
        status: TaskStatus.remaining,
        stars: 3),
    KidQuest(
        title: 'Прочитай 10 минут',
        status: TaskStatus.remaining,
        stars: 1),
  ];
});

// --- Jeo ---
final jeoGoalProvider = Provider<JeoGoal>((_) {
  return const JeoGoal(
      title: 'Велосипед', progress: 0.62, todayLabel: '+500 ₸ сегодня');
});

final dayTasksProvider = Provider<List<DayTask>>((_) {
  return const [
    DayTask(title: 'Домашка по алгебре', status: TaskStatus.done),
    DayTask(title: 'Тренировка · 18:00', status: TaskStatus.remaining),
    DayTask(title: 'Урок Jeo', status: TaskStatus.remaining),
  ];
});

// --- shared "Кто чем занят" (read-only) ---
final sharedCalendarProvider = Provider<List<CalendarEntry>>((_) {
  return const [
    CalendarEntry(
        time: '08:00',
        who: 'Тогжан',
        title: 'Школа',
        color: HubColors.personAmber),
    CalendarEntry(
        time: '15:30',
        who: 'Райымбек',
        title: 'Тренировка',
        color: HubColors.personTeal),
    CalendarEntry(
        time: '18:00',
        who: 'Семья',
        title: 'Ужин',
        color: HubColors.personBlue),
  ];
});
