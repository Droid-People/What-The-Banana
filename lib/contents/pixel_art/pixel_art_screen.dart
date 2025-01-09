import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:what_the_banana/contents/pixel_art/pixel_art_state_provider.dart';
import 'package:what_the_banana/contents/pixel_art/pixel_painter.dart';
import 'package:what_the_banana/gen/colors.gen.dart';
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
      body: Center(
        child: Column(
          children: [
            Text(
              'Pixel',
              style: TextStyle(
                fontFamily: FontFamily.pixelFont,
                fontWeight: FontWeight.bold,
                fontSize: 70.sp,
                height: 1,
              ),
            ),
            Text(
              'by boring-km',
              style: TextStyle(
                fontFamily: FontFamily.pixelFont,
                fontWeight: FontWeight.w900,
                fontSize: 14.sp,
                height: 1,
              ),
            ),
            SizedBox(
              height: boardSize + 100.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: boardSize,
                    height: boardSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: ColorName.lightGrey),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: PixelCanvas(
                        boardSize: boardSize,
                        pixelSize: state.pixelSize,
                        gridMap: state.gridMap,
                        pictureRecorder: state.pictureRecorder,
                        callback: viewModel.changePixelColor,
                      ),
                    ),
                  ),
                  12.verticalSpace,
                  Row(
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
                        onTap: () => viewModel.shareImage(boardSize.toInt()),
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.share),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
