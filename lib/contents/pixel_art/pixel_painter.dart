import 'package:flutter/material.dart';

class PixelPainter extends CustomPainter {
  PixelPainter({
    required this.gridMap,
    required this.pixels,
  });

  final List<List<Color>> gridMap;
  final int pixels;

  @override
  void paint(Canvas canvas, Size size) {
    final cellWidth = size.width / pixels;
    final cellHeight = size.height / pixels;

    // Draw grid cells
    for (var i = 0; i < pixels; i++) {
      for (var j = 0; j < pixels; j++) {
        final x = j * cellWidth;
        final y = i * cellHeight;
        final rect = Rect.fromLTWH(x, y, cellWidth, cellHeight);
        final paint = Paint()..color = gridMap[i][j];
        canvas.drawRect(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true; // Always repaint
  }
}

class PixelCropPainter extends CustomPainter {
  PixelCropPainter({
    required this.gridMap,
    required this.pixels,
  });

  final List<List<Color>> gridMap;
  final int pixels;

  @override
  void paint(Canvas canvas, Size size) {
    final cellWidth = size.width / pixels;
    final cellHeight = size.height / pixels;

    // Draw grid cells
    for (var i = 0; i < pixels; i++) {
      for (var j = 0; j < pixels; j++) {
        final x = j * cellWidth;
        final y = i * cellHeight;
        final rect = Rect.fromLTWH(x, y, cellWidth, cellHeight);
        final paint = Paint()..color = gridMap[i][j];
        canvas.drawRect(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true; // Always repaint
  }
}