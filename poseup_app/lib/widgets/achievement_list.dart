import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AchievementList extends StatelessWidget {
  const AchievementList({super.key});

  @override
  Widget build(BuildContext context) {
    final achievements = [
      {'title': '5일 연속 성공', 'desc': '2일 전 달성', 'lp': '+50 LP'},
      {'title': '주간 85% 달성', 'desc': '어제 달성', 'lp': '+30 LP'},
    ];

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
            children: [
              Icon(Icons.emoji_events, color: AppColors.primaryBlue),
              SizedBox(width: 6),
              Text('최근 업적',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 10),
          ...achievements.map((a) => Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.lightBlue.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a['title']!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15)),
                          Text(a['desc']!,
                              style: const TextStyle(
                                  fontSize: 13, color: AppColors.textGray)),
                        ]),
                    Text(a['lp']!,
                        style: const TextStyle(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
