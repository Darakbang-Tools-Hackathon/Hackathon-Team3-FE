import 'package:flutter/material.dart';
import '../widgets/challenge_timer_bar.dart';
import '../widgets/pose_guide_box.dart';
import '../widgets/feedback_bar.dart';
import '../widgets/pose_status_box.dart';

class PoseChallengeScreen extends StatefulWidget {
  const PoseChallengeScreen({super.key});

  @override
  State<PoseChallengeScreen> createState() => _PoseChallengeScreenState();
}

class _PoseChallengeScreenState extends State<PoseChallengeScreen> {
  double accuracy = 0.7;
  Duration remaining = const Duration(minutes: 5, seconds: 0);
  Map<String, String> status = {
    '어깨': '✓',
    '팔꿈치': '✓',
    '무릎': '~',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101422),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 뒤로가기 및 제목
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text("가이드 촬영중",
                      style: TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(width: 40),
                ],
              ),
              const SizedBox(height: 12),
              ChallengeTimerBar(remaining: remaining),
              const SizedBox(height: 20),
              const PoseGuideBox(),
              const SizedBox(height: 16),
              FeedbackBar(progress: accuracy),
              const SizedBox(height: 12),
              PoseStatusBox(status: {
                '어깨': '✓',
                '팔꿈치': '✓',
                '무릎': '~',
              }),
            ],
          ),
        ),
      ),
    );
  }
}
