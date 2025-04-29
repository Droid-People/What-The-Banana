import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:what_the_banana/consts.dart';
import 'package:what_the_banana/gen/assets.gen.dart';
import 'package:what_the_banana/gen/colors.gen.dart';
import 'package:what_the_banana/gen/fonts.gen.dart';
import 'package:what_the_banana/routes.dart';
import 'package:what_the_banana/ui/back_button.dart';

class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: BackImage(context),
        title: const Text('introduction').tr(),
        backgroundColor: ColorName.homeMainBackground,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: ColorName.homeMainBackground,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
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
                const Text(
                  'Used Fonts\nInter, Unkempt, 둥근모꼴+Fixed,\n스스로넷 Font\nCustom Font by @hhhannahhh',
                  style: TextStyle(
                    fontSize: 20,
                    height: 1.2,
                    fontFamilyFallback: [
                      FontFamily.unkemptBold,
                      FontFamily.ssronet,
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                30.verticalSpace,
                GestureDetector(
                  onTap: () {
                    launchUrl(Uri.parse(Consts.privacyPolicyUrl),
                        mode: LaunchMode.externalApplication);
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
