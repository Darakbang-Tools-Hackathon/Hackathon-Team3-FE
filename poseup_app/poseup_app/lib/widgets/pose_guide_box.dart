import 'package:flutter/material.dart';

class PoseGuideBox extends StatelessWidget {
  const PoseGuideBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Container(
          width: 240,
          decoration: BoxDecoration(
            border: Border.all(
                color: Colors.orangeAccent.withOpacity(0.6),
                width: 2,
                style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "이 자세를 따라해주세요!",
                style: TextStyle(color: Colors.orangeAccent, fontSize: 14),
              ),
              SizedBox(height: 20),
              Icon(Icons.accessibility_new,
                  size: 120, color: Colors.orangeAccent),
            ],
          ),
        ),
      ),
    );
  }
}
