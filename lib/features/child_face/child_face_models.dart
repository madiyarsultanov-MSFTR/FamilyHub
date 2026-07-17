import 'package:flutter/material.dart';

/// View-models for the child face. All stub-only, view-only — the hub never
/// writes anything.

/// The two tones one child screen renders.
enum ChildTone { kid, jeo }

/// STUB PROXY ONLY. Tone is derived from age here as a temporary stand-in.
/// The CANONICAL source of tone is the child's `track` field (KID / Jeo, set
/// during onboarding) — not age. Swap this for the real track when the profile
/// lands (no live reads yet).
ChildTone toneForAge(int age) => age >= 13 ? ChildTone.jeo : ChildTone.kid;

/// Status only — never an interactive checkbox (view-only; "отмечай в приложении").
enum TaskStatus { done, remaining }

/// A KID quest with a star reward.
class KidQuest {
  const KidQuest({required this.title, required this.status, required this.stars});
  final String title;
  final TaskStatus status;
  final int stars;
}

/// A Jeo savings goal with a progress ring.
class JeoGoal {
  const JeoGoal({
    required this.title,
    required this.progress,
    required this.todayLabel,
  });
  final String title; // 'Велосипед'
  final double progress; // 0.62
  final String todayLabel; // '+500 ₸ сегодня'
}

/// A Jeo "Мой день" task — shown as a status.
class DayTask {
  const DayTask({required this.title, required this.status});
  final String title;
  final TaskStatus status;
}

/// One entry in the shared "Кто чем занят" calendar (read-only).
class CalendarEntry {
  const CalendarEntry({
    required this.time,
    required this.who,
    required this.title,
    required this.color,
  });
  final String time;
  final String who;
  final String title;
  final Color color;
}
