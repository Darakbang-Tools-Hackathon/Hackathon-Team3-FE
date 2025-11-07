import 'package:characters/characters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamScreen extends ConsumerWidget {
  const TeamScreen({super.key});

  static const routePath = '/team/dashboard';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFFF472B6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(48),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('팀 참여하기',
                                style: theme.textTheme.headlineSmall
                                    ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text('친구들과 함께 아침을 정복하세요!',
                                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                          ],
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(Icons.close, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: const [
                        _TeamBenefitCard(
                          icon: Icons.bolt,
                          title: '보너스 LP',
                          description: '팀원과 함께 성공하면 추가 LP 획득',
                        ),
                        _TeamBenefitCard(
                          icon: Icons.favorite,
                          title: '서로 격려',
                          description: '팀원들의 성공이 당신의 동기부여!',
                        ),
                        _TeamBenefitCard(
                          icon: Icons.emoji_events,
                          title: '주간 랭킹',
                          description: '다른 팀과 경쟁하며 성장하세요',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _TeamActionCard(
                gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)]),
                title: '새 팀 만들기',
                description: '당신이 리더가 되어 팀을 만들어보세요',
                icon: Icons.add,
                buttonLabel: '팀 만들기',
                onPressed: () => Navigator.of(context).pushNamed('/team/create'),
              ),
              const SizedBox(height: 16),
              _TeamActionCard(
                gradient: const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFF97316)]),
                title: '팀 참여하기',
                description: '친구의 팀 코드로 참여하세요',
                icon: Icons.group_add,
                buttonLabel: '팀 참여하기',
                onPressed: () => Navigator.of(context).pushNamed('/team/join'),
              ),
              const SizedBox(height: 32),
              Text('최근 팀 현황', style: theme.textTheme.titleMedium),
              const SizedBox(height: 16),
              const _TeamStatusList(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TeamBenefitCard extends StatelessWidget {
  const _TeamBenefitCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(description, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}

class _TeamActionCard extends StatelessWidget {
  const _TeamActionCard({
    required this.gradient,
    required this.title,
    required this.description,
    required this.icon,
    required this.buttonLabel,
    required this.onPressed,
  });

  final LinearGradient gradient;
  final String title;
  final String description;
  final IconData icon;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: gradient,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 16, offset: Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Text(title, style: theme.textTheme.titleLarge?.copyWith(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 12),
          Text(description, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70)),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blueGrey.shade900,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
            onPressed: onPressed,
            child: Text(buttonLabel),
          ),
        ],
      ),
    );
  }
}

class _TeamStatusList extends StatelessWidget {
  const _TeamStatusList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _TeamStatusTile(name: '김민준', lp: 850, streak: 7, status: TeamMemberStatus.success),
        _TeamStatusTile(name: '이서연', lp: 720, streak: 5, status: TeamMemberStatus.success),
        _TeamStatusTile(name: 'User', lp: 100, streak: 6, status: TeamMemberStatus.pending, highlight: true),
        _TeamStatusTile(name: '박지훈', lp: 560, streak: 2, status: TeamMemberStatus.fail),
      ],
    );
  }
}

enum TeamMemberStatus { success, fail, pending }

class _TeamStatusTile extends StatelessWidget {
  const _TeamStatusTile({
    required this.name,
    required this.lp,
    required this.streak,
    required this.status,
    this.highlight = false,
  });

  final String name;
  final int lp;
  final int streak;
  final TeamMemberStatus status;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = switch (status) {
      TeamMemberStatus.success => const Color(0xFF10B981),
      TeamMemberStatus.fail => const Color(0xFFF43F5E),
      TeamMemberStatus.pending => const Color(0xFFFACC15),
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: highlight ? const Color(0xFFF5F3FF) : Colors.white,
        border: highlight ? Border.all(color: const Color(0xFF8B5CF6), width: 2) : null,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 8))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFFFFF4D7),
            child: Text(name.characters.first, style: const TextStyle(color: Color(0xFF8B5CF6))),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('$lp LP · ${streak}일 연속',
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.blueGrey)),
              ],
            ),
          ),
          Icon(
            switch (status) {
              TeamMemberStatus.success => Icons.check_circle,
              TeamMemberStatus.fail => Icons.cancel,
              TeamMemberStatus.pending => Icons.pending,
            },
            color: statusColor,
          ),
        ],
      ),
    );
  }
}
