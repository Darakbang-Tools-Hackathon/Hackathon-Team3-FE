import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const routePath = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('마이페이지'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD494), Color(0xFFFFB17A)],
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(Icons.person, size: 40, color: Color(0xFFED7F2B)),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('User님', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(height: 6),
                      Text('Level 3 · 1,250 LP', style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const _ProfileSection(
              title: '활동 요약',
              children: [
                _ProfileTile(icon: Icons.sunny, label: '이번 주 성공', value: '6회'),
                _ProfileTile(icon: Icons.leaderboard, label: '주간 랭킹', value: '#3'),
                _ProfileTile(icon: Icons.local_fire_department, label: '연속 스트릭', value: '14일'),
              ],
            ),
            const SizedBox(height: 24),
            const _ProfileSection(
              title: '알람 & 포즈 설정',
              children: [
                _ProfileTile(icon: Icons.alarm, label: '기상 시간', value: '06:45 AM'),
                _ProfileTile(icon: Icons.nightlight_round, label: '취침 시간', value: '11:00 PM'),
                _ProfileTile(icon: Icons.bolt, label: '포즈 난이도', value: '보통'),
              ],
            ),
            const SizedBox(height: 24),
            const _ProfileSection(
              title: '팀 정보',
              children: [
                _ProfileTile(icon: Icons.groups, label: '소속 팀', value: '아침 챔피언스'),
                _ProfileTile(icon: Icons.code, label: '팀 코드', value: 'WAKE2024'),
                _ProfileTile(icon: Icons.emoji_events, label: '팀 순위', value: '#3 / 14'),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
              child: const Text('로그아웃 (스텁)'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF6F6FF),
            ),
            child: Icon(icon, color: const Color(0xFF6A5AE0)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

