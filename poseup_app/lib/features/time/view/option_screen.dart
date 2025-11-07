import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../router/routes.dart';
import 'sleep_time_setup_screen.dart';
import 'wake_time_setup_screen.dart';

class OptionScreen extends StatelessWidget {
  const OptionScreen({super.key});

  static const routePath = Routes.options;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.access_time_filled_rounded,
                size: 80,
                color: Color(0xFFFFA64C),
              ),
              const SizedBox(height: 20),
              const Text(
                '알람을 설정해주세요',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '수면 주기에 맞춰 최적의 시간을 추천해드릴게요',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
              const SizedBox(height: 40),
              _OptionCard(
                backgroundColor: const Color(0xFFF4EBFF),
                borderColor: const Color(0xFFB388FF),
                iconColor: const Color(0xFF8E24AA),
                icon: Icons.nightlight_round,
                title: '잠들 시간 선택',
                description: '잠들 시간을 기준으로 기상 시간 추천',
                onTap: () => context.push(SleepTimeSetupScreen.routePath),
              ),
              const SizedBox(height: 20),
              _OptionCard(
                backgroundColor: const Color(0xFFFFF2E0),
                borderColor: const Color(0xFFFFB74D),
                iconColor: const Color(0xFFFFA726),
                icon: Icons.wb_sunny_rounded,
                title: '일어날 시간 선택',
                description: '기상 시간을 기준으로 잠들 시간 추천',
                onTap: () => context.push(WakeTimeSetupScreen.routePath),
              ),
              const SizedBox(height: 40),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F0FF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFB0C4DE)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.auto_awesome_rounded,
                        color: Colors.blueAccent, size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '💤 수면 주기란?\n수면은 약 90분 주기로 반복되며, REM 수면 단계에서 깨면 상쾌하게 일어날 수 있어요.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconColor,
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
