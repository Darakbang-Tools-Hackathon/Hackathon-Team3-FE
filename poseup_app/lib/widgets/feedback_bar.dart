import 'package:flutter/material.dart';

class FeedbackBar extends StatelessWidget {
  final double progress;

  const FeedbackBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2F3C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orangeAccent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("좋아요! 조금만 더 정확하게!",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text("⚡ ML Kit Pose Detection 활성화",
              style: TextStyle(color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }
}
