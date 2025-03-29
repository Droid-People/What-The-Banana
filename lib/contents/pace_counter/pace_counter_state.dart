class StepCounterState {
  StepCounterState({
    required this.steps,
    required this.distanceInKm,
  });

  final int steps;
  final double distanceInKm;

  StepCounterState copyWith({
    int? steps,
    double? distanceInKm,
  }) {
    return StepCounterState(
      steps: steps ?? this.steps,
      distanceInKm: distanceInKm ?? this.distanceInKm,
    );
  }
}