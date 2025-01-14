import 'package:flutter/material.dart';

class PixelArtState {
  PixelArtState({
    required this.arrayDeque,
    required this.gridMap,
    required this.pixelSize,
    required this.selectedColor,
    required this.pickColorState,
    required this.showGrid,
  });

  factory PixelArtState.initial() {
    return PixelArtState(
      arrayDeque: [],
      gridMap: [],
      pixelSize: 1,
      selectedColor: Colors.black,
      pickColorState: false,
      showGrid: true,
    );
  }

  final List<Color> arrayDeque;
  final List<List<Color>> gridMap;
  final int pixelSize;
  final Color selectedColor;
  final bool pickColorState;
  final bool showGrid;

  PixelArtState copyWith({
    List<Color>? arrayDeque,
    List<List<Color>>? gridMap,
    int? pixelSize,
    Color? selectedColor,
    bool? pickColorState,
    bool? showGrid,
  }) {
    return PixelArtState(
      arrayDeque: arrayDeque ?? this.arrayDeque,
      gridMap: gridMap ?? this.gridMap,
      pixelSize: pixelSize ?? this.pixelSize,
      selectedColor: selectedColor ?? this.selectedColor,
      pickColorState: pickColorState ?? this.pickColorState,
      showGrid: showGrid ?? this.showGrid,
    );
  }
}
