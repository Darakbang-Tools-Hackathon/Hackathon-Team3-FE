import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../router/routes.dart';

class ChallengeResultScreen extends StatelessWidget {
  const ChallengeResultScreen({super.key, this.score = 0.95});

  static const routePath = '/challenge/result';

  final double score;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FFF3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go(Routes.dashboard),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                children: [
                  const Icon(Icons.check_circle, color: Color(0xFF3DC46A), size: 72),
                  const SizedBox(height: 12),
                  const Text('성공! 🎉', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('완벽한 포즈였어요!', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFFBF2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '"대단해요! 매일 이렇게만 하면 최고 레벨 달성이에요!"',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFF2A7A45)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('LP 변동', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('+100', style: TextStyle(color: Color(0xFF3DC46A), fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Expanded(
                        child: _ResultStat(title: '스트릭', value: '+1'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ResultStat(title: '완벽도', value: '${(score * 100).toStringAsFixed(0)}%'),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: _ResultStat(title: '순위', value: '#12'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Text(
                '💡 꿀팁: 매일 같은 시간에 도전하면 습관이 되어 더 쉬워져요!',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () => context.go(Routes.dashboard),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                backgroundColor: const Color(0xFF3DC46A),
              ),
              child: const Text('대시보드로'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ResultStat extends StatelessWidget {
  const _ResultStat({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF4FFF0),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE1F8DF)),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF2A7A45))),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}

