import 'package:flutter/material.dart';

class SleepSuggestion {
  const SleepSuggestion({
    required this.time,
    required this.cycles,
    required this.totalSleep,
    this.isRecommended = false,
  });

  final TimeOfDay time;
  final int cycles;
  final Duration totalSleep;
  final bool isRecommended;

  String get formattedDuration {
    final hours = totalSleep.inHours;
    final minutes = totalSleep.inMinutes.remainder(60);
    if (minutes == 0) {
      return '${hours}시간';
    }
    return '${hours}시간 ${minutes}분';
  }
}

