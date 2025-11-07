import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sleepCycleServiceProvider = Provider<SleepCycleService>((ref) {
  return SleepCycleService();
});

class SleepCycleService {
  static const _cycleMinutes = 90;
  static const _fallAsleepBuffer = Duration(minutes: 15);

  List<TimeOfDay> calculateWakeTimes(TimeOfDay bedtime, {int suggestions = 3}) {
    final baseMinutes = bedtime.hour * 60 + bedtime.minute;
    final results = <TimeOfDay>[];

    for (int i = 1; i <= suggestions; i++) {
      final targetMinutes = baseMinutes + _fallAsleepBuffer.inMinutes + _cycleMinutes * i;
      final sanitized = _minutesToTimeOfDay(targetMinutes % (24 * 60));
      results.add(sanitized);
    }

    return results;
  }

  TimeOfDay _minutesToTimeOfDay(int totalMinutes) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return TimeOfDay(hour: hours, minute: minutes);
  }
}

