import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/sleep_suggestion.dart';

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

  List<SleepSuggestion> wakeSuggestions(TimeOfDay bedtime, {int suggestions = 3}) {
    final wakeTimes = calculateWakeTimes(bedtime, suggestions: suggestions);
    return List.generate(wakeTimes.length, (index) {
      final cycles = index + 4; // 최소 4주기(약 6시간)부터 추천
      final totalMinutes = (_cycleMinutes * cycles) + _fallAsleepBuffer.inMinutes;
      return SleepSuggestion(
        time: wakeTimes[index],
        cycles: cycles,
        totalSleep: Duration(minutes: totalMinutes),
        isRecommended: index == 1,
      );
    });
  }

  List<SleepSuggestion> bedtimeSuggestions(TimeOfDay wakeTime, {int suggestions = 3}) {
    final wakeMinutes = wakeTime.hour * 60 + wakeTime.minute;
    final results = <SleepSuggestion>[];

    for (int i = suggestions; i >= 1; i--) {
      final cycles = i + 3; // 4~6주기 범위 유지
      final totalMinutes = (_cycleMinutes * cycles) + _fallAsleepBuffer.inMinutes;
      final bedtimeMinutes = wakeMinutes - totalMinutes;
      final sanitizedMinutes = (bedtimeMinutes % (24 * 60) + (24 * 60)) % (24 * 60);
      results.add(
        SleepSuggestion(
          time: _minutesToTimeOfDay(sanitizedMinutes),
          cycles: cycles,
          totalSleep: Duration(minutes: totalMinutes),
          isRecommended: cycles == 5,
        ),
      );
    }

    return results;
  }

  TimeOfDay _minutesToTimeOfDay(int totalMinutes) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return TimeOfDay(hour: hours, minute: minutes);
  }
}

