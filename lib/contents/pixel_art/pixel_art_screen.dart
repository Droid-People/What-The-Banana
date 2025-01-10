import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:what_the_banana/contents/pixel_art/pixel_art_state_provider.dart';
import 'package:what_the_banana/contents/pixel_art/pixel_painter.dart';
import 'package:what_the_banana/gen/fonts.gen.dart';

class PixelArtScreen extends ConsumerStatefulWidget {
  const PixelArtScreen({super.key});

  @override
  ConsumerState<PixelArtScreen> createState() => _PixelArtScreenState();
}

class _PixelArtScreenState extends ConsumerState<PixelArtScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final boardSize = width - 40.h;
    final state = ref.watch(pixelArtStateNotifierProvider);
    final viewModel = ref.read(pixelArtStateNotifierProvider.notifier);
    final pictureRecorder = PictureRecorder();
    final paletteWidth = (width * (3 / 4)) / 9;

    // bottom navigation bar padding
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                pictureRecorder: pictureRecorder,
                callback: viewModel.changePixelColor,
              ),
              12.verticalSpace,
              DeleteAndShareRow(viewModel, pictureRecorder, boardSize),
              12.verticalSpace,
              PixelSizeController(viewModel, state.pixelSize),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: bottomPadding + 8,
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
                              crossAxisCount: 9),
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
                )
              ],
            ),
          ),
        ],
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

  Text TitleText() {
    return Text(
      'Pixel',
      style: TextStyle(
        fontFamily: FontFamily.pixelFont,
        fontWeight: FontWeight.bold,
        fontSize: 70.sp,
        height: 1,
      ),
    );
  }

  Widget DeleteAndShareRow(
    PixelArtStateProvider viewModel,
    PictureRecorder pictureRecorder,
    double boardSize,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: viewModel.drawMapWhite,
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.delete),
          ),
        ),
        8.horizontalSpace,
        GestureDetector(
          onTap: () => viewModel.shareImage(
            pictureRecorder,
            boardSize.toInt(),
          ),
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.share),
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
