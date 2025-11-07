import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'signup_screen.dart';
import 'sleep_time_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F2),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),

                // ☀️ 상단 아이콘
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB86C),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: const Icon(
                        Icons.wb_sunny_outlined,
                        color: Colors.white,
                        size: 70,
                      ),
                    ),
                    Container(
                      width: 34,
                      height: 34,
                      margin: const EdgeInsets.only(right: 6, bottom: 6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Color(0xFFFFB86C),
                        size: 20,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 36),

                const Text(
                  '좋은 아침을 시작하세요!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                const Text(
                  '포즈 챌린지로 활기찬 하루를 만들어보세요',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 36),

                // 🪴 레벨 아이콘
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLevelCard('Lv.1'),
                    const SizedBox(width: 16),
                    _buildLevelCard('Lv.5'),
                    const SizedBox(width: 16),
                    _buildLevelCard('Lv.10'),
                  ],
                ),

                const SizedBox(height: 50),

                // 🔹 회원가입 버튼
                _buildButton(
                  context,
                  label: '회원가입',
                  color: const Color(0xFFFFE0B2),
                  textColor: Colors.black87,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignupScreen()),
                    );
                  },
                ),
                const SizedBox(height: 14),

                // 🔹 로그인 버튼
                _buildButton(
                  context,
                  label: '로그인',
                  color: Colors.white,
                  textColor: Colors.black87,
                  border: true,
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const DashboardScreen()),
                    );
                  },
                ),
                const SizedBox(height: 14),

                // 🔹 시작하기 버튼
                _buildButton(
                  context,
                  label: '시작하기',
                  color: const Color(0xFFFFB86C),
                  textColor: Colors.white,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SleepTimeScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                const Text(
                  '계속 진행하면 이용약관 및 개인정보 처리방침에 동의하게 됩니다',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black45,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 버튼 위젯
  Widget _buildButton(BuildContext context,
      {required String label,
      required Color color,
      required Color textColor,
      bool border = false,
      required VoidCallback onTap}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        border: border ? Border.all(color: Colors.black26) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextButton(
        onPressed: onTap,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }

  // 레벨 박스
  Widget _buildLevelCard(String label) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFFFFE0B2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_florist, color: Colors.brown, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
