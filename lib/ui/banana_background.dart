import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:what_the_banana/gen/assets.gen.dart';
import 'package:what_the_banana/ui/rotate_image_painter.dart';
import 'package:what_the_banana/ui/ui_utils.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _loadImage();
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
    final image = await loadUiImage(context, Assets.images.smallBanana.path);
    setState(() {
      _image = image;
    });
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
