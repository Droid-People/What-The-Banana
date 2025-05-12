import 'dart:ui';

import 'package:flutter/material.dart';

class LadderPainter extends CustomPainter {
  LadderPainter(
    this.ladder,
    this.numberOfLines,
    this.showResult,
    this.pathPoints,
    this.selectedStart,
    this.animationValue,
  );

  final List<List<int>> ladder;
  final int numberOfLines;
  final bool showResult;
  final List<List<int>> pathPoints;
  final int? selectedStart;
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    final pathPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final width = size.width;
    final height = size.height;
    final lineSpacing = width / (numberOfLines - 1);
    final rowHeight = height / 12;

    // Draw vertical lines
    for (var i = 0; i < numberOfLines; i++) {
      canvas.drawLine(
        Offset(i * lineSpacing, 0),
        Offset(i * lineSpacing, height),
        paint,
      );
    }

    for (var row = 0; row < ladder.length; row++) {
      for (var col = 0; col < ladder[row].length; col++) {
        final y = row * rowHeight;
        if (ladder[row][col] == 1) {
          canvas.drawLine(
            Offset(col * lineSpacing, y),
            Offset((col + 1) * lineSpacing, y),
            paint,
          );
        } else if (ladder[row][col] == 2 && col < numberOfLines - 1) {
          canvas.drawLine(
            Offset(col * lineSpacing, y),
            Offset((col + 1) * lineSpacing, y - rowHeight),
            paint,
          );
        } else if (ladder[row][col] == 3 && col < numberOfLines - 1) {
          canvas.drawLine(
            Offset(col * lineSpacing, y),
            Offset((col + 1) * lineSpacing, y + rowHeight),
            paint,
          );
        }
      }
    }

    // Draw animated path
    if (showResult && selectedStart != null && pathPoints.isNotEmpty) {
      final path = Path();

      // animationValue를 0.0 ~ 1.0 사이로 보정
      final progress = animationValue.clamp(0.0, 1.0);
      final currentIndex = (progress * (pathPoints.length - 1)).floor();
      final t = (progress * (pathPoints.length - 1)) - currentIndex;

      // 시작점
      path.moveTo(
        pathPoints[0][0] * lineSpacing,
        pathPoints[0][1] * rowHeight,
      );

      // 현재까지의 경로 그리기
      for (int i = 1; i <= currentIndex; i++) {
        path.lineTo(
          pathPoints[i][0] * lineSpacing,
          pathPoints[i][1] * rowHeight,
        );
      }

      // 다음 점과 보간하여 부드럽게 이어주기
      if (currentIndex < pathPoints.length - 1) {
        final current = pathPoints[currentIndex];
        final next = pathPoints[currentIndex + 1];
        final interpolatedX = lerpDouble(current[0] * lineSpacing, next[0] * lineSpacing, t)!;
        final interpolatedY = lerpDouble(current[1] * rowHeight, next[1] * rowHeight, t)!;

        path.lineTo(interpolatedX, interpolatedY);
      }

      canvas.drawPath(path, pathPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
