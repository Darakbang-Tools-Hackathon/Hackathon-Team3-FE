import 'package:flutter/material.dart';
import '../utils/sleep_calculator.dart';
import 'blue_dashboard_screen.dart';

class WakeTimeScreen extends StatefulWidget {
  const WakeTimeScreen({super.key});

  @override
  State<WakeTimeScreen> createState() => _WakeTimeScreenState();
}

class _WakeTimeScreenState extends State<WakeTimeScreen> {
  int hour = 7;
  int minute = 0;
  String period = 'AM';
  
  get Sleep_Calculator => null;

  @override
  Widget build(BuildContext context) {
    final bedTimes = Sleep_Calculator.calculateBedTimes(hour, minute, period);

    return Scaffold(
      backgroundColor: const Color(0xFFE6F0FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.wb_sunny_rounded, size: 72, color: Color(0xFF2E6AE6)),
            const SizedBox(height: 16),
            const Text('기상 시간을 선택해주세요',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('수면 주기에 맞춰 최적의 취침 시간을 추천해드릴게요.',
                style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 24),

            // 시간 선택 드롭다운
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<int>(
                  value: hour,
                  items: List.generate(12, (i) => i + 1)
                      .map((h) => DropdownMenuItem(value: h, child: Text(h.toString())))
                      .toList(),
                  onChanged: (v) => setState(() => hour = v!),
                ),
                const Text(' : '),
                DropdownButton<int>(
                  value: minute,
                  items: const [0, 15, 30, 45]
                      .map((m) => DropdownMenuItem(value: m, child: Text(m.toString().padLeft(2, '0'))))
                      .toList(),
                  onChanged: (v) => setState(() => minute = v!),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: period,
                  items: const ['AM', 'PM']
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (v) => setState(() => period = v!),
                ),
              ],
            ),

            const SizedBox(height: 28),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('🌙 추천 취침 시간', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: bedTimes.length,
                itemBuilder: (context, index) {
                  final time = bedTimes[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlueDashboardScreen(recommendedBedTime: time),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF2E6AE6), width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(time, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
