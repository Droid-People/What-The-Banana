import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:what_the_banana/gen/assets.gen.dart';
import 'package:what_the_banana/gen/colors.gen.dart';
import 'package:what_the_banana/routes.dart';

class AdsScreen extends ConsumerWidget {
  const AdsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Many Ads',
          style: TextStyle(fontSize: 36),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
        backgroundColor: ColorName.yellowBackground,
      ),
      backgroundColor: ColorName.yellowBackground,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              context.go(Routes.ads + Routes.openAppAd);
            },
            child: Assets.images.bigBanana.image(width: 80, height: 80),
          ),
          GestureDetector(
            onTap: () {
              context.go(Routes.ads + Routes.interstitialAd);
            },
            child: Assets.images.bigBanana.image(width: 140, height: 140),
          ),
          GestureDetector(
            onTap: () {
              context.go(Routes.ads + Routes.nativeAd);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                Assets.images.bigBanana.image(width: 80, height: 80),
                Assets.images.bigBanana.image(width: 80, height: 80),
                Assets.images.bigBanana.image(width: 80, height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
