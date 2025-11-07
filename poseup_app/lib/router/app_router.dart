import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/challenge/view/challenge_loading_screen.dart';
import '../features/challenge/view/challenge_result_screen.dart';
import '../features/challenge/view/challenge_screen.dart';
import '../features/dashboard/view/dashboard_screen.dart';
import '../features/onboarding/view/onboarding_screen.dart';
import '../features/profile/view/profile_screen.dart';
import '../features/team/view/team_screen.dart';
import '../features/team/view/team_create_screen.dart';
import '../features/team/view/team_join_screen.dart';
import '../features/team/view/team_landing_screen.dart';
import '../features/time/view/wake_time_setup_screen.dart';
import 'routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: OnboardingScreen.routePath,
    routes: [
      GoRoute(
        path: OnboardingScreen.routePath,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: Routes.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: WakeTimeSetupScreen.routePath,
        builder: (context, state) => const WakeTimeSetupScreen(),
      ),
      GoRoute(
        path: ChallengeLoadingScreen.routePath,
        builder: (context, state) => const ChallengeLoadingScreen(),
      ),
      GoRoute(
        path: ChallengeScreen.routePath,
        builder: (context, state) => const ChallengeScreen(),
      ),
      GoRoute(
        path: ChallengeResultScreen.routePath,
        builder: (context, state) => ChallengeResultScreen(
          score: (state.extra as double?) ?? 0.95,
        ),
      ),
      GoRoute(
        path: TeamLandingScreen.routePath,
        builder: (context, state) => const TeamLandingScreen(),
      ),
      GoRoute(
        path: TeamCreateScreen.routePath,
        builder: (context, state) => const TeamCreateScreen(),
      ),
      GoRoute(
        path: TeamJoinScreen.routePath,
        builder: (context, state) => const TeamJoinScreen(),
      ),
      GoRoute(
        path: TeamScreen.routePath,
        builder: (context, state) => const TeamScreen(),
      ),
      GoRoute(
        path: ProfileScreen.routePath,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
});

