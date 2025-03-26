import 'package:flutter/cupertino.dart';

class QrState {
  QrState({
    required this.data,
    required this.imagePath,
    required this.imageSize,
  }) : textEditingController = TextEditingController(text: data);

  final String data;
  final String imagePath;
  final double imageSize;
  final TextEditingController textEditingController;

  QrState copyWith({String? data, String? imagePath, double? imageSize}) {
    return QrState(
      data: data ?? this.data,
      imagePath: imagePath ?? this.imagePath,
      imageSize: imageSize ?? this.imageSize,
    )..textEditingController.text = data ?? this.data;
  }
}
