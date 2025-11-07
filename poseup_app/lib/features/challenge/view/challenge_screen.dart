import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/pose_detection_service.dart';
import '../../../router/routes.dart';

class ChallengeScreen extends ConsumerWidget {
  const ChallengeScreen({super.key});

  static const routePath = Routes.challenge;
  static const routeName = 'challenge';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('오늘의 포즈 챌린지')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '5분 제한 시간 내에 오늘의 포즈를 따라 해보세요!',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).colorScheme.surfaceVariant,
                ),
                child: const Center(
                  child: Icon(Icons.sports_gymnastics, size: 96),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const _CountdownTimer(),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () async {
                final score = await ref.read(poseDetectionServiceProvider).evaluatePoseMatch();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('포즈 일치도: ${(score * 100).toStringAsFixed(0)}% (스텁)')),
                  );
                }
              },
              icon: const Icon(Icons.check),
              label: const Text('인증 스텁 실행'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountdownTimer extends StatelessWidget {
  const _CountdownTimer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('남은 시간', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Text(
          '04:59',
          style: Theme.of(context)
              .textTheme
              .displayMedium
              ?.copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
        ),
      ],
    );
  }
}

