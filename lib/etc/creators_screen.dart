import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:what_the_banana/gen/assets.gen.dart';
import 'package:what_the_banana/gen/colors.gen.dart';
import 'package:what_the_banana/gen/fonts.gen.dart';
import 'package:what_the_banana/ui/back_button.dart';
import 'package:what_the_banana/ui/banana_background.dart';

class CreatorsScreen extends ConsumerWidget {
  const CreatorsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nicknameTextStyle = TextStyle(fontFamily: FontFamily.hannah, fontSize: 60.sp, fontWeight: FontWeight.w900, height: 1);
    const positionTextStyle = TextStyle(fontFamily: FontFamily.inter, height: 1);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('creators').tr(),
        backgroundColor: ColorName.yellowBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: BackImage(context),
      ),
      backgroundColor: ColorName.yellowBackground,
      body: Stack(
        children: [
          const BananaBackground(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.images.boringKm.image(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('boring', style: nicknameTextStyle),
                  Container(
                    width: 10,
                    height: 3,
                    color: Colors.black,
                    margin: const EdgeInsets.only(top: 10, left: 4, right: 6),
                  ),
                  Text('km', style: nicknameTextStyle),
                ],
              ),
              const Text('Developer', style: positionTextStyle),
              30.verticalSpace,
              Assets.images.hannaProfile.image(),
              Text('hhhannahhh', style: nicknameTextStyle),
              const Text('Designer', style: positionTextStyle),
            ],
          ),
        ],
      ),
    );
  }
}
