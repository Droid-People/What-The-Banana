import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
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
  // TODO(boring-km): 홈화면에 배너 광고 넣기 - String adUnitId = AdmobIds.getHomeBannerAdId();
  final scrollController = ScrollController();

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
                child: SizedBox(
                  height: 213,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 213,
                        color: ColorName.homeTopBackground,
                      ),
                      Center(child: Assets.images.homeTopBanana.image()),
                      LanguageButton(),
                    ],
                  ),
                ),
              ),
            ),
            Stack(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: MarqueeWidget(),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 74, left: 29),
                  child: IntroductionButton(),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: PixelArtButton(),
                ),
              ],
            ),
            Stack(
              children: [
                // Align(
                //   alignment: Alignment.topRight,
                //   child: DonationButton(),
                // ),
                Align(
                  alignment: Alignment.topCenter,
                  child: FirstText(),
                ),
              ],
            ),
            15.verticalSpace,
            // RouletteButton(),
            8.verticalSpace,
            Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: CreatorsButton(),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: SecondText(),
                ),
              ],
            ),
            CounterButton(),
            // GestureDetector(
            //   onTap: () {
            //     context.go(Routes.qrMaker);
            //   },
            //   child: Assets.images.qrMaker.image(),
            // ),
            18.verticalSpace,
            Stack(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 18,
                    ),
                    child: SmallText('DOWN, DOWN'),
                  ),
                ),
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
              ],
            ),
            7.verticalSpace,
            // GestureDetector(
            //   onTap: () {
            //     context.go(Routes.paceCounter);
            //   },
            //   child: Assets.images.paceCounters.image(),
            // ),
            18.verticalSpace,
            Stack(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12),
                    child: SmallText(
                      "DON'T STOP\nCHEER UP",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {
                      context.go(Routes.updates);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 31),
                      child: Assets.images.update.image(),
                    ),
                  ),
                ),
              ],
            ),
            // GestureDetector(
            //   onTap: () {
            //     context.go(Routes.ghostLeg);
            //   },
            //   child: Assets.images.ghostLeg.image(),
            // ),
            38.verticalSpace,
            SmallText('HAVE A NICE DAY.'),
            38.verticalSpace,
            SmallText('GOOD LUCK'),
            38.verticalSpace,
            AdsButton(),
            66.verticalSpace,
            SmallText('GOOD BANANA'),
            45.verticalSpace,
            ScrollToTopButton(),
            87.verticalSpace,
          ],
        ),
      ),
    );
  }

  GestureDetector ScrollToTopButton() {
    return GestureDetector(
      onTap: () {
        scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      },
      child: Assets.images.bananaOnPlate.image(),
    );
  }

  Text SmallText(String text, {TextAlign textAlign = TextAlign.start}) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelSmall,
    );
  }

  Container SecondText() {
    return Container(
      margin: const EdgeInsets.only(top: 17),
      child: Text(
        'Click on\nthe function you want',
        style: Theme.of(context).textTheme.labelSmall,
        textAlign: TextAlign.center,
      ),
    );
  }

  GestureDetector RouletteButton() {
    return GestureDetector(
      onTap: () {
        context.go(Routes.roulette);
      },
      child: Assets.images.roulette.image(),
    );
  }

  Widget IntroductionButton() {
    return GestureDetector(
      onTap: () {
        context.go(Routes.introduction);
      },
      child: SvgPicture.asset(Assets.images.introduction),
    );
  }

  Container FirstText() {
    return Container(
      margin: const EdgeInsets.only(top: 15, left: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SmallText('HELLO'),
          12.horizontalSpace,
          Container(
            width: 1,
            height: 44,
            color: Colors.black.withAlpha(50),
          ),
          12.horizontalSpace,
          SmallText('WELCOME TO\nWTB'),
        ],
      ),
    );
  }

  Widget DonationButton() {
    return GestureDetector(
      onTap: () {
        // context.go(Routes.donation);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 24),
        child: SvgPicture.asset(Assets.images.donation),
      ),
    );
  }

  Widget PixelArtButton() {
    return GestureDetector(
      onTap: () {
        context.go(Routes.pixelArt);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 109),
        child: Assets.images.pixelArt.image(),
      ),
    );
  }

  GestureDetector CreatorsButton() {
    return GestureDetector(
      onTap: () {
        context.go(Routes.creators);
      },
      child: Container(
        margin: const EdgeInsets.only(left: 28),
        child: Assets.images.creators.image(),
      ),
    );
  }

  GestureDetector AdsButton() {
    return GestureDetector(
      onTap: () {
        if(defaultTargetPlatform == TargetPlatform.iOS) {
          Permission.appTrackingTransparency.request();
        }
        context.go(Routes.ads);
      },
      child: Assets.images.adButton.image(),
    );
  }

  Widget CounterButton() {
    return GestureDetector(
      onTap: () {
        context.go(Routes.counter);
      },
      onLongPress: () {
        context.go(Routes.counter, extra: true);
      },
      child: Assets.images.dualCounter.image(),
    );
  }

  Widget LanguageButton() {
    return GestureDetector(
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
    );
  }
}
