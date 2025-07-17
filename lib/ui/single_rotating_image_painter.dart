import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:what_the_banana/common/logger.dart';

class SingleRotatingImagePainter extends CustomPainter {
  SingleRotatingImagePainter(this.angle, this.image);

  final double angle;
  final ui.Image? image;

  @override
  void paint(Canvas canvas, Size size) {
    if (image == null) return;
    final paint = Paint();

    canvas
      ..save()
      ..translate(size.width / 2, 0)
      ..rotate(angle)
      ..scale(0.15)
      ..drawImage(image!, Offset(-image!.width / 2, -image!.height / 2), paint)
      ..restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class RotatingImageWidget extends StatefulWidget {
  const RotatingImageWidget({required this.imagePath, required this.width, required this.height, super.key});

  final String imagePath;
  final double width;
  final double height;

  @override
  State<RotatingImageWidget> createState() => _RotatingImageWidgetState();
}

class _RotatingImageWidgetState extends State<RotatingImageWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _rotationSpeed = 0;
  bool _isIncreasing = true; // 속도 증가/감소 방향
  final double _maxSpeed = 60; // 최대 속도
  final double _speedStep = 3; // 속도 변화량
  ui.Image? image;

  @override
  void initState() {
    super.initState();
    loadUiImageFromAsset(widget.imagePath, targetWidth: widget.width.toInt(), targetHeight: widget.height.toInt()).then((result) {
      setState(() {
        image = result;
      });
    });

    _controller = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    setState(() {
      Log.i('RotatingImageWidget tapped: ${_rotationSpeed}');
      if (_rotationSpeed == 0) {
        // 첫 번째 터치 또는 정지 상태에서 재시작
        _rotationSpeed = _speedStep;
        _isIncreasing = true;
        _controller.duration = Duration(milliseconds: (6000 / _rotationSpeed).round());
        _controller.repeat();
      } else {
        // 속도 조절 로직
        if (_isIncreasing) {
          _rotationSpeed += _speedStep;
          if (_rotationSpeed >= _maxSpeed) {
            _rotationSpeed = _maxSpeed;
            _isIncreasing = false; // 최대 속도 도달, 이제 감소
          }
          _controller.duration = Duration(
            milliseconds: (6000 / _rotationSpeed).round(),
          );
          _controller.repeat();
        } else {
          _rotationSpeed -= _speedStep;
          if (_rotationSpeed <= 0) {
            _rotationSpeed = 0;
            _controller.stop(); // 회전 멈춤
            return; // 여기서 함수 종료, repeat() 호출하지 않음
          }
          _controller.duration = Duration(
            milliseconds: (6000 / _rotationSpeed).round(),
          );
          _controller.repeat();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (image == null) {
          return const SizedBox.shrink();
        }

        return GestureDetector(
          onTap: _onTap,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                size: Size(widget.width, widget.height),
                painter: SingleRotatingImagePainter(
                  _controller.value * 2 * 3.14159,
                  image,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<ui.Image> loadUiImageFromAsset(String assetPath, {int? targetWidth, int? targetHeight}) async {
    final data = await rootBundle.load(assetPath);
    final bytes = data.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: targetWidth,
      targetHeight: targetHeight,
    );
    final frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }
}
