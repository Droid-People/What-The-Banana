import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:what_the_banana/contents/pixel_art/pixel_art_state_provider.dart';
import 'package:what_the_banana/contents/pixel_art/pixel_canvas.dart';
import 'package:what_the_banana/gen/fonts.gen.dart';
import 'package:what_the_banana/routes.dart';

class PixelArtScreen extends ConsumerStatefulWidget {
  const PixelArtScreen({super.key});

  @override
  ConsumerState<PixelArtScreen> createState() => _PixelArtScreenState();
}

class _PixelArtScreenState extends ConsumerState<PixelArtScreen> {

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final boardSize = width - 10.h;
    final state = ref.watch(pixelArtStateNotifierProvider);
    final viewModel = ref.read(pixelArtStateNotifierProvider.notifier);
    final paletteWidth = (width * (3 / 4)) / 9;

    // bottom navigation bar padding
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Column(
              children: [
                TitleText(),
                DeveloperText(),
                20.verticalSpace,
                PixelCanvas(
                  boardSize: boardSize,
                  pixelSize: state.pixelSize,
                  gridMap: state.gridMap,
                  callback: viewModel.changePixelColor,
                ),
                12.verticalSpace,
                MiddleButtons(
                  onDrawMapWhite: viewModel.drawMapWhite,
                  onShareImage: () =>
                      viewModel.shareImage(boardSize.toInt()),
                  onPickImageFromCamera: () {
                    viewModel.pickImageFromCamera(
                      callbackImage: (path) async {
                        context.go(Routes.pixelArt + Routes.crop, extra: path);
                      },
                    );
                  },
                  onPickImageFromGallery: () {
                    viewModel.pickImageFromGallery(
                      callbackImage: (path) async {
                        context.go(Routes.pixelArt + Routes.crop, extra: path);
                      },
                    );
                  },
                ),
                12.verticalSpace,
                PixelSizeController(viewModel, state.pixelSize),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 8, right: 8,
                top: 32,
                bottom: bottomPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.black,
                    padding: const EdgeInsets.all(2),
                    child: SizedBox(
                      width: paletteWidth * 9,
                      height: paletteWidth * 2,
                      child: GridView.builder(
                        padding: EdgeInsets.zero,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 9,
                        ),
                        itemCount: state.arrayDeque.length,
                        itemBuilder: (ctx, index) {
                          final color = state.arrayDeque[index];
                          return GestureDetector(
                            onTap: () => viewModel.setSelectedColor(color),
                            child: Container(
                              decoration: BoxDecoration(
                                color: color,
                                border: Border.all(),
                              ),
                              height: paletteWidth,
                              width: paletteWidth,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  12.horizontalSpace,
                  GestureDetector(
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        builder: (ctx) {
                          return Dialog(
                            backgroundColor: Colors.white,
                            insetPadding: const EdgeInsets.all(16),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Theme(
                                data: ThemeData(
                                  fontFamily: FontFamily.pixelFont,
                                  colorScheme: const ColorScheme.light(),
                                ),
                                child: Wrap(
                                  children: [
                                    Column(
                                      children: [
                                        ColorPicker(
                                          pickerColor: state.selectedColor,
                                          onColorChanged:
                                              viewModel.setSelectedColor,
                                          pickerAreaBorderRadius:
                                              const BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                        8.verticalSpace,
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black,
                                            iconColor: Colors.white,
                                          ),
                                          onPressed: () {
                                            viewModel.addFirstColor();
                                            Navigator.of(ctx).pop();
                                          },
                                          child: const Icon(
                                            Icons.check_rounded,
                                            size: 28,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: state.selectedColor,
                      ),
                      width: paletteWidth * 2,
                      height: paletteWidth * 2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text DeveloperText() {
    return Text(
      'by boring-km',
      style: TextStyle(
        fontFamily: FontFamily.pixelFont,
        fontWeight: FontWeight.w900,
        fontSize: 14.sp,
        height: 1,
      ),
    );
  }

  Widget TitleText() {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            context.go(Routes.home);
          },
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Icon(Icons.arrow_back),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Pixel',
              style: TextStyle(
                fontFamily: FontFamily.pixelFont,
                fontWeight: FontWeight.bold,
                fontSize: 70.sp,
                height: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget MiddleButtons({
    required void Function() onDrawMapWhite,
    required void Function() onShareImage,
    required void Function() onPickImageFromGallery,
    required void Function() onPickImageFromCamera,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8.h,
      children: [
        GestureDetector(
          onTap: onDrawMapWhite,
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.delete),
          ),
        ),
        GestureDetector(
          onTap: onShareImage,
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.share),
          ),
        ),
        GestureDetector(
          onTap: onPickImageFromGallery,
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.photo_library_rounded),
          ),
        ),
        GestureDetector(
          onTap: onPickImageFromCamera,
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.photo_camera_rounded),
          ),
        ),
      ],
    );
  }

  Widget PixelSizeController(PixelArtStateProvider viewModel, int pixelSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: viewModel.decreasePixelSize,
          child: const Icon(
            Icons.keyboard_arrow_left_rounded,
            size: 40,
          ),
        ),
        8.horizontalSpace,
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(width: 2),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            '$pixelSize',
            style: TextStyle(
              fontSize: 24.sp,
              fontFamily: FontFamily.pixelFont,
              height: 1,
            ),
          ),
        ),
        8.horizontalSpace,
        GestureDetector(
          onTap: viewModel.increasePixelSize,
          child: const Icon(
            Icons.keyboard_arrow_right_rounded,
            size: 40,
          ),
        ),
      ],
    );
  }
}
