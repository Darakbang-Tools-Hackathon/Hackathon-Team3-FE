import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class WeeklyRecordCard extends StatelessWidget {
  const WeeklyRecordCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('이번 주 기록',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Icon(Icons.trending_up, color: AppColors.primaryBlue),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text('월'), Text('화'), Text('수'), Text('목'), Text('금'), Text('토'), Text('일'),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('✨ 이번 주 6일 성공! 내일도 화이팅!',
                style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }
}
