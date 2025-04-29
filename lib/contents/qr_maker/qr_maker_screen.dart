import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:what_the_banana/contents/qr_maker/qr_state.dart';
import 'package:what_the_banana/contents/qr_maker/qr_state_provider.dart';
import 'package:what_the_banana/ui/back_button.dart';

final qrKeyProvider = Provider<GlobalKey>((ref) => GlobalKey());

const double qrCodeSize = 250;
const double iconSize = 35;
const double maxImageSize = 60;

// TODO(yewon-yw): 광고 배너, 슬라이더
class QrMakerScreen extends ConsumerWidget {
  const QrMakerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qrKey = ref.watch(qrKeyProvider);
    final qrState = ref.watch(QrStateNotifierProvider);
    final viewModel = ref.read(QrStateNotifierProvider.notifier);

    void showSnackBar(String text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(text).tr()));
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('qr_maker_title').tr(),
        leading: BackImage(context),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  QrView(qrKey, qrState),
                  QrIconButtons(
                    () async {
                      await viewModel.saveQrCode(qrKey, showSnackBar);
                    },
                    viewModel.getImage,
                    viewModel.removeImagePath,
                  ),
                ],
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}

Widget QrView(GlobalKey qrKey, QrState qrState) {
  return RepaintBoundary(
    key: qrKey,
    child: QrImageView(
      backgroundColor: Colors.white,
      data: qrState.data,
      size: qrCodeSize,
      embeddedImage: FileImage(File(qrState.imagePath)),
      embeddedImageStyle: QrEmbeddedImageStyle(
        size: Size(qrState.imageSize, qrState.imageSize),
      ),
      errorCorrectionLevel: QrErrorCorrectLevel.H,
    ),
  );
}

Widget QrIconButtons(
  Future<void> Function() saveQrCode,
  void Function() getImage,
  void Function() removeImage,
) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      IconButton(
        icon: const Icon(Icons.download, size: iconSize),
        onPressed: saveQrCode,
      ),
      IconButton(
        icon: const Icon(
          Icons.image_search,
          size: iconSize,
        ),
        onPressed: getImage,
      ),
      IconButton(
        icon: const Icon(
          Icons.delete,
          size: iconSize,
        ),
        onPressed: removeImage,
      ),
    ],
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
  return Slider(
    value: imageSize,
    onChanged: updateImageSize,
    max: maxImageSize,
    min: 1,
    thumbColor: Colors.amberAccent,
    activeColor: Colors.amberAccent,
    inactiveColor: Colors.white70,
  );
}
