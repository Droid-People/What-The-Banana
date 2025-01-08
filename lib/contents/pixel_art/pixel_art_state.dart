import 'package:flutter/material.dart';

class PixelArtState {
  PixelArtState({
    required this.arrayDeque,
    required this.gridMap,
    required this.pixelSize,
    required this.selectedColor,
  });

  List<Color> arrayDeque = [];
  List<List<Color>> gridMap = [];
  int pixelSize = 20;
  Color selectedColor = Colors.black;

  PixelArtState copyWith({
    List<Color>? arrayDeque,
    List<List<Color>>? gridMap,
    int? pixelSize,
    Color? selectedColor,
  }) {
    return PixelArtState(
      arrayDeque: arrayDeque ?? this.arrayDeque,
      gridMap: gridMap ?? this.gridMap,
      pixelSize: pixelSize ?? this.pixelSize,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }
}
