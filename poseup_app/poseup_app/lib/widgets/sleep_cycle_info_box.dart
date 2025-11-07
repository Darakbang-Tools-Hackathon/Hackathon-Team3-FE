import 'package:flutter/material.dart';

class SleepCycleInfoBox extends StatelessWidget {
  const SleepCycleInfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('💤 수면 주기란?', style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 6),
          Text(
            '수면은 약 90분 주기로 반복되며, REM 수면 단계에서 깨면 상쾌하게 일어날 수 있어요.\n일반적으로 잠들기까지 15분 정도 걸립니다.',
            style: TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
