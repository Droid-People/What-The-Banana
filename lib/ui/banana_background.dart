import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:what_the_banana/gen/assets.gen.dart';

class BananaBackground extends StatefulWidget {
  const BananaBackground({super.key});

  @override
  State<BananaBackground> createState() => _BananaBackgroundState();
}

class _BananaBackgroundState extends State<BananaBackground>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  final imageCount = 12;
  final List<double> _angles = [];
  final List<Offset> _positions = [];

  final Random _random = Random();
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    _loadImage();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _initializePositionsAndAngles();
    });

    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() {
        for (var i = 0; i < _angles.length; i++) {
          _angles[i] += 0.05; // 회전 속도
          if (_angles[i] > 2 * pi) _angles[i] -= 2 * pi;
        }
      });
    });
  }

  void _initializePositionsAndAngles() {
    for (var i = 0; i < imageCount; i++) {
      _positions.add(_randomPosition());
      _angles.add(_random.nextDouble() * 2 * pi);
    }
  }

  Future<void> _loadImage() async {
    final image = await _loadUiImage(Assets.images.smallBanana.path);
    setState(() {
      _image = image;
    });
  }

  Future<ui.Image> _loadUiImage(String assetPath) async {
    final data = await DefaultAssetBundle.of(context).load(assetPath);
    final bytes = data.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  Offset _randomPosition() {
    // 화면 전체 크기에서 랜덤한 위치
    final dx = _random.nextDouble() * MediaQuery.of(context).size.width;
    final dy = _random.nextDouble() * MediaQuery.of(context).size.height;
    return Offset(dx, dy);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RotatingImagePainter(_angles, _positions, _image),
      child: Container(),
    );
  }
}

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
