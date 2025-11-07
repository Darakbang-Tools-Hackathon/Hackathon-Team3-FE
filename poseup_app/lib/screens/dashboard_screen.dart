import 'package:flutter/material.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/level_card.dart';
import '../widgets/stat_card.dart';
import '../widgets/weekly_record_card.dart';
import '../widgets/achievement_list.dart';
import '../widgets/tip_card.dart';
import 'pose_challenge_screen.dart'; 

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void _goToChallenge(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PoseChallengeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFF),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ onStartPressed 콜백 추가
            DashboardHeader(
              userName: "User",
              nextChallenge: "5:15 AM",
              onStartPressed: () => _goToChallenge(context),
            ),
            const SizedBox(height: 20),
            const LevelCard(level: 1, lp: 0, maxLp: 500),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                StatCard(icon: Icons.calendar_month, label: '연속 성공', value: '5일'),
                StatCard(icon: Icons.emoji_events, label: '주간 성공률', value: '85%'),
                StatCard(icon: Icons.local_fire_department, label: '달성 스트릭', value: '12'),
              ],
            ),
            const SizedBox(height: 20),
            const WeeklyRecordCard(),
            const SizedBox(height: 20),
            const AchievementList(),
            const SizedBox(height: 20),
            const TipCard(),
          ],
        ),
      ),
    );
  }
}
