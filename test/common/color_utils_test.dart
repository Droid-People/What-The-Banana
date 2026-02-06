import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:what_the_banana/common/color_utils.dart';

void main() {
  group('getNegativeColor', () {
    test('black returns white', () {
      final result = getNegativeColor(Colors.black);

      expect(result.a, 1.0);
      expect(result.r, closeTo(1.0, 0.01));
      expect(result.g, closeTo(1.0, 0.01));
      expect(result.b, closeTo(1.0, 0.01));
    });

    test('white returns black', () {
      final result = getNegativeColor(Colors.white);

      expect(result.a, 1.0);
      expect(result.r, closeTo(0.0, 0.01));
      expect(result.g, closeTo(0.0, 0.01));
      expect(result.b, closeTo(0.0, 0.01));
    });

    test('pure red returns cyan', () {
      final pureRed = const Color.fromRGBO(255, 0, 0, 1.0);
      final result = getNegativeColor(pureRed);

      // Red (1, 0, 0) -> Cyan (0, 1, 1)
      expect(result.a, 1.0);
      expect(result.r, closeTo(0.0, 0.01));
      expect(result.g, closeTo(1.0, 0.01));
      expect(result.b, closeTo(1.0, 0.01));
    });

    test('pure green returns magenta', () {
      final pureGreen = const Color.fromRGBO(0, 255, 0, 1.0);
      final result = getNegativeColor(pureGreen);

      // Green (0, 1, 0) -> Magenta (1, 0, 1)
      expect(result.a, 1.0);
      expect(result.r, closeTo(1.0, 0.01));
      expect(result.g, closeTo(0.0, 0.01));
      expect(result.b, closeTo(1.0, 0.01));
    });

    test('pure blue returns yellow', () {
      final pureBlue = const Color.fromRGBO(0, 0, 255, 1.0);
      final result = getNegativeColor(pureBlue);

      // Blue (0, 0, 1) -> Yellow (1, 1, 0)
      expect(result.a, 1.0);
      expect(result.r, closeTo(1.0, 0.01));
      expect(result.g, closeTo(1.0, 0.01));
      expect(result.b, closeTo(0.0, 0.01));
    });

    test('cyan returns red', () {
      final cyan = const Color.fromRGBO(0, 255, 255, 1.0);
      final result = getNegativeColor(cyan);

      // Cyan (0, 1, 1) -> Red (1, 0, 0)
      expect(result.a, 1.0);
      expect(result.r, closeTo(1.0, 0.01));
      expect(result.g, closeTo(0.0, 0.01));
      expect(result.b, closeTo(0.0, 0.01));
    });

    test('magenta returns green', () {
      final magenta = const Color.fromRGBO(255, 0, 255, 1.0);
      final result = getNegativeColor(magenta);

      // Magenta (1, 0, 1) -> Green (0, 1, 0)
      expect(result.a, 1.0);
      expect(result.r, closeTo(0.0, 0.01));
      expect(result.g, closeTo(1.0, 0.01));
      expect(result.b, closeTo(0.0, 0.01));
    });

    test('yellow returns blue', () {
      final yellow = const Color.fromRGBO(255, 255, 0, 1.0);
      final result = getNegativeColor(yellow);

      // Yellow (1, 1, 0) -> Blue (0, 0, 1)
      expect(result.a, 1.0);
      expect(result.r, closeTo(0.0, 0.01));
      expect(result.g, closeTo(0.0, 0.01));
      expect(result.b, closeTo(1.0, 0.01));
    });

    test('custom color returns correct negative', () {
      // RGB: (0.3, 0.6, 0.9)
      final customColor = const Color.fromRGBO(77, 153, 230, 1.0);
      final result = getNegativeColor(customColor);

      // Expected: (0.7, 0.4, 0.1)
      expect(result.a, 1.0);
      expect(result.r, closeTo(0.7, 0.01));
      expect(result.g, closeTo(0.4, 0.01));
      expect(result.b, closeTo(0.1, 0.01));
    });

    test('mid-range color (gray) returns mid-range color', () {
      final gray = const Color.fromRGBO(128, 128, 128, 1.0);
      final result = getNegativeColor(gray);

      // 128/255 ≈ 0.502, negative ≈ 0.498 ≈ 127/255
      expect(result.a, 1.0);
      expect(result.r, closeTo(0.5, 0.02));
      expect(result.g, closeTo(0.5, 0.02));
      expect(result.b, closeTo(0.5, 0.02));
    });

    test('alpha is always 1 regardless of input alpha', () {
      final transparentRed = const Color.fromRGBO(255, 0, 0, 0.5);
      final result = getNegativeColor(transparentRed);

      expect(result.a, 1.0);
      // Color values should still be inverted
      expect(result.r, closeTo(0.0, 0.01));
      expect(result.g, closeTo(1.0, 0.01));
      expect(result.b, closeTo(1.0, 0.01));
    });

    test('double negative returns original color', () {
      final original = const Color.fromRGBO(100, 150, 200, 1.0);
      final negative = getNegativeColor(original);
      final doubleNegative = getNegativeColor(negative);

      expect(doubleNegative.r, closeTo(original.r, 0.01));
      expect(doubleNegative.g, closeTo(original.g, 0.01));
      expect(doubleNegative.b, closeTo(original.b, 0.01));
    });

    group('edge cases', () {
      test('very dark color', () {
        final veryDark = const Color.fromRGBO(10, 10, 10, 1.0);
        final result = getNegativeColor(veryDark);

        expect(result.a, 1.0);
        expect(result.r, greaterThan(0.9));
        expect(result.g, greaterThan(0.9));
        expect(result.b, greaterThan(0.9));
      });

      test('very bright color', () {
        final veryBright = const Color.fromRGBO(245, 245, 245, 1.0);
        final result = getNegativeColor(veryBright);

        expect(result.a, 1.0);
        expect(result.r, lessThan(0.1));
        expect(result.g, lessThan(0.1));
        expect(result.b, lessThan(0.1));
      });
    });
  });
}
