import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/app_state.dart';
import '../../../core/services/alarm_service.dart';
import '../../../core/services/sleep_cycle_service.dart';
import '../../../router/routes.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  static const routePath = Routes.onboarding;
  static const routeName = 'onboarding';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('알람 설정 시작')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '포즈업에 오신 것을 환영해요!\n어떻게 기상 루틴을 설정할까요?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              icon: const Icon(Icons.alarm),
              label: const Text('일어날 시간을 정할래요'),
              onPressed: () => _handleWakeTimeSelected(context, ref),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              icon: const Icon(Icons.bedtime),
              label: const Text('잘 시간을 정할래요'),
              onPressed: () => _handleBedTimeSelected(context, ref),
            ),
            const Spacer(),
            OutlinedButton(
              onPressed: () => context.go(Routes.dashboard),
              child: const Text('이미 설정했어요. 대시보드로 이동'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _handleWakeTimeSelected(BuildContext context, WidgetRef ref) async {
  final time = await showTimePicker(
    context: context,
    initialTime: const TimeOfDay(hour: 7, minute: 0),
  );

  if (time == null) return;

  final formatted = time.format(context);
  ref.read(wakeUpTimeProvider.notifier).state = formatted;
  await ref.read(alarmServiceProvider).saveWakeUpTime(formatted);

  if (context.mounted) {
    context.go(Routes.dashboard);
  }
}

Future<void> _handleBedTimeSelected(BuildContext context, WidgetRef ref) async {
  final bedtime = await showTimePicker(
    context: context,
    initialTime: const TimeOfDay(hour: 23, minute: 30),
  );

  if (bedtime == null) return;

  final service = ref.read(sleepCycleServiceProvider);
  final suggestions = service.calculateWakeTimes(bedtime, suggestions: 4);

  final selected = await showModalBottomSheet<String>(
    context: context,
    builder: (sheetContext) {
      return ListView(
        padding: const EdgeInsets.all(24),
        shrinkWrap: true,
        children: [
          Text('추천 기상 시간', style: Theme.of(sheetContext).textTheme.titleLarge),
          const SizedBox(height: 16),
          ...suggestions.map(
            (time) => ListTile(
              leading: const Icon(Icons.sunny),
              title: Text(time.format(sheetContext)),
              onTap: () => Navigator.of(sheetContext).pop(time.format(sheetContext)),
            ),
          ),
        ],
      );
    },
  );

  if (selected == null) return;

  ref.read(wakeUpTimeProvider.notifier).state = selected;
  await ref.read(alarmServiceProvider).saveWakeUpTime(selected);

  if (context.mounted) {
    context.go(Routes.dashboard);
  }
}

