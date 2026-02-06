import 'package:flutter_riverpod/flutter_riverpod.dart';

final ghostLegStateProvider = NotifierProvider.autoDispose<GhostLegStateNotifier, GhostLegState>(
  GhostLegStateNotifier.new,
);

class GhostLegStateNotifier extends Notifier<GhostLegState> {
  @override
  GhostLegState build() => GhostLegState.initial();

  void setNumber(int number) {
    state = state.copyWith(number: number, names: List.generate(number, (index) => ''), rewards: List.generate(number, (index) => ''));
  }

  void setNames(List<String> names) {
    state = state.copyWith(names: names);
  }

  void setRewards(List<String> rewards) {
    state = state.copyWith(rewards: rewards);
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

  final int number;
  final List<String> names;
  final List<String> rewards;

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
