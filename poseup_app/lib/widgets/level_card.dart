import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class LevelCard extends StatelessWidget {
  final int level;
  final int lp;
  final int maxLp;

  const LevelCard({super.key, required this.level, required this.lp, required this.maxLp});

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
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: const Icon(Icons.eco, color: AppColors.primaryBlue, size: 36),
              ),
              const SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Level $level',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 6),
                SizedBox(
                  width: 200,
                  child: LinearProgressIndicator(
                    value: lp / maxLp,
                    color: AppColors.primaryBlue,
                    backgroundColor: AppColors.lightBlue,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                Text('다음 레벨까지 ${maxLp - lp} LP',
                    style: const TextStyle(color: AppColors.textGray, fontSize: 12)),
              ]),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.lightBlue.withOpacity(0.4),
            ),
            child: const Text('🌱 잘 하고 있어요! 계속 도전하세요!',
                style: TextStyle(color: AppColors.primaryBlue)),
          ),
        ],
      ),
    );
  }
}
