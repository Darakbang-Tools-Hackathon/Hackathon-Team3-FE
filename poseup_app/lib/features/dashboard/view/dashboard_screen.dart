import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/app_state.dart';
import '../../../core/services/sleep_cycle_service.dart';
import '../../../router/routes.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  static const routePath = Routes.dashboard;
  static const routeName = 'dashboard';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      data: (user) {
        final sleepCycle = ref.watch(sleepCycleServiceProvider);
        final suggestions = sleepCycle.calculateWakeTimes(
          const TimeOfDay(hour: 23, minute: 30),
          suggestions: 3,
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('PoseUp 대시보드'),
            actions: [
              IconButton(
                onPressed: () => context.go(Routes.team),
                icon: const Icon(Icons.group),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '내일 ${user.wakeUpTime} 도전!',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.self_improvement)),
                    title: Text('LP ${user.lp}'),
                    subtitle: Text('오늘의 챌린지 상태: ${user.lastChallengeStatus ?? '대기 중'}'),
                    trailing: FilledButton(
                      onPressed: () => context.go(Routes.challenge),
                      child: const Text('챌린지 시작'),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  '추천 취침 시간',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  children: suggestions
                      .map((time) => _SleepSuggestionChip(time: time.format(context)))
                      .toList(),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(
        body: Center(
          child: Text('사용자 정보를 불러오지 못했어요\n$error'),
        ),
      ),
    );
  }
}

class _SleepSuggestionChip extends StatelessWidget {
  const _SleepSuggestionChip({required this.time});

  final String time;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: const Icon(Icons.nightlight, size: 16),
      label: Text(time),
    );
  }
}

