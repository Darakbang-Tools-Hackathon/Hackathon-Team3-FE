import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SleepTimeCard extends StatelessWidget {
  final DateTime time;
  final bool isRecommended;

  const SleepTimeCard({
    super.key,
    required this.time,
    this.isRecommended = false,
  });

  @override
  Widget build(BuildContext context) {
    final formatted = DateFormat('h:mm a').format(time);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isRecommended
            ? const Color(0xFFFFA858).withOpacity(0.15)
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRecommended
              ? const Color(0xFFFFA858)
              : Colors.grey.shade300,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(formatted,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          if (isRecommended)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                  color: const Color(0xFFFFA858),
                  borderRadius: BorderRadius.circular(8)),
              child: const Text("추천",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }
}
