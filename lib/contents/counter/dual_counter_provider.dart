import 'package:flutter_riverpod/legacy.dart';

final dualCounterProvider = StateNotifierProvider.autoDispose<DualCounterNotifier, DualCounterState>(
  (ref) => DualCounterNotifier(),
);

class DualCounterNotifier extends StateNotifier<DualCounterState> {
  DualCounterNotifier() : super(DualCounterState.initial());

  void incrementCount1() {
    state = state.copyWith(left: state.left + 1);
  }

  void decrementCount1() {
    if (state.left > 0) {
      state = state.copyWith(left: state.left - 1);
    }
  }

  void resetCount1() {
    state = state.copyWith(left: 0);
  }

  void incrementCount2() {
    state = state.copyWith(right: state.right + 1);
  }

  void decrementCount2() {
    if (state.right > 0) {
      state = state.copyWith(right: state.right - 1);
    }
  }

  void resetCount2() {
    state = state.copyWith(right: 0);
  }

  void reset() {
    state = DualCounterState.initial();
  }
}

class DualCounterState {

  DualCounterState({
    required this.left,
    required this.right,
  });

  factory DualCounterState.initial() {
    return DualCounterState(left: 0, right: 0);
  }
  final int left;
  final int right;

  DualCounterState copyWith({
    int? left,
    int? right,
  }) {
    return DualCounterState(
      left: left ?? this.left,
      right: right ?? this.right,
    );
  }
}