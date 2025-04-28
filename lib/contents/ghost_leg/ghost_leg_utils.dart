// 입력 범위를 제한하는 커스텀 TextInputFormatter
import 'package:flutter/services.dart';

class NumberRangeFormatter extends TextInputFormatter {
  NumberRangeFormatter({required this.min, required this.max});

  final int min;
  final int max;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // 입력값이 비어있으면 허용
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // 입력값을 정수로 변환
    final value = int.tryParse(newValue.text);

    // 숫자가 아니거나 범위를 벗어나면 이전 값 유지
    if (value == null || value < min || value > max) {
      return oldValue;
    }

    // 유효한 입력값이면 그대로 반환
    return newValue;
  }
}
