import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../router/routes.dart';

class TeamScreen extends ConsumerWidget {
  const TeamScreen({super.key});

  static const routePath = Routes.team;
  static const routeName = 'team';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('우리 팀 대시보드')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Card(
            child: ListTile(
              leading: Icon(Icons.emoji_events),
              title: Text('팀 LP 15,000'),
              subtitle: Text('오늘 팀 성공률: 86%'),
            ),
          ),
          const SizedBox(height: 16),
          Text('주간 랭킹 (스텁)', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          const _TeamMemberTile(name: '김포즈', streak: 5, status: '성공'),
          const _TeamMemberTile(name: '이수면', streak: 3, status: '성공'),
          const _TeamMemberTile(name: '박알람', streak: 1, status: '실패'),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('팀 생성/참여 (스텁)'),
          ),
        ],
      ),
    );
  }
}

class _TeamMemberTile extends StatelessWidget {
  const _TeamMemberTile({
    required this.name,
    required this.status,
    required this.streak,
  });

  final String name;
  final String status;
  final int streak;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text(name.substring(0, 1))),
        title: Text(name),
        subtitle: Text('주간 성공 횟수: $streak'),
        trailing: Text(status),
      ),
    );
  }
}
