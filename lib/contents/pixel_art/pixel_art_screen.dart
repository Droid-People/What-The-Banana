import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:what_the_banana/contents/pixel_art/pixel_art_state.dart';
import 'package:what_the_banana/contents/pixel_art/pixel_art_state_provider.dart';
import 'package:what_the_banana/contents/pixel_art/pixel_canvas.dart';
import 'package:what_the_banana/gen/assets.gen.dart';
import 'package:what_the_banana/gen/colors.gen.dart';
import 'package:what_the_banana/gen/fonts.gen.dart';
import 'package:what_the_banana/routes.dart';
import 'package:what_the_banana/ui/back_button.dart';

class PixelArtScreen extends ConsumerWidget {
  const PixelArtScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;

    final boardSize = width - 8.h;
    final state = ref.watch(pixelArtStateNotifierProvider);
    final viewModel = ref.read(pixelArtStateNotifierProvider.notifier);
    final paletteWidth = (width * (0.7)) / 9;

    return Scaffold(
      backgroundColor: ColorName.homeMainBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  TitleText(context),
                  DeveloperText(),
                  20.verticalSpace,
                  PixelCanvas(
                    boardSize: boardSize,
                    pixelSize: state.pixelSize,
                    gridMap: state.gridMap,
                    gridState: state.showGrid,
                    onStartRecord: viewModel.startRecord,
                    callback: viewModel.changePixelColor,
                  ),
                  12.verticalSpace,
                  MiddleButtons(
                    pickColorState: state.pickColorState,
                    showGrid: state.showGrid,
                    onSelectBanana: viewModel.selectBanana,
                    onDrawMapWhite: viewModel.drawMapWhite,
                    onShareImage: () => viewModel.shareImage(boardSize.toInt()),
                    onPickImageFromGallery: () {
                      viewModel.pickImageFromGallery(
                        callbackImage: (path) async {
                          context.go(Routes.pixelArt + Routes.crop, extra: path);
                        },
                      );
                    },
                    onPickColor: viewModel.togglePickColor,
                    onLoadPrevious: viewModel.loadPrevious,
                    onToggleGrid: viewModel.toggleGrid,
                  ),
                  12.verticalSpace,
                  PixelSizeController(viewModel, state.pixelSize),
                ],
              ),
              ColorPalette(paletteWidth, state, viewModel, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget ColorPalette(
    double paletteWidth,
    PixelArtState state,
    PixelArtStateProvider viewModel,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
                border: Border.all(width: 2),
              ),
              width: paletteWidth * 2,
              height: paletteWidth * 2,
              child: const Icon(
                Icons.edit,
                color: Colors.black,
              ),
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
        fontSize: 16.sp,
        height: 1,
      ),
    );
  }

  Widget TitleText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            context.go(Routes.home);
          },
          child: BackImage(context),
        ),
        Text(
          'pixel',
          style: TextStyle(
            fontFamily: FontFamily.pixelFont,
            fontWeight: FontWeight.bold,
            fontSize: 70.sp,
            height: 1,
          ),
        ).tr(),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.transparent,
          ),
        ),
      ],
    );
  }

  Widget MiddleButtons({
    required bool pickColorState,
    required bool showGrid,
    required void Function() onShareImage,
    required void Function() onPickImageFromGallery,
    required void Function() onSelectBanana,
    required void Function() onToggleGrid,
    required void Function() onPickColor,
    required void Function() onLoadPrevious,
    required void Function() onDrawMapWhite,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8.h,
      children: [
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
          onTap: onSelectBanana,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Assets.images.smallBanana.image(
              width: 32,
              fit: BoxFit.cover,
            ),
          ),
        ),
        GestureDetector(
          onTap: onToggleGrid,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Builder(
              builder: (c) {
                if (showGrid) {
                  return const Icon(Icons.grid_off_rounded);
                } else {
                  return const Icon(Icons.grid_on_rounded);
                }
              },
            ),
          ),
        ),
        GestureDetector(
          onTap: onPickColor,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Builder(
              builder: (c) {
                if (pickColorState) {
                  return const Icon(Icons.color_lens);
                } else {
                  return const Icon(Icons.colorize_rounded);
                }
              },
            ),
          ),
        ),
        GestureDetector(
          onTap: onLoadPrevious,
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.undo_rounded),
          ),
        ),
        GestureDetector(
          onTap: onDrawMapWhite,
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.delete),
          ),
        ),
      ],
    );
  }

  Widget PixelSizeController(PixelArtStateProvider viewModel, int pixelSize) {
    return GestureDetector(
      onTap: viewModel.increasePixelSize,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // measure Size Icon
            const Icon(
              Icons.square_foot_rounded,
              size: 28,
            ),
            Text(
              '$pixelSize',
              style: TextStyle(
                fontSize: 28.sp,
                fontFamily: FontFamily.pixelFont,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
