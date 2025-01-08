import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:what_the_banana/contents/pixel_art/pixel_art_state.dart';

final pixelArtStateNotifierProvider =
    StateNotifierProvider<PixelArtStateProvider, PixelArtState>((ref) {
  return PixelArtStateProvider();
});

class PixelArtStateProvider extends StateNotifier<PixelArtState> {
  PixelArtStateProvider()
      : super(
          PixelArtState(
            arrayDeque: [],
            gridMap: [],
            pixelSize: 20,
            selectedColor: Colors.black,
          ),
        ) {
    setInitialColors();
    drawMapWhite();
  }

  static const maxPixelCount = 160;

  void setPixelSize(int size) {
    state = state.copyWith(pixelSize: size);
  }

  void setGridMap(List<List<Color>> gridMap) {
    state = state.copyWith(gridMap: gridMap);
  }

  void setInitialColors() {
    final deque = state.arrayDeque
      ..add(const Color(0xFFFF0000))
      ..add(const Color(0xFFFF7F00))
      ..add(const Color(0xFFFFFF00))
      ..add(const Color(0xFF00FF00))
      ..add(const Color(0xFF007FFF))
      ..add(const Color(0xFF0000FF))
      ..add(const Color(0xFF7F00FF))
      ..add(const Color(0xFF000000))
      ..addAll(List.generate(10, (index) => Colors.white));
    state = state.copyWith(arrayDeque: deque);
  }

  void addFirstColor(Color color) {
    final deque = state.arrayDeque
      ..removeLast()
      ..insert(0, color);
    state = state.copyWith(arrayDeque: deque);
  }

  void drawMapWhite() {
    final gridMap = List.generate(
      maxPixelCount,
      (index) => List.generate(
        maxPixelCount,
        (index) => Colors.white,
      ),
    );
    state = state.copyWith(gridMap: gridMap);
  }

  Picture createSamplePicture(double width, double height) {
    final recorder = PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromPoints(
        Offset.zero,
        Offset(width, height),
      ),
    );

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromPoints(
        Offset.zero,
        Offset(width, height),
      ),
      paint,
    );

    return recorder.endRecording();
  }

  void changePixelColor(int i, int j) {
    final gridMap = state.gridMap;
    gridMap[i][j] = state.selectedColor;
    state = state.copyWith(gridMap: gridMap);
  }

  void setSelectedColor(Color color) {
    state = state.copyWith(selectedColor: color);
  }
}
