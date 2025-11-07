import 'package:flutter/material.dart';

class WakeTimeSetScreen extends StatelessWidget {
  const WakeTimeSetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4E8),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wb_sunny_rounded,
                    color: Color(0xFFFFA858), size: 100),
                const SizedBox(height: 24),
                const Text(
                  "기상 시간 설정 완료!",
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5A3E00)),
                ),
                const SizedBox(height: 12),
                const Text(
                  "설정한 시간에 맞춰 건강한 하루를 시작해볼까요?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16, color: Color(0xFF6D4C00), height: 1.5),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFA858),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    "확인",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
