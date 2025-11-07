import 'package:flutter/material.dart';

class SleepRecommendation {
  const SleepRecommendation({
    required this.wakeTime,
    required this.totalSleep,
    required this.cycles,
    this.isHighlighted = false,
  });

  final TimeOfDay wakeTime;
  final Duration totalSleep;
  final int cycles;
  final bool isHighlighted;

  String formattedLabel(BuildContext context) {
    final hours = totalSleep.inHours;
    final minutes = totalSleep.inMinutes.remainder(60);
    final sleepText = minutes == 0 ? '${hours}시간 수면' : '${hours}시간 ${minutes}분 수면';
    return '${wakeTime.format(context)} · ${cycles}주기 · $sleepText';
  }
}

