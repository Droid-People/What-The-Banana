import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:what_the_banana/common/logger.dart';
import 'package:what_the_banana/contents/pixel_art/pixel_art_state.dart';
import 'package:what_the_banana/contents/pixel_art/pixel_canvas.dart';
import 'package:what_the_banana/contents/pixel_art/pixel_painter.dart';

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
            pixelSize: 1,
            selectedColor: Colors.black,
          ),
        ) {
    setInitialColors();
    drawMapWhite();
  }

  void setGridMap(List<Color> colorList) {
    Log.i('colorList: ${colorList.length}');
    // colorList를 pixelSize x pixelSize로 나누어서 gridMap을 만든다.
    final gridMap = List.generate(
      maxPixelCount,
      (index) => List.generate(
        maxPixelCount,
        (index) => Colors.white,
      ),
    );

    for (var i = 0; i < colorList.length; i++) {
      final y = i ~/ maxPixelCount;
      final x = i % maxPixelCount;
      gridMap[y][x] = colorList[i];
    }

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

  void addFirstColor() {
    final deque = state.arrayDeque
      ..removeLast()
      ..insert(0, state.selectedColor);
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

  void changePixelColor(int i, int j) {
    final pixelSize = state.pixelSize;
    final gridMap = state.gridMap;

    // gridMap을 pixelSize x pixelSize로 나누어서 i, j를 찾아낸다.
    final y = i ~/ pixelSize;
    final x = j ~/ pixelSize;

    // y, x 위치에 pixelSize만큼 색을 채운다.
    for (var k = 0; k < pixelSize; k++) {
      for (var l = 0; l < pixelSize; l++) {
        if (y * pixelSize + k < maxPixelCount &&
            x * pixelSize + l < maxPixelCount) {
          gridMap[y * pixelSize + k][x * pixelSize + l] = state.selectedColor;
        }
      }
    }

    state = state.copyWith(gridMap: gridMap);
  }

  void setSelectedColor(Color color) {
    state = state.copyWith(selectedColor: color);
  }

  Future<void> shareImage(int boardSize) async {

    final pictureRecorder = ui.PictureRecorder();
    PixelCropPainter(
      gridMap: state.gridMap,
      pixels: maxPixelCount,
    ).paint(Canvas(pictureRecorder), Size(boardSize.toDouble(), boardSize.toDouble()));

    final image =
        await pictureRecorder.endRecording().toImage(boardSize, boardSize);

    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final tempFile = await _makeTempFile(bytes!.buffer.asUint8List());
    unawaited(Share.shareXFiles([XFile(tempFile.path)]));
  }

  Future<File> _makeTempFile(Uint8List bytes) async {
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;
    final tempFile = File('$tempPath/temp.png');
    await tempFile.writeAsBytes(bytes);
    return tempFile;
  }

  void increasePixelSize() {
    if (state.pixelSize < 16) {
      state = state.copyWith(pixelSize: state.pixelSize * 2);
    }
  }

  void decreasePixelSize() {
    if (state.pixelSize > 1) {
      state = state.copyWith(pixelSize: state.pixelSize ~/ 2);
    }
  }

  Future<void> pickImageFromCamera({
    void Function(String)? callbackImage,
  }) async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.camera);
    if (xFile == null) return;
    callbackImage?.call(xFile.path);
  }

  Future<void> pickImageFromGallery({
    void Function(String)? callbackImage,
  }) async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.gallery);
    if (xFile == null) return;
    callbackImage?.call(xFile.path);
  }
}
