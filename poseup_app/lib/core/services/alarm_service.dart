import 'package:flutter_riverpod/flutter_riverpod.dart';

final alarmServiceProvider = Provider<AlarmService>((ref) {
  return AlarmService();
});

class AlarmService {
  Future<void> saveWakeUpTime(String wakeUpTime) async {
    // TODO: Firebase Functions POST /users/alarm 연동
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }
}

