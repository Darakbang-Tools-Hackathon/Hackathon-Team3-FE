import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/sleep_cycle_service.dart';
import '../../../router/routes.dart';

class SleepTimeSetupScreen extends ConsumerStatefulWidget {
  const SleepTimeSetupScreen({super.key});

  static const routePath = '/time/sleep';

  @override
  ConsumerState<SleepTimeSetupScreen> createState() => _SleepTimeSetupScreenState();
}

class _SleepTimeSetupScreenState extends ConsumerState<SleepTimeSetupScreen> {
  TimeOfDay bedtime = const TimeOfDay(hour: 23, minute: 0);
  List<TimeOfDay> recommendations = const [];

  @override
  void initState() {
    super.initState();
    recommendations = ref.read(sleepCycleServiceProvider).calculateWakeTimes(bedtime, suggestions: 4);
  }

  void _updateBedTime(TimeOfDay time) {
    setState(() {
      bedtime = time;
      recommendations =
          ref.read(sleepCycleServiceProvider).calculateWakeTimes(bedtime, suggestions: 4);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        title: const Text('잠들 시간 기준 추천'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '잠들 시간을 선택해주세요',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _BedtimePicker(
              bedtime: bedtime,
              onChanged: _updateBedTime,
            ),
            const SizedBox(height: 24),
            const _SleepCycleInfo(),
            const SizedBox(height: 24),
            const Text(
              '추천 기상 시간',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: recommendations.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final time = recommendations[index];
                  final isPrimary = index == recommendations.length - 1;
                  return _WakeRecommendationTile(
                    time: time.format(context),
                    sleepDuration: _durationText(index + 3),
                    isRecommended: isPrimary,
                    onTap: () => context.push(Routes.dashboard),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _durationText(int cycles) {
    final total = const Duration(minutes: 15) + Duration(minutes: 90 * cycles);
    final hours = total.inHours;
    final minutes = total.inMinutes % 60;
    return minutes == 0 ? '$hours시간 수면' : '$hours시간 $minutes분 수면';
  }
}

class _BedtimePicker extends StatelessWidget {
  const _BedtimePicker({required this.bedtime, required this.onChanged});

  final TimeOfDay bedtime;
  final ValueChanged<TimeOfDay> onChanged;

  Future<void> _pick(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: bedtime,
    );
    if (picked != null) {
      onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pick(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              blurRadius: 16,
              offset: Offset(0, 8),
              color: Color(0x15000000),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              bedtime.format(context),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: const Color(0xFF253B80),
                  ),
            ),
            const Icon(Icons.arrow_drop_down, size: 32, color: Color(0xFF253B80)),
          ],
        ),
      ),
    );
  }
}

class _SleepCycleInfo extends StatelessWidget {
  const _SleepCycleInfo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE6EEFF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        '💤 수면 주기란?\n수면은 약 90분 주기로 반복되며, 잠들기까지 15분 정도 걸립니다. '
        '기상 알람을 수면 주기 종료 시점에 맞추면 더 상쾌하게 일어날 수 있어요.',
        style: TextStyle(height: 1.5),
      ),
    );
  }
}

class _WakeRecommendationTile extends StatelessWidget {
  const _WakeRecommendationTile({
    required this.time,
    required this.sleepDuration,
    required this.isRecommended,
    required this.onTap,
  });

  final String time;
  final String sleepDuration;
  final bool isRecommended;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isRecommended
                ? const [Color(0xFFFFD494), Color(0xFFFFB17A)]
                : const [Color(0xFFF2F4FF), Color(0xFFE4E6F9)],
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isRecommended ? const Color(0xFF4F6BFF) : Colors.transparent,
            width: 2,
          ),
        ),
        child: ListTile(
          title: Text(
            time,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('$sleepDuration · ${isRecommended ? '최적 추천' : '대안'}'),
          trailing: isRecommended
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFED7F2B),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    '추천',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

