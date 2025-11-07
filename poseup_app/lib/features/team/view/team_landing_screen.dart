import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'team_create_screen.dart';
import 'team_join_screen.dart';

class TeamLandingScreen extends StatelessWidget {
  const TeamLandingScreen({super.key});

  static const routePath = '/team/landing';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('팀 참여하기'),
        actions: [
          TextButton(
            onPressed: () => context.push(TeamCreateScreen.routePath),
            child: const Text('새 팀 만들기'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: const [
            _IntroBanner(),
            SizedBox(height: 24),
            _BenefitCard(
              title: '보너스 LP',
              description: '팀원과 함께 성공하면 추가 LP 획득',
              icon: Icons.bolt,
            ),
            SizedBox(height: 12),
            _BenefitCard(
              title: '서로 격려',
              description: '팀원들의 성공이 당신의 동기부여!',
              icon: Icons.favorite,
            ),
            SizedBox(height: 12),
            _BenefitCard(
              title: '주간 랭킹',
              description: '다른 팀들과 경쟁하며 성장하세요',
              icon: Icons.emoji_events,
            ),
            SizedBox(height: 24),
            _ActionButtons(),
          ],
        ),
      ),
    );
  }
}

class _IntroBanner extends StatelessWidget {
  const _IntroBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE8D6FF), Color(0xFFF6E6FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.groups, color: Color(0xFF7A3FFF), size: 32),
          ),
          const SizedBox(height: 18),
          Text(
            '친구들과 함께 아침을 정복하세요!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '팀 미션으로 즐겁게 기상 습관을 만들고 서로 응원해요.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _BenefitCard extends StatelessWidget {
  const _BenefitCard({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF2EBFF),
            ),
            child: Icon(icon, color: const Color(0xFF7A3FFF)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(description, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LandingButton(
          label: '새 팀 만들기',
          description: '당신이 리더가 되어 팀을 만들어 보세요',
          colors: const [Color(0xFF9B5CFE), Color(0xFFD07CFF)],
          onTap: () => context.push(TeamCreateScreen.routePath),
        ),
        const SizedBox(height: 16),
        _LandingButton(
          label: '팀 참여하기',
          description: '친구의 팀 코드로 참여하세요',
          colors: const [Color(0xFFFFB36C), Color(0xFFFFD18A)],
          onTap: () => context.push(TeamJoinScreen.routePath),
        ),
      ],
    );
  }
}

class _LandingButton extends StatelessWidget {
  const _LandingButton({
    required this.label,
    required this.description,
    required this.colors,
    required this.onTap,
  });

  final String label;
  final String description;
  final List<Color> colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

