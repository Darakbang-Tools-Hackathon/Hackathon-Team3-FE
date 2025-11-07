// lib/core/providers/app_state.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/sleep_cycle_service.dart';
import 'app_user.dart';

final currentUserProvider = FutureProvider<AppUser>((ref) async {
  // Firebase Auth 또는 로컬 데이터로 사용자 정보 가져오기
  return AppUser(
    uid: 'user123',
    wakeUpTime: '07:30',
    lp: 10,
    lastChallengeStatus: '완료',
  );
});

final sleepCycleServiceProvider = Provider((ref) => SleepCycleService());