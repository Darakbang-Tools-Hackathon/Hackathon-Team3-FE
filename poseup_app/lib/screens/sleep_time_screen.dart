import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
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

  @override
  void initState() {
    super.initState();
    _calculateTimes();
  }

  void _calculateTimes() {
    final results = SleepCalculator.calculateWakeTimes(hour, minute, period);
    setState(() {
      recommendedTimes = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
              const SizedBox(height: 24),
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '추천 기상 시간',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (recommendedTimes.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            '시간을 선택하면 추천 기상 시간이 표시됩니다.',
                            style: TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                        ),
                      ...recommendedTimes.asMap().entries.map((entry) {
                        int idx = entry.key;
                        DateTime time = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: WakeTimeCard(
                            time: time,
                            isRecommended: idx == recommendedTimes.length - 1,
                          ),
                        );
                      }),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: FilledButton(
          onPressed: recommendedTimes.isEmpty
              ? null
              : () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const DashboardScreen()),
                  );
                },
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            backgroundColor: const Color(0xFFFFB86C),
            foregroundColor: Colors.white,
          ),
          child: const Text('추천 시간으로 기상 알람 설정'),
        ),
      ),
    );
  }
}

