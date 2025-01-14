import 'package:flutter/material.dart';

Color getNegativeColor(Color color) {
  return Color.from(alpha: 1, red: 1 - color.r, green: 1 - color.g, blue: 1 - color.b);
}
