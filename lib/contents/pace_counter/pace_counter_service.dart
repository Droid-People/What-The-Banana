import 'package:flutter/services.dart';
import 'package:what_the_banana/common/logger.dart';

const MethodChannel _channel = MethodChannel('pedometer/check');

Future<bool> isStepCountingAvailable() async {
  try {
    final result = await _channel.invokeMethod('isStepCountingAvailable');
    return result as bool;
  } on PlatformException catch (e) {
    Log.e("Error checking step counting availability: ${e.message}");
    return false;
  }
}