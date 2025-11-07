import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const PoseWakeApp());
}

class PoseWakeApp extends StatelessWidget {
  const PoseWakeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
