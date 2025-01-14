import 'dart:io';
import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image/image.dart' as lib;
import 'package:what_the_banana/common/logger.dart';
import 'package:what_the_banana/contents/pixel_art/pixel_art_state_provider.dart';
import 'package:what_the_banana/contents/pixel_art/pixel_canvas.dart';

class CropScreen extends ConsumerStatefulWidget {
  const CropScreen({super.key});

  @override
  ConsumerState<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends ConsumerState<CropScreen> {
  final controller = CropController();
  final isLoading = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final imagePath = GoRouterState.of(context).extra! as String;
    final image = File(imagePath);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: context.pop,
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 16,
              children: [
                SizedBox(
                  width: screenWidth,
                  height: screenWidth,
                  child: Crop(
                    controller: controller,
                    image: image.readAsBytesSync(),
                    onCropped: (result) {
                      switch (result) {
                        case CropSuccess(:final croppedImage):
                          ref
                              .read(pixelArtStateNotifierProvider.notifier)
                              .setGridMap(
                                getPixelsFromCroppedImage(
                                  context,
                                  croppedImage,
                                ),
                              );
                        case CropFailure(:final cause):
                          Log.e(cause);
                      }
                      context.pop();
                    },
                    cornerDotBuilder: (size, edgeAlignment) =>
                        const SizedBox.shrink(),
                    interactive: true,
                    fixCropRect: true,
                    radius: 20,
                    initialRectBuilder: InitialRectBuilder.withBuilder(
                      (viewportRect, imageRect) {
                        return Rect.fromLTRB(
                          viewportRect.left + 20,
                          viewportRect.top + 20,
                          viewportRect.right - 20,
                          viewportRect.bottom - 20,
                        );
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    iconColor: Colors.black,
                  ),
                  onPressed: () {
                    isLoading.value = true;
                    controller.crop();
                  },
                  child: const Icon(Icons.check_rounded, size: 32),
                ),
              ],
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: isLoading,
            builder: (context, value, child) {
              return value
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    )
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  List<Color> getPixelsFromCroppedImage(
    BuildContext context,
    Uint8List croppedImage,
  ) {
    final decodeImage = lib.decodeImage(croppedImage);
    if (decodeImage == null) return [];
    return ref
        .read(pixelArtStateNotifierProvider.notifier)
        .getPixelImage(decodeImage, maxPixelCount);
  }
}
