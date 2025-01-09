import 'dart:ui';

import 'package:flutter/material.dart';

const int maxPixelCount = 160;

class PixelCanvas extends StatefulWidget {
  const PixelCanvas({
    required this.boardSize, required this.pixelSize, required this.gridMap, required this.pictureRecorder, required this.callback, super.key,
  });

  final double boardSize;
  final int pixelSize;
  final List<List<Color>> gridMap;
  final PictureRecorder pictureRecorder;
  final void Function(int, int) callback;

  @override
  State<PixelCanvas> createState() => _PixelCanvasState();
}

class _PixelCanvasState extends State<PixelCanvas> {
  late int pixels;

  @override
  void initState() {
    super.initState();
    pixels = maxPixelCount ~/ widget.pixelSize;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        _drawPixel(details.localPosition);
      },
      onPanUpdate: (details) {
        _drawPixel(details.localPosition);
      },
      child: CustomPaint(
        size: Size(widget.boardSize, widget.boardSize),
        painter: PixelPainter(
          gridMap: widget.gridMap,
          pictureRecorder: widget.pictureRecorder,
          callback: widget.callback,
          pixelSize: widget.pixelSize,
          pixels: pixels,
        ),
      ),
    );
  }

  void _drawPixel(Offset offset) {
    pixels = maxPixelCount ~/ widget.pixelSize;

    final i = ((offset.dy / widget.boardSize) * pixels).toInt();
    final j = ((offset.dx / widget.boardSize) * pixels).toInt();

    if (i >= 0 && i < pixels && j >= 0 && j < pixels) {
      widget.callback(i, j);
    }
  }
}

class PixelPainter extends CustomPainter {
  PixelPainter({
    required this.gridMap,
    required this.pictureRecorder,
    required this.callback,
    required this.pixelSize,
    required this.pixels,
  });

  final List<List<Color>> gridMap;
  final PictureRecorder pictureRecorder;
  final void Function(int, int) callback;
  final int pixelSize;
  final int pixels;

  @override
  void paint(Canvas canvas, Size size) {
    final cellWidth = size.width / pixels;
    final cellHeight = size.height / pixels;

    final recorderCanvas = Canvas(pictureRecorder);

    // Draw grid cells
    for (var i = 0; i < pixels; i++) {
      for (var j = 0; j < pixels; j++) {
        final x = j * cellWidth;
        final y = i * cellHeight;
        final rect = Rect.fromLTWH(x, y, cellWidth, cellHeight);
        final paint = Paint()..color = gridMap[i][j];
        canvas.drawRect(rect, paint);
        recorderCanvas.drawRect(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true; // Always repaint
  }
}
