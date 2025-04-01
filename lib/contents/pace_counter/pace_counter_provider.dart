import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:what_the_banana/contents/pace_counter/pace_counter_state.dart';

final paceCounterProvider = StateNotifierProvider<PaceCounterNotifier, StepCounterState>((ref) {
  return PaceCounterNotifier();
});

class PaceCounterNotifier extends StateNotifier<StepCounterState> {
  PaceCounterNotifier() : super(StepCounterState(steps: 0, distanceInKm: 0));
  late StreamSubscription<StepCount> _stepCountStream;
  late SharedPreferences _prefs;

  int currentSteps = 0; // 현재 걸음 수
  int lastKnownStepsUntilYesterday = 0; // 부팅 시점부터 어제까지의 총 걸음 수

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    // _loadSteps();
    _initializePaceCounter();
    // _resetStepsAtMidnight();
  }

  void _initializePaceCounter() {
    print("pace counter initialize");
    _stepCountStream = Pedometer.stepCountStream.listen(
      _onStepCount,
      onError: _onStepCountError,
    );
  }

  void _onStepCount(StepCount event) {
    int totalStep = event.steps; // 단말 부팅 이후 기록된 총 걸음 수
    // // TODO: 최초 사용 고려해야 함
    //
    // if (lastKnownStepsUntilYesterday == 0) {
    //   _saveLastSteps(totalStep);
    //   lastKnownStepsUntilYesterday = totalStep;
    // }
    //
    //
    // int foregroundSteps = totalStep - lastKnownStepsUntilYesterday;
    // int backgroundSteps = foregroundSteps - currentSteps; // 백그라운드 걸음 수
    //
    // print("total $totalStep");
    // print("lastKnown: $lastKnownStepsUntilYesterday");
    // print("foregroundSteps: $foregroundSteps");
    // print("backgroundSteps: $backgroundSteps");
    // print("current: $currentSteps");
    // print("sum: ${foregroundSteps + backgroundSteps}");
    //
    // _updateSteps(foregroundSteps + backgroundSteps);
    _updateSteps(totalStep);
  }

  void _onStepCountError(dynamic error) {
    print("Step Count Error: $error");
  }

  Future<void> _loadSteps() async {
    currentSteps = _prefs.getInt('current_steps') ?? 0;
    lastKnownStepsUntilYesterday = _prefs.getInt('last_step') ?? 0;
    print("load current: $currentSteps");
    print("load last: $lastKnownStepsUntilYesterday");
  }


  void _updateSteps(int newSteps) {
    state = state.copyWith(
      steps: newSteps,
      distanceInKm: _convertStepsToKm(newSteps),
    );
    //_saveCurrentSteps(newSteps);
  }

  Future<void> _saveCurrentSteps(int steps) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('current_steps', steps);
  }

  Future<void> _saveLastSteps(int steps) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('last_steps', steps);
  }

  double _convertStepsToKm(int steps) {
    double averageStepLength = 0.7;
    double distanceInMeters = steps * averageStepLength;
    return distanceInMeters / 1000;
  }

  void _resetStepsAtMidnight() {
    DateTime now = DateTime.now();
    DateTime nextMidnight = DateTime(now.year, now.month, now.day + 1, 0, 0, 0);
    Duration timeUntilMidnight = nextMidnight.difference(now);

    Future.delayed(timeUntilMidnight, () {
      _saveCurrentSteps(0);
      _saveLastSteps(0);
      _resetStepsAtMidnight();
    });
  }
}