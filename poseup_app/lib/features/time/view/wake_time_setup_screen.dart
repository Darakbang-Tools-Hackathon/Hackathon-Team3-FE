import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/sleep_recommendation.dart';
import '../../../router/routes.dart';
import '../../team/view/team_landing_screen.dart';
import '../providers/wake_flow_provider.dart';

class WakeTimeSetupScreen extends ConsumerWidget {
  const WakeTimeSetupScreen({super.key});

  static const routePath = '/time/wake';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(wakeFlowControllerProvider);
    final controller = ref.read(wakeFlowControllerProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('기상 시간 설정'),
        actions: [
          TextButton(
            onPressed: () => context.push(TeamLandingScreen.routePath),
            child: const Text('다음'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView(
          children: [
            const SizedBox(height: 12),
            const _Header(),
            const SizedBox(height: 28),
            _BedtimePicker(
              bedtime: state.bedtime,
              onChanged: (time) => controller.updateBedtime(time),
            ),
            const SizedBox(height: 20),
            const _RemInfoCard(),
            const SizedBox(height: 24),
            Text(
              '추천 기상 시간',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...state.recommendations.map(
              (rec) => _RecommendationTile(
                recommendation: rec,
                selected: rec == state.selected,
                onTap: () {
                  controller.selectRecommendation(rec);
                  context.push(Routes.dashboard);
                },
              ),
            ),
            const SizedBox(height: 32),
            if (state.selected != null)
              _RecommendationSummary(recommendation: state.selected!),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF7695FF), Color(0xFF3853FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Icon(Icons.nightlight, color: Colors.white, size: 32),
        ),
        const SizedBox(height: 18),
        Text(
          '잠들 시간을 선택해주세요',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'REM 수면 주기에 맞춰 최적의 기상 시간을 추천해드릴게요',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.black54),
        ),
      ],
    );
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 8),
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
            const Icon(Icons.arrow_drop_down,
                size: 32, color: Color(0xFF253B80)),
          ],
        ),
      ),
    );
  }
}

class _RemInfoCard extends StatelessWidget {
  const _RemInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE6EEFF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('💤 수면 주기란?', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(
            '수면은 약 90분 주기로 반복되며, REM 수면 단계에서 깨면 상쾌하게 일어날 수 있어요. 일반적으로 잠들기까지 15분 정도 걸립니다.',
          ),
        ],
      ),
    );
  }
}

class _RecommendationTile extends StatelessWidget {
  const _RecommendationTile({
    required this.recommendation,
    required this.selected,
    required this.onTap,
  });

  final SleepRecommendation recommendation;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = recommendation.isHighlighted
        ? const [Color(0xFFFFD494), Color(0xFFFFB17A)]
        : const [Color(0xFFF2F4FF), Color(0xFFE4E6F9)];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: selected ? const Color(0xFF4F6BFF) : Colors.transparent,
          width: 2,
        ),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Text(
          recommendation.wakeTime.format(context),
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${recommendation.cycles}주기 · 총 ${recommendation.totalSleep.inHours}시간 ${(recommendation.totalSleep.inMinutes % 60).toString().padLeft(2, '0')}분 수면',
        ),
        trailing: recommendation.isHighlighted
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFED7F2B),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text('추천',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}

class _RecommendationSummary extends StatelessWidget {
  const _RecommendationSummary({required this.recommendation});

  final SleepRecommendation recommendation;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SummaryCard(
          title: '선택한 기상 시간',
          value: recommendation.wakeTime.format(context),
          subtitle:
              '${recommendation.cycles}주기 • 총 ${recommendation.totalSleep.inHours}시간 ${(recommendation.totalSleep.inMinutes % 60).toString().padLeft(2, '0')}분 수면',
          icon: Icons.eco,
        ),
        const SizedBox(height: 16),
        const _StatRow(),
        const SizedBox(height: 24),
        const _WeeklyProgressCard(),
        const SizedBox(height: 16),
        const _AchievementsCard(),
        const SizedBox(height: 16),
        const _TipsCard(),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFFF2D0),
            ),
            child: Icon(icon, color: const Color(0xFFED7F2B)),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(value, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(subtitle, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: _StatTile(title: '연속 성공', value: '5일')),
        SizedBox(width: 12),
        Expanded(child: _StatTile(title: '주간 성공률', value: '85%')),
        SizedBox(width: 12),
        Expanded(child: _StatTile(title: '달성 스트릭', value: '12')),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}

class _WeeklyProgressCard extends StatelessWidget {
  const _WeeklyProgressCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF6FFF3),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('이번 주 기록', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Text('✨ 이번 주 6일 성공! 내일도 화이팅!'),
        ],
      ),
    );
  }
}

class _AchievementsCard extends StatelessWidget {
  const _AchievementsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4E6),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('최근 업적', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Text('🏆 5일 연속 성공 · +50 LP'),
          SizedBox(height: 8),
          Text('🎯 주간 85% 달성 · +30 LP'),
        ],
      ),
    );
  }
}

class _TipsCard extends StatelessWidget {
  const _TipsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF8FF),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('💡 오늘의 팁', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Text('아침 햇빛을 쬐면 체내 시계가 재설정되어 숙면에 도움이 돼요.'),
        ],
      ),
    );
  }
}
