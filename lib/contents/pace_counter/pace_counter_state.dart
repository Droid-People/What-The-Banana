class StepCounterState {
  StepCounterState({
    required this.steps,
    required this.distanceInKm,
    required this.status,
  });

  final int steps;
  final double distanceInKm;
  final String status;

  StepCounterState copyWith({
    int? steps,
    double? distanceInKm,
    String? status,
  }) {
    return StepCounterState(
      steps: steps ?? this.steps,
      distanceInKm: distanceInKm ?? this.distanceInKm,
      status: status ?? this.status,
    );
  }
}