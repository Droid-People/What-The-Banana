import 'package:flutter_riverpod/flutter_riverpod.dart';

final rouletteProvider = NotifierProvider.autoDispose<RouletteStateNotifier, RouletteState>(
  RouletteStateNotifier.new,
);

class RouletteStateNotifier extends Notifier<RouletteState> {
  @override
  RouletteState build() => RouletteState.initial();

  void setNumber(int number) {
    state = state.copyWith(number: number, rewards: List.generate(number, (index) => ''));
  }

  void setRewards(List<String> rewards) {
    state = state.copyWith(rewards: rewards);
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

  final int number;
  final List<String> rewards;

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
