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
    this.flyImages,
  );

  final List<List<int>> ladder;
  final int numberOfLines;
  final bool showResult;
  final List<List<int>> pathPoints;
  final int? selectedStart;
  final double animationValue;
  final List<ui.Image> flyImages;
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

    final width = size.width - 22;
    final height = size.height; // 상하 여백을 고려하여 높이 조정
    final lineSpacing = width / (numberOfLines - 1);
    final rowHeight = height / 12;

    // Draw vertical lines
    for (var i = 0; i < numberOfLines; i++) {
      canvas.drawLine(
        Offset(i * lineSpacing + 11, topMargin),
        Offset(i * lineSpacing + 11, height + topMargin),
        paint,
      );
    }

    for (var row = 0; row < ladder.length; row++) {
      for (var col = 0; col < ladder[row].length; col++) {
        final y = row * rowHeight + topMargin;
        if (ladder[row][col] == 1) {
          canvas.drawLine(
            Offset(col * lineSpacing + 11, y),
            Offset((col + 1) * lineSpacing + 11, y),
            paint,
          );
        } else if (ladder[row][col] == 2 && col < numberOfLines - 1) {
          canvas.drawLine(
            Offset(col * lineSpacing + 11, y),
            Offset((col + 1) * lineSpacing + 11, y - rowHeight),
            paint,
          );
        } else if (ladder[row][col] == 3 && col < numberOfLines - 1) {
          canvas.drawLine(
            Offset(col * lineSpacing + 11, y),
            Offset((col + 1) * lineSpacing + 11, y + rowHeight),
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
        pathPoints[0][0] * lineSpacing + 11,
        pathPoints[0][1] * rowHeight + topMargin,
      );

      // 현재까지의 경로 그리기
      for (var i = 1; i <= currentIndex; i++) {
        path.lineTo(
          pathPoints[i][0] * lineSpacing + 11,
          pathPoints[i][1] * rowHeight + topMargin,
        );
      }

      // 다음 점과 보간하여 부드럽게 이어주기
      if (currentIndex < pathPoints.length - 1) {
        final current = pathPoints[currentIndex];
        final next = pathPoints[currentIndex + 1];
        final interpolatedX = ui.lerpDouble(current[0] * lineSpacing + 11, next[0] * lineSpacing + 11, t)!;
        final interpolatedY = ui.lerpDouble(current[1] * rowHeight, next[1] * rowHeight, t)! + topMargin;

        path.lineTo(interpolatedX, interpolatedY);
      }

      canvas.drawPath(path, pathPaint);
    }

    // 고정된 파리들과 움직이는 파리 그리기
    if (flyImages.isNotEmpty) {
      for (var i = 0; i < numberOfLines; i++) {
        // 선택된 출발점이 아니거나 애니메이션이 시작되지 않았을 때만 고정 파리 표시
        if (selectedStart != i || !showResult || animationValue == 0.0) {
          final imageOffset = Offset(i * lineSpacing + 11 - 11, topMargin - 20);
          canvas.drawImage(flyImages[i], imageOffset, Paint());
        }
      }

      // 애니메이션 중인 파리 그리기
      final flyPosition = getCurrentFlyPosition(lineSpacing, rowHeight);
      if (flyPosition != null) {
        final animatedFlyOffset = Offset(flyPosition.dx - 11, flyPosition.dy - 11);
        canvas.drawImage(flyImages[selectedStart!], animatedFlyOffset, Paint());
      }
    }
  }

  Offset? getCurrentFlyPosition(double lineSpacing, double rowHeight) {
    if (!showResult || selectedStart == null || pathPoints.isEmpty || flyImages.isEmpty) {
      return null;
    }

    final progress = animationValue.clamp(0.0, 1.0);
    final currentIndex = (progress * (pathPoints.length - 1)).floor();
    final t = (progress * (pathPoints.length - 1)) - currentIndex;

    if (currentIndex >= pathPoints.length - 1) {
      // 애니메이션 완료 시 마지막 위치
      final lastPoint = pathPoints.last;
      return Offset(
        lastPoint[0] * lineSpacing + 11,
        lastPoint[1] * rowHeight + topMargin,
      );
    }

    // 현재 위치와 다음 위치 사이를 보간
    final current = pathPoints[currentIndex];
    final next = pathPoints[currentIndex + 1];
    final interpolatedX = ui.lerpDouble(current[0] * lineSpacing + 11, next[0] * lineSpacing + 11, t)!;
    final interpolatedY = ui.lerpDouble(current[1] * rowHeight, next[1] * rowHeight, t)! + topMargin;

    return Offset(interpolatedX, interpolatedY);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
