import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WakeTimeCard extends StatelessWidget {
  final DateTime time;
  final bool isRecommended;

  const WakeTimeCard({
    super.key,
    required this.time,
    this.isRecommended = false,
  });

  @override
  Widget build(BuildContext context) {
    final formatted = DateFormat('h:mm a').format(time);
    final cycles = isRecommended ? 5 : 4;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isRecommended ? Border.all(color: Colors.orange, width: 2) : null,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(formatted, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
              Text('$cycles주기 · 약 ${cycles * 1.5}시간 수면',
                  style: const TextStyle(fontSize: 13, color: Colors.grey)),
            ],
          ),
          if (isRecommended)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10)),
              child: const Text('권장', style: TextStyle(color: Colors.orange)),
            ),
        ],
      ),
    );
  }
}
