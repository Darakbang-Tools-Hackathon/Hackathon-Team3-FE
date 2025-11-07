import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/pose_detection_service.dart';
import 'challenge_result_screen.dart';

class ChallengeScreen extends ConsumerWidget {
  const ChallengeScreen({super.key});

  static const routePath = '/challenge/pose';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF101526),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('오늘의 포즈 챌린지'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CountdownHeader(),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1B253A), Color(0xFF101526)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  border: Border.all(color: const Color(0xFF3E4B68), width: 2),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB36C),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: const Text(
                        '이 자세를 따라해주세요!',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 3 / 5,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFFED7F2B), width: 2),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Center(
                              child: Icon(Icons.self_improvement, color: Color(0xFFFFB36C), size: 120),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const _PoseStatusRow(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () async {
                final score = await ref.read(poseDetectionServiceProvider).evaluatePoseMatch();
                if (!context.mounted) return;
                context.push(ChallengeResultScreen.routePath, extra: score);
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFFB36C),
                minimumSize: const Size.fromHeight(56),
              ),
              child: const Text('포즈 확인 완료'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountdownHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('남은 시간', style: TextStyle(color: Colors.white70)),
            Text(
              '04:59',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: Colors.white, fontFeatures: const [FontFeature.tabularFigures()]),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(
            value: 0.1,
            minHeight: 8,
            backgroundColor: const Color(0xFF252F45),
            valueColor: const AlwaysStoppedAnimation(Color(0xFFFFB36C)),
          ),
        ),
      ],
    );
  }
}

class _PoseStatusRow extends StatelessWidget {
  const _PoseStatusRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1B253A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF3E4B68)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('포즈를 확인해주세요', style: TextStyle(color: Colors.white70)),
              Text('일치도 72%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              _PosePartStatus(label: '어깨', status: true),
              SizedBox(width: 12),
              _PosePartStatus(label: '팔꿈치', status: true),
              SizedBox(width: 12),
              _PosePartStatus(label: '무릎', status: false),
            ],
          ),
        ],
      ),
    );
  }
}

class _PosePartStatus extends StatelessWidget {
  const _PosePartStatus({required this.label, required this.status});

  final String label;
  final bool status;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: status ? const Color(0xFF223044) : const Color(0xFF332235),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(status ? Icons.check : Icons.timelapse,
                color: status ? const Color(0xFFFFB36C) : const Color(0xFFE05B7B)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
