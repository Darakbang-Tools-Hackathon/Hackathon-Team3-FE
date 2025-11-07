class SleepCalculator {
  // 기존에 있다면 그대로 두세요.
  static List<String> calculateWakeTimes(int hour, int minute, String period) {
    const sleepCycle = 90; // minutes
    final baseHour = period == 'PM' ? (hour % 12) + 12 : (hour % 12);
    final sleepTime = DateTime(2025, 1, 1, baseHour, minute);

    final results = <String>[];
    for (int i = 4; i <= 6; i++) {
      final wake = sleepTime.add(Duration(minutes: sleepCycle * i + 15));
      final h12 = (wake.hour % 12 == 0) ? 12 : wake.hour % 12;
      final ampm = wake.hour >= 12 ? 'PM' : 'AM';
      final mm = wake.minute.toString().padLeft(2, '0');
      results.add('$h12:$mm $ampm');
    }
    return results;
  }

  // ▼ 신규: 기상 시간 → 취침 시간 추천
  static List<String> calculateBedTimes(int hour, int minute, String period) {
    const sleepCycle = 90; // minutes
    final baseHour = period == 'PM' ? (hour % 12) + 12 : (hour % 12);
    final wakeTime = DateTime(2025, 1, 1, baseHour, minute);

    final results = <String>[];
    // 6,5,4 주기 역산(입면 15분 고려)
    for (int cycles = 6; cycles >= 4; cycles--) {
      final bed = wakeTime.subtract(Duration(minutes: sleepCycle * cycles + 15));
      final h12 = (bed.hour % 12 == 0) ? 12 : bed.hour % 12;
      final ampm = bed.hour >= 12 ? 'PM' : 'AM';
      final mm = bed.minute.toString().padLeft(2, '0');
      results.add('$h12:$mm $ampm');
    }
    return results;
  }
}
