import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

final rouletteProvider = StateNotifierProvider.autoDispose<RouletteStateNotifier, RouletteState>(
      (ref) => RouletteStateNotifier(),
);

class RouletteStateNotifier extends StateNotifier<RouletteState> {
  RouletteStateNotifier() : super(RouletteState.initial());

  void setNumber(int number) {
    state = state.copyWith(number: number, rewards: List.generate(number, (index) => ''));
  }

  void setRewards(List<String> rewards) {
    state = state.copyWith(rewards: rewards);
  }

  void disposeController() {
    state.pageController.dispose();
  }
}

class RouletteState {
  RouletteState({
    required this.rewards,
    this.number = 0,
  });

  factory RouletteState.initial() {
    return RouletteState(
      rewards: [],
    );
  }

  int number = 0;
  List<String> rewards = [];
  final PageController pageController = PageController();

  RouletteState copyWith({
    List<String>? rewards,
    int? number,
  }) {
    return RouletteState(
      rewards: rewards ?? this.rewards,
      number: number ?? this.number,
    );
  }
}
