import 'package:flutter/material.dart';
import 'dart:async';

class PoseChallengeScreen extends StatefulWidget {
  const PoseChallengeScreen({super.key});

  @override
  State<PoseChallengeScreen> createState() => _PoseChallengeScreenState();
}

class _PoseChallengeScreenState extends State<PoseChallengeScreen> {
  int remainingSeconds = 300; // 5분 = 300초
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() => remainingSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get formattedTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D2233),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            // 남은 시간
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2F42),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orangeAccent),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('남은 시간',
                      style: TextStyle(color: Colors.white70, fontSize: 16)),
                  Text(formattedTime,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // 진행바
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (300 - remainingSeconds) / 300,
                color: Colors.orangeAccent,
                backgroundColor: Colors.white24,
                minHeight: 6,
              ),
            ),

            const SizedBox(height: 24),

            // 안내 문구
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Text(
                '이 자세를 따라해주세요!',
                style: TextStyle(
                    fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 24),

            // 포즈 이미지 영역 (가이드라인)
            Expanded(
              child: Center(
                child: Container(
                  width: 240,
                  height: 320,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.orangeAccent.withOpacity(0.7),
                        width: 2,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white.withOpacity(0.05),
                  ),
                  child: CustomPaint(
                    painter: _PoseStickFigurePainter(),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 포즈 상태 표시
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF383B4E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.redAccent),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.redAccent),
                      SizedBox(width: 6),
                      Text('포즈를 확인해주세요',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: 0.2,
                      color: Colors.redAccent,
                      backgroundColor: Colors.white12,
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '⚡ ML Kit Pose Detection 활성화',
                    style: TextStyle(color: Colors.amberAccent),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildPoseStatus('어깨', true),
                      _buildPoseStatus('팔꿈치', true),
                      _buildPoseStatus('무릎', false),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPoseStatus(String label, bool success) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 4),
        Icon(
          success ? Icons.check : Icons.remove,
          color: success ? Colors.greenAccent : Colors.amberAccent,
          size: 20,
        ),
      ],
    );
  }
}

// 🧍 간단한 스틱맨 가이드 그림
class _PoseStickFigurePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orangeAccent
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;
    final topY = 40.0;

    // 머리
    canvas.drawCircle(Offset(centerX, topY + 20), 20, paint);
    // 몸통
    canvas.drawLine(Offset(centerX, topY + 40), Offset(centerX, topY + 140), paint);
    // 팔
    canvas.drawLine(Offset(centerX - 60, topY + 80),
        Offset(centerX + 60, topY + 80), paint);
    // 다리
    canvas.drawLine(Offset(centerX, topY + 140),
        Offset(centerX - 40, topY + 240), paint);
    canvas.drawLine(Offset(centerX, topY + 140),
        Offset(centerX + 40, topY + 240), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
