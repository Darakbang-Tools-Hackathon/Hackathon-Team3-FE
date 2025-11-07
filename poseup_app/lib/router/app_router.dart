import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/challenge/view/challenge_screen.dart';
import '../features/dashboard/view/dashboard_screen.dart';
import '../features/onboarding/view/onboarding_screen.dart';
import '../features/team/view/team_screen.dart';
import 'routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.onboarding,
    routes: [
      GoRoute(
        path: Routes.onboarding,
        name: OnboardingScreen.routeName,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: Routes.dashboard,
        name: DashboardScreen.routeName,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: Routes.challenge,
        name: ChallengeScreen.routeName,
        builder: (context, state) => const ChallengeScreen(),
      ),
      GoRoute(
        path: Routes.team,
        name: TeamScreen.routeName,
        builder: (context, state) => const TeamScreen(),
      ),
    ],
  );
});

