import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ✅ 실제 폴더 구조에 맞게 수정된 경로
import '../features/dashboard/view/dashboard_screen.dart';
import '../screens/pose_challenge_screen.dart';
import '../screens/challenge_result_success_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/result_success', // ✅ 앱 실행 시 첫 화면 지정
    routes: [
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/pose_challenge',
        builder: (context, state) => const PoseChallengeScreen(),
      ),
      GoRoute(
        path: '/result_success',
        builder: (context, state) => const ChallengeResultSuccessScreen(),
      ),
    ],
  );
});
