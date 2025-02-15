import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:what_the_banana/gen/assets.gen.dart';
import 'package:what_the_banana/gen/colors.gen.dart';
import 'package:what_the_banana/routes.dart';
import 'package:what_the_banana/ui/back_button.dart';

class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackImage(context),
        title:
            Text('introduction', style: Theme.of(context).textTheme.bodyLarge)
                .tr(),
        backgroundColor: ColorName.homeMainBackground,
      ),
      backgroundColor: ColorName.homeMainBackground,
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            40.verticalSpace,
            Assets.images.smellyBanana.image(),
            25.verticalSpace,
            Padding(
              padding: const EdgeInsets.all(16),
              child: const Text(
                'appDescription',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ).tr(),
            ),
            20.verticalSpace,
            GestureDetector(
              onTap: () {
                // TODO : Add the link to the privacy policy
              },
              child: EtcButton('Privacy Policy'),
            ),
            10.verticalSpace,
            GestureDetector(
              onTap: () {
                context.go(Routes.introduction + Routes.ossLicenses);
              },
              child: EtcButton('Open Source Licenses'),
            ),
          ],
        ),
      ),
    );
  }

  Container EtcButton(String text) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          text,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
