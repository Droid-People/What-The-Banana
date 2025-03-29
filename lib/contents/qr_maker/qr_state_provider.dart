import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:what_the_banana/contents/qr_maker/qr_state.dart';

final QrStateNotifierProvider = NotifierProvider<QrStateNotifier, QrState>(() {
  return QrStateNotifier();
});

class QrStateNotifier extends Notifier<QrState> {
  @override
  QrState build() {
    return QrState(data: '', imagePath: '', imageSize: 30);
  }

  void updateData(String newData) => state = state.copyWith(data: newData);

  void updateImagePath(String imagePath) =>
      state = state.copyWith(imagePath: imagePath);

  void updateImageSize(double imageSize) =>
      state = state.copyWith(imageSize: imageSize);

  void removeData() {
    state = state.copyWith(data: '');
    state.textEditingController.clear();
  }

  void removeImagePath() => state = state.copyWith(imagePath: '');

  Future<void> getImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    updateImagePath(image.path);
  }

  Future<void> saveQrCode(
    GlobalKey qrKey,
    void Function(String) showMessage,
  ) async {
    try {
      final boundary =
          qrKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      if (byteData == null) {
        showMessage('qr_save_fail');
        return;
      }
      await ImageGallerySaverPlus.saveImage(byteData.buffer.asUint8List());
      showMessage('qr_save_success');
    } on Exception catch (e) {
      showMessage('qr_save_fail');
      if (kDebugMode) {
        print('qr_error $e');
      }
    }
  }
}
