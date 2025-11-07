class SleepCalculator {
  static List<DateTime> calculateWakeTimes(int hour, int minute, String period) {
    int adjustedHour = (period == 'PM' && hour != 12)
        ? hour + 12
        : (period == 'AM' && hour == 12)
            ? 0
            : hour;
    DateTime sleepTime =
        DateTime(2025, 1, 1, adjustedHour, minute).add(const Duration(minutes: 15));

    List<DateTime> wakeTimes = [];
    for (int i = 1; i <= 5; i++) {
      wakeTimes.add(sleepTime.add(Duration(minutes: 90 * i)));
    }
    return wakeTimes;
  }
}
