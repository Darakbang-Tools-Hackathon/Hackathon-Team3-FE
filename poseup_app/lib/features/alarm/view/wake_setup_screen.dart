import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_state.dart';
import '../../../core/services/sleep_cycle_service.dart';
import '../../../router/routes.dart';

class WakeSetupScreen extends ConsumerStatefulWidget {
  const WakeSetupScreen({super.key});

  static const routePath = Routes.wakeSetup;
  static const routeName = 'wake-setup';

  @override
  ConsumerState<WakeSetupScreen> createState() => _WakeSetupScreenState();
}

class _WakeSetupScreenState extends ConsumerState<WakeSetupScreen> {
  TimeOfDay _selectedBedtime = const TimeOfDay(hour: 23, minute: 0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sleepService = ref.watch(sleepCycleServiceProvider);
    final suggestions = sleepService.wakeSuggestions(_selectedBedtime, suggestions: 4);

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1D4ED8), Color(0xFF0F172A)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('잠들 시간을 선택해주세요',
                                style: theme.textTheme.headlineSmall
                                    ?.copyWith(color: Colors.white)),
                            const SizedBox(height: 8),
                            Text(
                              'REM 수면 주기에 맞춰 최적의 기상 시간을 추천해드릴게요.',
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(color: Colors.white70),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: _selectedBedtime,
                        );
                        if (picked != null) {
                          setState(() => _selectedBedtime = picked);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: Colors.white24),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 20,
                              offset: Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _TimeDisplayBlock(value: _selectedBedtime.hourOfPeriod.toString().padLeft(2, '0')),
                                const SizedBox(width: 8),
                                const Text(':', style: TextStyle(fontSize: 40, color: Colors.white)),
                                const SizedBox(width: 8),
                                _TimeDisplayBlock(value: _selectedBedtime.minute.toString().padLeft(2, '0')),
                                const SizedBox(width: 16),
                                _TimeDisplayBlock(value: _selectedBedtime.period == DayPeriod.am ? 'AM' : 'PM'),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text('탭하여 시간 변경', style: theme.textTheme.bodySmall?.copyWith(color: Colors.white60)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.nightlight_round, color: Colors.white70),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '수면은 약 90분 주기로 반복되며, 잠들기까지 평균 15분이 소요돼요. REM 단계에서 기상하면 상쾌하게 일어날 수 있어요!',
                              style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                  final suggestion = suggestions[index];
                  final formatted = suggestion.time.format(context);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _SuggestionTile(
                      label: formatted,
                      cycles: suggestion.cycles,
                      duration: suggestion.formattedDuration,
                      isRecommended: suggestion.isRecommended,
                      onTap: () {
                        ref.read(wakeUpTimeProvider.notifier).state = formatted;
                        if (context.mounted) {
                          Navigator.of(context).pushNamed(Routes.challengePrepare);
                        }
                      },
                    ),
                  );
                  },
                  childCount: suggestions.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeDisplayBlock extends StatelessWidget {
  const _TimeDisplayBlock({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        value,
        style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  const _SuggestionTile({
    required this.label,
    required this.cycles,
    required this.duration,
    this.isRecommended = false,
    this.onTap,
  });

  final String label;
  final int cycles;
  final String duration;
  final bool isRecommended;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Ink(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: isRecommended
                ? [const Color(0xFF60A5FA), const Color(0xFF93C5FD)]
                : [Colors.white, Colors.white],
          ),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 8)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: isRecommended ? Colors.white : Colors.blueGrey.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${cycles}주기 · 약 $duration',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isRecommended ? Colors.white70 : Colors.blueGrey,
                  ),
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios, color: isRecommended ? Colors.white : Colors.blueGrey.shade300),
          ],
        ),
      ),
    );
  }
}

