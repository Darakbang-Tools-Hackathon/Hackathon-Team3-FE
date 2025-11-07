import 'package:flutter/material.dart';

class PoseStatusBox extends StatelessWidget {
  final Map<String, String> status;

  const PoseStatusBox({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF181C27),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: status.entries.map((e) {
          return Column(
            children: [
              Text(e.key, style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 4),
              Text(e.value,
                  style: TextStyle(
                      color: e.value == '✓'
                          ? Colors.greenAccent
                          : Colors.orangeAccent,
                      fontSize: 20)),
            ],
          );
        }).toList(),
      ),
    );
  }
}
