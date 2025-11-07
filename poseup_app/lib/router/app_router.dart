import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'routes.dart';
import '../features/onboarding/view/onboarding_screen.dart';
import '../features/dashboard/view/dashboard_screen.dart';
import '../features/challenge/view/challenge_screen.dart';
import '../features/profile/view/profile_screen.dart';
import '../features/team/view/team_screen.dart';
import '../features/team/view/team_create_screen.dart';
import '../features/team/view/team_join_screen.dart';
import '../features/challenge/view/challenge_loading_screen.dart';

class AppRouter {
  final router = GoRouter(
    initialLocation: Routes.onboarding,
    routes: [
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: Routes.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: Routes.challenge,
        builder: (context, state) => const ChallengeScreen(),
      ),
      GoRoute(
        path: Routes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: Routes.team,
        builder: (context, state) => const TeamScreen(),
      ),
      GoRoute(
        path: Routes.teamCreate,
        builder: (context, state) => const TeamCreateScreen(),
      ),
      GoRoute(
        path: Routes.teamJoin,
        builder: (context, state) => const TeamJoinScreen(),
      ),
      GoRoute(
        path: Routes.challengeLoading,
        builder: (context, state) => const ChallengeLoadingScreen(),
      ),
    ],
  );
}
