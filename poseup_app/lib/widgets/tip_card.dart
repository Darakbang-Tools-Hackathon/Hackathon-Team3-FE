import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class TipCard extends StatelessWidget {
  const TipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F6EE),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb, color: Colors.green),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              '아침 햇빛을 쬐면 체내 시계가 재설정되어 숙면에 도움이 됩니다. '
              '챌린지 후 창문을 열고 스트레칭해보세요!',
              style: TextStyle(fontSize: 13, color: AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }
}
