import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../router/routes.dart';
import '../../time/view/option_screen.dart';
import '../../time/view/wake_time_setup_screen.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  static const routePath = Routes.onboarding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5E6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFC977), Color(0xFFFFA85E)],
                  ),
                ),
                child: const Icon(Icons.wb_sunny, color: Colors.white, size: 64),
              ),
              const SizedBox(height: 28),
              Text(
                '좋은 아침을 시작하세요!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                '포즈 챌린지로 활기찬 하루를 만들어보세요',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
                const SizedBox(height: 32),
                Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    _LevelBadge(level: 'Lv.1', label: '씨앗'),
                    _LevelBadge(level: 'Lv.5', label: '해바라기'),
                    _LevelBadge(level: 'Lv.10', label: '햇살'),
                  ],
                ),
              ),
                const SizedBox(height: 32),
                _SocialButton(
                icon: Icons.login,
                label: 'Google로 시작하기',
                background: Colors.white,
                foreground: Colors.black87,
                onPressed: () => context.push(WakeTimeSetupScreen.routePath),
              ),
                const SizedBox(height: 12),
                _SocialButton(
                icon: Icons.apple,
                label: 'Apple로 시작하기',
                background: Colors.black,
                foreground: Colors.white,
                onPressed: () => context.push(WakeTimeSetupScreen.routePath),
              ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => context.push(OptionScreen.routePath),
                  child: const Text('시작하기'),
                ),
                const SizedBox(height: 20),
                Text(
                '계속 진행하면 이용약관 및 개인정보 처리방침에 동의하게 됩니다',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black54),
                textAlign: TextAlign.center,
              ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => context.push(Routes.dashboard),
                  child: const Text('둘러보기'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LevelBadge extends StatelessWidget {
  const _LevelBadge({required this.level, required this.label});

  final String level;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFFFF1D6),
            border: Border.all(color: const Color(0xFFFFC977)),
          ),
          child: Center(
            child: Text(level, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: foreground),
        label: Text(label, style: TextStyle(color: foreground, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
      ),
    );
  }
}

