import 'package:flutter/material.dart';

/// View-models for the parent face. All stub-only in this ticket — no live data.

/// A family member chip in the top bar (initial + accent).
class FamilyMember {
  const FamilyMember({required this.initial, required this.color});
  final String initial;
  final Color color;
}

/// One agenda item in "Сегодня". `sourceTag` is a visual label only (e.g.
/// "Google · чтение") — no real calendar integration.
class AgendaEvent {
  const AgendaEvent({
    required this.time,
    required this.title,
    required this.color,
    this.sourceTag,
  });
  final String time;
  final String title;
  final Color color;
  final String? sourceTag;
}

/// A child's pulse card in "Дети". `track` is the display lane (Jeo / квесты).
class ChildPulse {
  const ChildPulse({
    required this.childId,
    required this.name,
    required this.age,
    required this.track,
    required this.doneToday,
    required this.totalToday,
    required this.streak,
  });
  final String childId;
  final String name;
  final int age;
  final String track;
  final int doneToday;
  final int totalToday;
  final int streak;
}

/// A rewards row in "Награды".
class ChildReward {
  const ChildReward({
    required this.childId,
    required this.name,
    required this.stars,
  });
  final String childId;
  final String name;
  final int stars;
}
