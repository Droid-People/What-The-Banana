import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ghostLegStateProvider = StateNotifierProvider.autoDispose<GhostLegStateNotifier, GhostLegState>(
  (ref) => GhostLegStateNotifier(),
);

class GhostLegStateNotifier extends StateNotifier<GhostLegState> {
  GhostLegStateNotifier() : super(GhostLegState.initial());

  void setNumber(int number) {
    state = state.copyWith(number: number, names: List.generate(number, (index) => ''), rewards: List.generate(number, (index) => ''));
  }

  void setNames(List<String> names) {
    state = state.copyWith(names: names);
  }

  void setRewards(List<String> rewards) {
    state = state.copyWith(rewards: rewards);
  }

  void disposeController() {
    state.pageController.dispose();
  }
}

class GhostLegState {
  GhostLegState({
    required this.names,
    required this.rewards,
    this.number = 0,
  });

  factory GhostLegState.initial() {
    return GhostLegState(
      names: [],
      rewards: [],
    );
  }

  int number = 0;
  List<String> names = [];
  List<String> rewards = [];
  final PageController pageController = PageController();

  GhostLegState copyWith({
    List<String>? names,
    List<String>? rewards,
    int? number,
  }) {
    return GhostLegState(
      names: names ?? this.names,
      rewards: rewards ?? this.rewards,
      number: number ?? this.number,
    );
  }
}
