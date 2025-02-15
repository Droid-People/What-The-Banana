import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:what_the_banana/gen/assets.gen.dart';
import 'package:what_the_banana/gen/colors.gen.dart';
import 'package:what_the_banana/ui/back_button.dart';
import 'package:what_the_banana/ui/banana_background.dart';

class CreatorsScreen extends ConsumerWidget {
  const CreatorsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Creators',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        backgroundColor: ColorName.yellowBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: BackImage(context),
      ),
      backgroundColor: ColorName.yellowBackground,
      body: Stack(
        children: [
          const BananaBackground(),
          Align(
            alignment: Alignment.topCenter,
            child: Assets.images.creatorsImage.image(),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Assets.images.smallBananaOnPlate.image(),
            ),
          ),
        ],
      ),
    );
  }
}
