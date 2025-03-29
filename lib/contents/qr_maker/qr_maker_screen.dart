import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:what_the_banana/contents/qr_maker/qr_state.dart';
import 'package:what_the_banana/contents/qr_maker/qr_state_provider.dart';
import 'package:what_the_banana/ui/back_button.dart';

final qrKeyProvider = Provider<GlobalKey>((ref) => GlobalKey());

// TODO(yewon-yw): 광고 배너, 슬라이더
class QrMakerScreen extends ConsumerWidget {
  const QrMakerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qrKey = ref.watch(qrKeyProvider);
    final qrState = ref.watch(QrStateNotifierProvider);
    final viewModel = ref.read(QrStateNotifierProvider.notifier);

    void showSnackBar(String text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text).tr()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('qr_maker_title').tr(),
        leading: BackImage(context),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              QrView(qrKey, qrState),
              const SizedBox(height: 20),
              QrMakerTextField(
                qrState.data,
                qrState.textEditingController,
                viewModel.updateData,
                viewModel.removeData,
              ),
              const SizedBox(height: 20),
              if (qrState.imagePath.isNotEmpty)
                ImageSizeSlider(
                  qrState.imageSize,
                  viewModel.updateImageSize,
                ),
              QrMakerButton(
                'qr_save',
                () async {
                  await viewModel.saveQrCode(qrKey, showSnackBar);
                },
              ),
              if (qrState.imagePath.isEmpty)
                QrMakerButton('qr_add_image', viewModel.getImage)
              else
                QrMakerButton(
                  'qr_remove_image',
                  viewModel.removeImagePath,
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

Widget QrMakerButton(String text, void Function() onPressed) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1.5),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 21),
        ).tr(),
      ),
    ),
  );
}

Widget QrView(GlobalKey qrKey, QrState qrState) {
  return RepaintBoundary(
    key: qrKey,
    child: QrImageView(
      backgroundColor: Colors.white,
      data: qrState.data,
      size: 200,
      embeddedImage: FileImage(File(qrState.imagePath)),
      embeddedImageStyle: QrEmbeddedImageStyle(
        size: Size(qrState.imageSize, qrState.imageSize),
      ),
      errorCorrectionLevel: QrErrorCorrectLevel.H,
    ),
  );
}

Widget QrMakerTextField(
  String data,
  TextEditingController textEditingController,
  void Function(String) updateData,
  void Function() removeData,
) {
  return TextField(
    controller: textEditingController
      ..selection =
          TextSelection.fromPosition(TextPosition(offset: data.length)),
    onChanged: updateData,
    style: const TextStyle(fontSize: 17),
    cursorColor: Colors.black26,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white70,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(10),
      ),
      suffixIcon: IconButton(
        onPressed: removeData,
        icon: const Icon(Icons.clear),
      ),
    ),
  );
}

Widget ImageSizeSlider(
  double imageSize,
  void Function(double) updateImageSize,
) {
  return Column(
    children: [
      Slider(
        value: imageSize,
        onChanged: updateImageSize,
        max: 60,
        min: 1,
        thumbColor: Colors.amberAccent,
        activeColor: Colors.amberAccent,
        inactiveColor: Colors.white70,
      ),
    ],
  );
}
