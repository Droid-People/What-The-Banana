import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:what_the_banana/gen/assets.gen.dart';
import 'package:what_the_banana/ui/single_rotating_image_painter.dart';
import 'package:what_the_banana/ui/ui_utils.dart';

class SingleRotatingBananaController {
  SingleRotatingBananaController() {
    _controller = StreamController<String>();
  }

  StreamController<String>? _controller;

  void send(String status) {
    _controller?.add(status);
  }

  void dispose() {
    _controller?.sink.close();
    _controller?.close();
    _controller = null;
  }

  void listen(void Function(dynamic event) callback) {
    _controller?.stream.listen((event) {
      callback(event);
    });
  }
}

class SingleRotatingBanana extends StatefulWidget {
  const SingleRotatingBanana(this.controller, {super.key});

  final SingleRotatingBananaController controller;

  @override
  State<SingleRotatingBanana> createState() => _SingleRotatingBananaState();
}

class _SingleRotatingBananaState extends State<SingleRotatingBanana> with SingleTickerProviderStateMixin {

  Timer? _timer;
  double _angle = 0;
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadImage();
    });

    widget.controller.listen((event) {
      if (event == 'walking') {
        _resetTimer();
      } else {
        _stopTimer();
      }
    });

  }

  void _resetTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() {
        _angle += 0.05; // 회전 속도
        if (_angle > 2 * pi) _angle -= 2 * pi;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SingleRotatingImagePainter(_angle, _image),
      child: Container(),
    );
  }

  Future<void> _loadImage() async {
    final image = await loadUiImage(context, Assets.images.bigBanana.path);
    setState(() {
      _image = image;
    });
  }
}
