import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class RotatingImagePainter extends CustomPainter {
  RotatingImagePainter(this.angles, this.positions, this.image);

  final List<double> angles;
  final List<Offset> positions;
  final ui.Image? image;

  @override
  void paint(Canvas canvas, Size size) {
    if (image == null) return;
    final paint = Paint();

    for (var i = 0; i < positions.length; i++) {
      final angle = angles[i];
      final position = positions[i];
      canvas
        ..save()
        ..translate(position.dx, position.dy)
        ..rotate(angle)
        ..drawImage(image!, Offset(-image!.width / 2, -image!.height / 2), paint)
        ..restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
