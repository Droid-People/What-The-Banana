import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:what_the_banana/common/logger.dart';
import 'package:what_the_banana/gen/colors.gen.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(200),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'English',
                  style: TextStyle(
                    decoration: getDecorationBy(locale, 'en'),
                  ),
                ),
                onTap: () {
                  context.setLocale(const Locale('en'));
                },
              ),
              ListTile(
                title: Text(
                  '한국어',
                  style: TextStyle(
                    decoration: getDecorationBy(locale, 'ko'),
                  ),
                ),
                onTap: () {
                  context.setLocale(const Locale('ko'));
                },
              ),
              ListTile(
                title: Text(
                  '日本語',
                  style: TextStyle(
                    decoration: getDecorationBy(locale, 'ja'),
                  ),
                ),
                onTap: () {
                  context.setLocale(const Locale('ja'));
                },
              ),
              ListTile(
                title: Text(
                  '中文',
                  style: TextStyle(
                    decoration: getDecorationBy(locale, 'zh'),
                  ),
                ),
                onTap: () {
                  context.setLocale(const Locale('zh'));
                },
              ),
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
