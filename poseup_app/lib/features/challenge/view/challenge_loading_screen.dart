import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'challenge_screen.dart';

class ChallengeLoadingScreen extends StatefulWidget {
  const ChallengeLoadingScreen({super.key});

  static const routePath = '/challenge/loading';

  @override
  State<ChallengeLoadingScreen> createState() => _ChallengeLoadingScreenState();
}

class _ChallengeLoadingScreenState extends State<ChallengeLoadingScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      context.go(ChallengeScreen.routePath);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101526),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                strokeWidth: 6,
                valueColor: AlwaysStoppedAnimation(Color(0xFFFFB36C)),
              ),
            ),
            SizedBox(height: 24),
            Text(
              '카메라를 준비하고 있어요...',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

