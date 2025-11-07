import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/sleep_recommendation.dart';
import '../../../core/services/sleep_cycle_service.dart';

class WakeFlowState {
  const WakeFlowState({
    required this.bedtime,
    required this.recommendations,
    this.selected,
  });

  final TimeOfDay bedtime;
  final List<SleepRecommendation> recommendations;
  final SleepRecommendation? selected;

  WakeFlowState copyWith({
    TimeOfDay? bedtime,
    List<SleepRecommendation>? recommendations,
    SleepRecommendation? selected,
  }) {
    return WakeFlowState(
      bedtime: bedtime ?? this.bedtime,
      recommendations: recommendations ?? this.recommendations,
      selected: selected ?? this.selected,
    );
  }
}

class WakeFlowController extends StateNotifier<WakeFlowState> {
  WakeFlowController(this._service)
      : super(
          _initialState(_service),
        );

  final SleepCycleService _service;

  static WakeFlowState _initialState(SleepCycleService service) {
    final bedtime = const TimeOfDay(hour: 23, minute: 0);
    final recs = service.buildRecommendations(bedtime);
    final selected = recs.firstWhere(
      (it) => it.isHighlighted,
      orElse: () => recs.first,
    );
    return WakeFlowState(
      bedtime: bedtime,
      recommendations: recs,
      selected: selected,
    );
  }

  void updateBedtime(TimeOfDay bedtime) {
    final recommendations = _service.buildRecommendations(bedtime);
    final selected = recommendations.firstWhere(
      (it) => it.isHighlighted,
      orElse: () => recommendations.first,
    );
    state = state.copyWith(
      bedtime: bedtime,
      recommendations: recommendations,
      selected: selected,
    );
  }

  void selectRecommendation(SleepRecommendation recommendation) {
    state = state.copyWith(selected: recommendation);
  }
}

final wakeFlowControllerProvider =
    StateNotifierProvider<WakeFlowController, WakeFlowState>((ref) {
  final service = ref.watch(sleepCycleServiceProvider);
  return WakeFlowController(service);
});

