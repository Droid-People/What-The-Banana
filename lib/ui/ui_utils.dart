import 'dart:ui' as ui;

import 'package:flutter/material.dart';

Future<ui.Image> loadUiImage(BuildContext context, String assetPath) async {
  final data = await DefaultAssetBundle.of(context).load(assetPath);
  final bytes = data.buffer.asUint8List();
  final codec = await ui.instantiateImageCodec(bytes);
  final frame = await codec.getNextFrame();
  return frame.image;
}