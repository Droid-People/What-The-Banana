import 'package:flutter/services.dart';

const MethodChannel _channel = MethodChannel('pedometer/check');

Future<bool> isStepCountingAvailable() async {
  try {
    final result = await _channel.invokeMethod('isStepCountingAvailable');
    return result as bool;
  } on PlatformException catch (e) {
    print("Error checking step counting availability: ${e.message}");
    return false;
  }
}