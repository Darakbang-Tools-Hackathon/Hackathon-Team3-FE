import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 로고 아이콘
                const Icon(Icons.wb_sunny_rounded, size: 100, color: Colors.orange),
                const SizedBox(height: 20),

                // 텍스트
                const Text(
                  '좋은 아침을 시작하세요!',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  '포즈 챌린지로 활기찬 하루를 만들어보세요',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 40),

                // 레벨 아이콘 3개
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLevel(Icons.spa_rounded, 'Lv.1'),
                    const SizedBox(width: 20),
                    _buildLevel(Icons.local_florist_rounded, 'Lv.5'),
                    const SizedBox(width: 20),
                    _buildLevel(Icons.emoji_emotions_rounded, 'Lv.10'),
                  ],
                ),
                const SizedBox(height: 60),

                // 버튼: 시작하기 / 로그인 / 회원가입
                _buildButton(
                  text: '시작하기',
                  color: Colors.orange,
                  textColor: Colors.white,
                  onTap: () {},
                ),
                const SizedBox(height: 15),

                _buildButton(
                  text: '로그인',
                  color: Colors.white,
                  borderColor: Colors.orange,
                  textColor: Colors.orange,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                ),
                const SizedBox(height: 15),

                _buildButton(
                  text: '회원가입',
                  color: Colors.white,
                  borderColor: Colors.black26,
                  textColor: Colors.black87,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignupScreen()),
                    );
                  },
                ),

                const SizedBox(height: 30),
                const Text(
                  '계속 진행하면 이용약관 및 개인정보 처리방침에 동의하게 됩니다',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.black45),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLevel(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: Colors.orange, size: 36),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54)),
      ],
    );
  }

  Widget _buildButton({
    required String text,
    required Color color,
    Color? borderColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: borderColor ?? Colors.transparent, width: 1.5),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
