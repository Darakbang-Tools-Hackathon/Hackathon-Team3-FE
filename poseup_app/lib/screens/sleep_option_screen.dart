import 'package:flutter/material.dart';
import 'sleep_time_screen.dart';
import 'wake_time_screen.dart'; // ✅ 추가 (기상 시간 선택 화면 import)

class SleepOptionScreen extends StatelessWidget {
  const SleepOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF6),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.access_time_rounded,
                size: 80, color: Colors.orangeAccent),
            const SizedBox(height: 20),
            const Text(
              '알람을 설정해주세요',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '수면 주기에 맞춰 최적의 시간을 추천해드릴게요',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 60),

            // 🌙 잠들 시간 선택
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SleepTimeScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.deepPurpleAccent, width: 1),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.nightlight_round,
                        color: Colors.deepPurpleAccent, size: 40),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('잠들 시간 선택',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('잠든 시간을 기준으로 기상 시간 추천',
                            style: TextStyle(color: Colors.black54)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ☀️ 일어날 시간 선택
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WakeTimeScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.orangeAccent, width: 1),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.wb_sunny_rounded,
                        color: Colors.orangeAccent, size: 40),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('일어날 시간 선택',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('기상 시간을 기준으로 잠들 시간 추천',
                            style: TextStyle(color: Colors.black54)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
