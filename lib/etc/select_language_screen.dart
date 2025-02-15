import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:what_the_banana/common/logger.dart';
import 'package:what_the_banana/gen/assets.gen.dart';
import 'package:what_the_banana/gen/colors.gen.dart';
import 'package:what_the_banana/ui/photo_hero.dart';

class SelectLanguageScreen extends StatelessWidget {
  const SelectLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // get Locale
    final locale = context.locale;
    Log.i('locale: $locale');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'select_languages',
          style: Theme.of(context).textTheme.bodyLarge,
        ).tr(),
        backgroundColor: ColorName.yellowBackground,
      ),
      backgroundColor: ColorName.yellowBackground,
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              PhotoHero(
                photo: Assets.images.bigEarth.path,
                width: 170,
              ),
              63.verticalSpace,
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 14,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.setLocale(const Locale('en'));
                    },
                    child: Assets.images.english.image(),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.setLocale(const Locale('ko'));
                    },
                    child: Assets.images.korean.image(),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.setLocale(const Locale('ja'));
                    },
                    child: Assets.images.japanese.image(),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.setLocale(const Locale('zh'));
                    },
                    child: Assets.images.chinese.image(),
                  ),
                ],
              ),
              55.verticalSpace,
              Assets.images.smallBananaOnPlate.image(),
            ],
          ),
        ),
      ),
    );
  }

  TextDecoration getDecorationBy(Locale locale, String language) {
    return locale.toString() == language
        ? TextDecoration.underline
        : TextDecoration.none;
  }
}
