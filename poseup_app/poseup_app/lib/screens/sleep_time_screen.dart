import 'package:flutter/material.dart';
import '../widgets/time_picker.dart';
import '../widgets/sleep_cycle_info_box.dart';
import '../widgets/wake_time_card.dart';
import '../utils/sleep_calculator.dart';

class SleepTimeScreen extends StatefulWidget {
  const SleepTimeScreen({super.key});

  @override
  State<SleepTimeScreen> createState() => _SleepTimeScreenState();
}

class _SleepTimeScreenState extends State<SleepTimeScreen> {
  int hour = 11;
  int minute = 0;
  String period = 'PM';
  List<DateTime> recommendedTimes = [];

  void _calculateTimes() {
    final results = SleepCalculator.calculateWakeTimes(hour, minute, period);
    setState(() {
      recommendedTimes = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.nightlight_round, size: 80, color: Colors.orange),
            const SizedBox(height: 12),
            const Text(
              '잠들 시간을 선택해주세요',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            const Text(
              'REM 수면 주기에 맞춰 최적의 기상 시간을 추천해드릴게요',
              style: TextStyle(fontSize: 13, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TimePickerWidget(
              initialHour: hour,
              initialMinute: minute,
              initialPeriod: period,
              onChanged: (h, m, p) {
                setState(() {
                  hour = h;
                  minute = m;
                  period = p;
                });
                _calculateTimes();
              },
            ),
            const SizedBox(height: 20),
            const SleepCycleInfoBox(),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('추천 기상 시간',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 10),
            ...recommendedTimes.asMap().entries.map((entry) {
              int idx = entry.key;
              DateTime time = entry.value;
              return WakeTimeCard(
                time: time,
                isRecommended: idx == recommendedTimes.length - 1,
              );
            }),
          ],
        ),
      ),
    );
  }
}

