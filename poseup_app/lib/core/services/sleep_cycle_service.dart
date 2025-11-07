import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/sleep_recommendation.dart';
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
      results.add(_minutesToTimeOfDay(targetMinutes % (24 * 60)));
    }

    return results;
  }

  List<SleepRecommendation> buildRecommendations(TimeOfDay bedtime, {int suggestions = 4}) {
    final baseMinutes = bedtime.hour * 60 + bedtime.minute;
    final List<SleepRecommendation> results = [];

    for (int i = 3; i <= suggestions + 2; i++) {
      final totalMinutes = _fallAsleepBuffer.inMinutes + _cycleMinutes * i;
      final wakeMinutes = baseMinutes + totalMinutes;
      final wake = _minutesToTimeOfDay(wakeMinutes % (24 * 60));
      final duration = Duration(minutes: totalMinutes);
      results.add(SleepRecommendation(
        wakeTime: wake,
        totalSleep: duration,
        cycles: i,
        isHighlighted: i == 5,
      ));
    }

    return results;
  }

  TimeOfDay _minutesToTimeOfDay(int totalMinutes) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return TimeOfDay(hour: hours, minute: minutes);
  }
}
