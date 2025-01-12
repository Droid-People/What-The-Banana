import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:what_the_banana/gen/colors.gen.dart';

const int defaultPixelCount = 128;

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

  
  @override
  Widget build(BuildContext context) {

    return Container(
      width: widget.boardSize,
      height: widget.boardSize,
      decoration: BoxDecoration(
        border: Border.all(color: ColorName.lightGrey),
      ),
      child: GestureDetector(
        onTapUp: (details) {
          _drawPixel(details.localPosition, widget.boardSize, widget.pixelSize);
        },
        onPanUpdate: (details) {
          _drawPixel(details.localPosition, widget.boardSize, widget.pixelSize);
        },
        child: CustomPaint(
          size: Size(widget.boardSize, widget.boardSize),
          painter: PixelPainter(
            gridMap: widget.gridMap,
            pictureRecorder: widget.pictureRecorder,
            callback: widget.callback,
            pixels: defaultPixelCount,
          ),
        ),
      ),
    );
  }

  void _drawPixel(Offset offset, double paintSize, int pixelSize) {

    final y = ((offset.dy / paintSize) * defaultPixelCount).toInt();
    final x = ((offset.dx / paintSize) * defaultPixelCount).toInt();

    if (y >= 0 && y < defaultPixelCount && x >= 0 && x < defaultPixelCount) {
      widget.callback(y, x);
    }
  }
}

class PixelPainter extends CustomPainter {
  PixelPainter({
    required this.gridMap,
    required this.pictureRecorder,
    required this.callback,
    required this.pixels,
  });

  final List<List<Color>> gridMap;
  final PictureRecorder pictureRecorder;
  final void Function(int, int) callback;
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
