import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_user.dart';
import '../services/user_service.dart';

final currentUserProvider = FutureProvider<AppUser>((ref) async {
  final service = ref.watch(userServiceProvider);
  return service.fetchCurrentUser();
});

final wakeUpTimeProvider = StateProvider<String?>((ref) => null);

