import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:what_the_banana/common/logger.dart';
import 'package:what_the_banana/contents/pace_counter/pace_counter_state.dart';
import 'package:what_the_banana/ui/single_rotating_banana.dart';

final paceCounterProvider = StateNotifierProvider<PaceCounterNotifier, StepCounterState>((ref) {
  return PaceCounterNotifier();
});

class PaceCounterNotifier extends StateNotifier<StepCounterState> {
  PaceCounterNotifier() : super(StepCounterState(steps: 0, distanceInKm: 0, status: ''));
  late SharedPreferences _prefs;

  int currentSteps = 0; // 현재 걸음 수
  int lastKnownStepsUntilYesterday = 0; // 부팅 시점부터 어제까지의 총 걸음 수

  final controller = SingleRotatingBananaController();
  StreamSubscription<PedestrianStatus>? _statusStream;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _statusStream = Pedometer.pedestrianStatusStream.listen((PedestrianStatus data) {
      if (state.status != data.status) {
        controller.send(data.status);
      }
      state = state.copyWith(status: data.status);
    });
  }

  Future<void> _onStepCount(StepCount event) async {
    final totalStep = event.steps; // 단말 부팅 이후 기록된 총 걸음 수
    var stepCount = 0;
    final savedStep = await _getLastSteps();
    if (savedStep == 0) {
      _saveLastSteps(totalStep);
    } else {
      stepCount = totalStep - savedStep;
    }
    _updateSteps(stepCount);
  }

  void _onStepCountError(dynamic error) {
    Log.d('Step Count Error: $error');
  }

  void _updateSteps(int newSteps) {
    state = state.copyWith(
      steps: newSteps,
      distanceInKm: _convertStepsToKm(newSteps),
    );
  }

  Future<void> _saveLastSteps(int steps) async {
    _prefs.setInt('last_steps', steps);
  }

  Future<int> _getLastSteps() async {
    return _prefs.getInt('last_steps') ?? 0;
  }

  double _convertStepsToKm(int steps) {
    const averageStepLength = 0.7;
    final distanceInMeters = steps * averageStepLength;
    return distanceInMeters / 1000;
  }

  StreamSubscription<StepCount>? _stepCountStream;

  void start() {
    _saveLastSteps(0);
    _stepCountStream = Pedometer.stepCountStream.listen(
      _onStepCount,
      onError: _onStepCountError,
    );
  }

  void stop() {
    _stepCountStream?.cancel();
    _stepCountStream = null;
  }

  @override
  void dispose() {
    Log.d('dispose');
    _statusStream?.cancel();
    _statusStream = null;
    stop();
    controller.dispose();
    super.dispose();
  }
}
