import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../screens/my_page_screen.dart'; // ✅ 추가

class DashboardHeader extends StatelessWidget {
  final String userName;
  final String nextChallenge;
  final VoidCallback onStartPressed;

  const DashboardHeader({
    super.key,
    required this.userName,
    required this.nextChallenge,
    required this.onStartPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryBlue, AppColors.lightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 아이콘 라인
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('안녕하세요!',
                  style: TextStyle(color: Colors.white70, fontSize: 16)),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyPageScreen()),
                  );
                },
                icon: const Icon(Icons.person, color: Colors.white),
              ),
            ],
          ),
          Text('$userName님',
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const Icon(Icons.wb_sunny, color: Colors.white),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('다음 챌린지', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      Text(nextChallenge,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ]),
                ElevatedButton(
                  onPressed: onStartPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('시작'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
