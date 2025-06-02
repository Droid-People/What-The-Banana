import 'dart:typed_data';
import 'dart:ui' as ui;

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
  static const double topMargin = 25;

  Color getLineColor(int value) {
    switch (value) {
      case 0:
        return Colors.red;
      case 1:
        return const Color(0xFFFF7700);
      case 2:
        return const Color(0xFFF4CE23);
      case 3:
        return const Color(0xFF6CBA4F);
      case 4:
        return const Color(0xFF1363E3);
      case 5:
        return const Color(0xFF9000FF);
      default:
        return Colors.black; // 기본 색상
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    final pathPaint = Paint()
      ..color = getLineColor(selectedStart ?? 0)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final width = size.width;
    final height = size.height - 50; // 상하 여백을 고려하여 높이 조정
    final lineSpacing = width / (numberOfLines - 1);
    final rowHeight = height / 12;

    // Draw vertical lines
    for (var i = 0; i < numberOfLines; i++) {
      canvas.drawLine(
        Offset(i * lineSpacing, topMargin),
        Offset(i * lineSpacing, height + topMargin),
        paint,
      );
    }

    for (var row = 0; row < ladder.length; row++) {
      for (var col = 0; col < ladder[row].length; col++) {
        final y = row * rowHeight + topMargin;
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


    for (var i = 0; i < numberOfLines; i++) {
      final imageOffset = Offset(i * lineSpacing - 15, topMargin - 20); // 이미지 위치 조정
      final imageSize = Size(20, 20); // 이미지 크기 조정
      // flySvg.buffer.asUint8List() 로 ui.Image로 변환

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
        pathPoints[0][1] * rowHeight + topMargin,
      );

      // 현재까지의 경로 그리기
      for (var i = 1; i <= currentIndex; i++) {
        path.lineTo(
          pathPoints[i][0] * lineSpacing,
          pathPoints[i][1] * rowHeight + topMargin,
        );
      }

      // 다음 점과 보간하여 부드럽게 이어주기
      if (currentIndex < pathPoints.length - 1) {
        final current = pathPoints[currentIndex];
        final next = pathPoints[currentIndex + 1];
        final interpolatedX = ui.lerpDouble(current[0] * lineSpacing, next[0] * lineSpacing, t)!;
        final interpolatedY = ui.lerpDouble(current[1] * rowHeight, next[1] * rowHeight, t)! + topMargin;

        path.lineTo(interpolatedX, interpolatedY);
      }

      canvas.drawPath(path, pathPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
