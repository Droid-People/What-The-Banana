import 'package:flutter/material.dart';
import 'package:what_the_banana/contents/pixel_art/pixel_painter.dart';
import 'package:what_the_banana/gen/colors.gen.dart';

const int maxPixelCount = 64;

class PixelCanvas extends StatelessWidget {
  const PixelCanvas({
    required this.boardSize,
    required this.pixelSize,
    required this.gridMap,
    required this.gridState,
    required this.onStartRecord,
    required this.callback,
    super.key,
  });

  final double boardSize;
  final int pixelSize;
  final List<List<Color>> gridMap;
  final bool gridState;
  final void Function() onStartRecord;
  final void Function(int, int) callback;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: boardSize,
      height: boardSize,
      decoration: BoxDecoration(
        border: Border.all(color: ColorName.lightGrey),
      ),
      child: GestureDetector(
        onScaleStart: (details) {
          onStartRecord();
        },
        onScaleUpdate: (details) {
          _drawPixel(details.localFocalPoint, boardSize, pixelSize);
        },
        child: CustomPaint(
          size: Size(boardSize, boardSize),
          painter: PixelPainter(
            gridState: gridState,
            gridMap: gridMap,
            pixels: maxPixelCount,
          ),
        ),
      ),
    );
  }

  void _drawPixel(Offset offset, double paintSize, int pixelSize) {
    final adjustedOffset = offset;
    final y = ((adjustedOffset.dy / paintSize) * maxPixelCount).toInt();
    final x = ((adjustedOffset.dx / paintSize) * maxPixelCount).toInt();

    if (y >= 0 && y < maxPixelCount && x >= 0 && x < maxPixelCount) {
      callback(y, x);
    }
  }
}
