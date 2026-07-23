import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:what_the_banana/etc/ads/admob_ids.dart';
import 'package:what_the_banana/gen/assets.gen.dart';
import 'package:what_the_banana/gen/colors.gen.dart';
import 'package:what_the_banana/routes.dart';
import 'package:what_the_banana/ui/marquee.dart';
import 'package:what_the_banana/ui/photo_hero.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // TODO(boring-km): 홈화면에 배너 광고 넣기 -
  String adUnitId = AdmobIds.getHomeBannerAdId();
  BannerAd? bannerAd;
  bool _isLoaded = false;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadAd();
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      unawaited(Permission.appTrackingTransparency.request());
    }
  }

  @override
  void dispose() {
    bannerAd?.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _loadAd() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.sizeOf(context).width.truncate() - 32,
      );
      if (size == null) return;

      bannerAd = BannerAd(
        adUnitId: adUnitId,
        request: const AdRequest(),
        size: size,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              _isLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            unawaited(ad.dispose());
          },
        ),
      );
      unawaited(bannerAd!.load());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorName.homeMainBackground,
        body: SingleChildScrollView(
          controller: scrollController,
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              ColoredBox(
                color: ColorName.homeTopBackground,
                child: SafeArea(
                  left: false,
                  right: false,
                  bottom: false,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Assets.images.homeTopBanana.image(),
                      ),
                      const _LanguageButton(),
                    ],
                  ),
                ),
              ),
              Stack(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: CustomMarquee(),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 74, left: 29),
                    child: const _IntroductionButton(),
                  ),
                  const Align(
                    alignment: Alignment.topCenter,
                    child: _PixelArtButton(),
                  ),
                ],
              ),
              17.verticalSpace,
              Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        context.go(Routes.feedback);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 28),
                        child: Assets.images.feedback.image(),
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.topCenter,
                    child: _FirstText(),
                  ),
                ],
              ),
              37.verticalSpace,
              const _RouletteButton(),
              8.verticalSpace,
              Stack(
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: _CreatorsButton(),
                  ),
                  const Align(
                    alignment: Alignment.topCenter,
                    child: _SecondText(),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3, right: 31),
                      child: Assets.images.bananaForth.image(),
                    ),
                  ),
                ],
              ),
              13.verticalSpace,
              Semantics(
                label: 'home_ghost_leg'.tr(),
                button: true,
                child: GestureDetector(
                  onTap: () {
                    context.go(Routes.ghostLeg);
                  },
                  child: Assets.images.ghostLeg.image(),
                ),
              ),
              18.verticalSpace,
              Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 22, left: 41),
                      child: Assets.images.bananaFirst.image(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: const EdgeInsets.only(top: 34),
                      child: Column(
                        children: [
                          _SmallText('home_down_down'.tr()),
                          15.verticalSpace,
                          _SmallText('home_cheer_up'.tr(), textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        context.go(Routes.updates);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 24, top: 12),
                        child: Assets.images.update.image(),
                      ),
                    ),
                  ),
                ],
              ),
              19.verticalSpace,
              const _CounterButton(),
              Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 38),
                      child: _SmallText('home_nice_day'.tr()),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, right: 42),
                      child: Assets.images.bananaSecond.image(),
                    ),
                  ),
                ],
              ),
              25.verticalSpace,
              const _AdsButton(),
              23.verticalSpace,
              Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Column(
                        children: [
                          _SmallText('home_good_luck'.tr()),
                          18.verticalSpace,
                          _SmallText('home_good_banana'.tr(), fontWeight: FontWeight.w700),
                          18.verticalSpace,
                          _SmallText('home_coming_soon'.tr()),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 23, left: 42),
                      child: Assets.images.bananaThird.image(),
                    ),
                  ),
                ],
              ),
              29.verticalSpace,
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    width: 1,
                    height: 46,
                    color: Colors.black,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 39),
                    child: ScrollToTopButton(),
                  ),
                ],
              ),
              41.verticalSpace,
              BottomAdView(),
              24.verticalSpace,
            ],
          ),
        ),
    );
  }

  Widget BottomAdView() {
    if (!_isLoaded) {
      return NotLoadedBottomAdView();
    }
    return LoadedBottomAdView();
  }

  Widget LoadedBottomAdView() {
    return Stack(
      children: [
        NotLoadedBottomAdView(),
        SafeArea(
          top: false,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: bannerAd!.size.width.toDouble(),
              height: bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: bannerAd!),
            ),
          ),
        ),
      ],
    );
  }

  SafeArea NotLoadedBottomAdView() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                'home_ad_loading'.tr(),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector ScrollToTopButton() {
    return GestureDetector(
      onTap: () {
        unawaited(scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        ));
      },
      child: Column(
        children: [
          Assets.images.bananaOnPlate.image(),
          8.verticalSpace,
          Assets.images.wtbRoundText.image(),
        ],
      ),
    );
  }

}

class _SmallText extends StatelessWidget {
  const _SmallText(
    this.text, {
    this.textAlign = TextAlign.start,
    this.fontWeight = FontWeight.normal,
  });

  final String text;
  final TextAlign textAlign;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: fontWeight,
          ),
      textAlign: textAlign,
    );
  }
}

class _SecondText extends StatelessWidget {
  const _SecondText();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 38),
      child: Text(
        'home_select_function'.tr(),
        style: Theme.of(context).textTheme.labelSmall,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _FirstText extends StatelessWidget {
  const _FirstText();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        19.verticalSpace,
        _SmallText('home_hello'.tr()),
        13.verticalSpace,
        _SmallText('home_welcome'.tr(), textAlign: TextAlign.center),
      ],
    );
  }
}

class _RouletteButton extends StatelessWidget {
  const _RouletteButton();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'home_roulette'.tr(),
      button: true,
      child: GestureDetector(
        onTap: () {
          context.go(Routes.roulette);
        },
        child: Assets.images.roulette.image(),
      ),
    );
  }
}

class _IntroductionButton extends StatelessWidget {
  const _IntroductionButton();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'home_introduction'.tr(),
      button: true,
      child: GestureDetector(
        onTap: () {
          context.go(Routes.introduction);
        },
        child: Assets.images.introduction.image(),
      ),
    );
  }
}

class _PixelArtButton extends StatelessWidget {
  const _PixelArtButton();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'home_pixel_art'.tr(),
      button: true,
      child: GestureDetector(
        onTap: () {
          context.go(Routes.pixelArt);
        },
        child: Container(
          margin: const EdgeInsets.only(top: 109),
          child: Assets.images.pixelArt.image(),
        ),
      ),
    );
  }
}

class _CreatorsButton extends StatelessWidget {
  const _CreatorsButton();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'home_creators'.tr(),
      button: true,
      child: GestureDetector(
        onTap: () {
          context.go(Routes.creators);
        },
        child: Container(
          margin: const EdgeInsets.only(left: 35, top: 16),
          child: Assets.images.creators.image(),
        ),
      ),
    );
  }
}

class _AdsButton extends StatelessWidget {
  const _AdsButton();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'home_ads'.tr(),
      button: true,
      child: GestureDetector(
        onTap: () {
          context.go(Routes.ads);
        },
        child: Assets.images.adButton.image(),
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  const _CounterButton();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'home_counter'.tr(),
      button: true,
      child: GestureDetector(
        onTap: () {
          context.go(Routes.counter);
        },
        onLongPress: () {
          context.go(Routes.counter, extra: true);
        },
        child: Assets.images.dualCounter.image(),
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'home_language'.tr(),
      button: true,
      child: GestureDetector(
        onTap: () {
          context.go(Routes.selectLanguage);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 4,
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: PhotoHero(
              photo: Assets.images.bigEarth.path,
              width: 32,
            ),
          ),
        ),
      ),
    );
  }
}
