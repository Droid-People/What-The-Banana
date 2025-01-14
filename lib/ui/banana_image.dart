import 'package:flutter/material.dart';
import 'package:what_the_banana/gen/assets.gen.dart';

class BananaImage extends StatelessWidget {
  const BananaImage(this.level, {super.key});

  final int level;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (_) {
        switch (level) {
          case 1:
            return Assets.images.firstBanana.image(
              fit: BoxFit.contain,
              width: 300,
              height: 280,
              alignment: Alignment.bottomCenter,
            );
          case 2:
            return Assets.images.secondBanana.image(
              fit: BoxFit.contain,
              width: 300,
              height: 280,
              alignment: Alignment.bottomCenter,
            );
          case 3:
            return Assets.images.thirdBanana.image(
              fit: BoxFit.contain,
              width: 300,
              height: 280,
              alignment: Alignment.bottomCenter,
            );
          case 4:
            return Assets.images.forthBanana.image(
              fit: BoxFit.contain,
              width: 300,
              height: 280,
              alignment: Alignment.bottomCenter,
            );
          case 5:
            return Assets.images.finalBanana.image(
              fit: BoxFit.contain,
              width: 300,
              height: 280,
              alignment: Alignment.bottomCenter,
            );
          default:
            return Assets.images.firstBanana.image(
              fit: BoxFit.contain,
              width: 300,
              height: 280,
              alignment: Alignment.bottomCenter,
            );
        }
      },
    );
  }
}
