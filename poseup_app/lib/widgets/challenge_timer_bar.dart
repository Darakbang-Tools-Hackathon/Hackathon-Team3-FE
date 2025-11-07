import 'package:flutter/material.dart';

class ChallengeTimerBar extends StatelessWidget {
  final Duration remaining;

  const ChallengeTimerBar({super.key, required this.remaining});

  @override
  Widget build(BuildContext context) {
    final minutes = remaining.inMinutes.remainder(60);
    final seconds = remaining.inSeconds.remainder(60);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1E2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orangeAccent, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('남은 시간',
              style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 6,
                width: 180,
                decoration: BoxDecoration(
                    color: Colors.orangeAccent.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4)),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.2, // 남은 비율 (임시값)
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(4)),
                  ),
                ),
              ),
              Text(
                '${minutes}:${seconds.toString().padLeft(2, '0')}',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
