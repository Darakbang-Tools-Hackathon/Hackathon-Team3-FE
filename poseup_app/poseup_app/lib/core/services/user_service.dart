import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_user.dart';

final userServiceProvider = Provider<UserService>((ref) {
  return UserService();
});

class UserService {
  Future<AppUser> fetchCurrentUser() async {
    // TODO: Firebase Auth + Firestore 프로필 조회
    return const AppUser(
      id: 'stub-user',
      displayName: '김포즈',
      lp: 1840,
      wakeUpTime: '07:15',
    );
  }
}

