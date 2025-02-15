import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
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
  String adUnitId = AdmobIds.getHomeBannerAdId();
  int tappedBananaLevel = 0;
  GlobalKey key = GlobalKey();
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
                Align(
                  alignment: Alignment.topRight,
                  child: DonationButton(),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: FirstText(),
                ),
              ],
            ),
            15.verticalSpace,
            RouletteButton(),
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
            Assets.images.qrMaker.image(),
            36.verticalSpace,
            SmallText('DOWN, DOWN'),
            36.verticalSpace,
            Assets.images.paceCounters.image(),
            30.verticalSpace,
            SmallText("DON'T STOP\nCHEER UP", textAlign: TextAlign.center),
            27.verticalSpace,
            Assets.images.ghostLeg.image(),
            38.verticalSpace,
            SmallText('HAVE A NICE DAY.'),
            38.verticalSpace,
            CounterButton(),
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

  Container DonationButton() {
    return Container(
      margin: const EdgeInsets.only(right: 24),
      child: SvgPicture.asset(Assets.images.donation),
    );
  }

  void tapBanana() {
    setState(() {
      if (tappedBananaLevel == 5) {
        tappedBananaLevel = 0;
        // TODO 소개 페이지로 이동
      } else {
        tappedBananaLevel++;
      }
    });
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

  GestureDetector FeedbackButton() {
    return GestureDetector(
      onTap: () {
        context.go(Routes.feedback);
      },
      child: Container(
        color: Colors.blue,
        padding: const EdgeInsets.all(8),
        child: const Center(
          child: Text(
            'Feedback',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector AdsButton() {
    return GestureDetector(
      onTap: () {
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

  Widget UpdatesButton() {
    return GestureDetector(
      onTap: () {
        context.go(Routes.updates);
      },
      child: Container(
        color: Colors.blue,
        padding: const EdgeInsets.all(8),
        child: const Center(
          child: Text(
            'Updates',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
