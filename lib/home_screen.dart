import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:what_the_banana/etc/ads/admob_ids.dart';
import 'package:what_the_banana/gen/assets.gen.dart';
import 'package:what_the_banana/gen/colors.gen.dart';
import 'package:what_the_banana/routes.dart';
import 'package:what_the_banana/ui/marquee.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String adUnitId = AdmobIds.getHomeBannerAdId();
  int tappedBananaLevel = 0;
  GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.homeMainBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 330,
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.go(Routes.updates);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 330,
                      color: ColorName.homeTopBackground,
                    ),
                  ),
                  SafeArea(
                    child: Center(child: Assets.images.homeTopBanana.image()),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 55, horizontal: 35),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Assets.images.earthIcon.image(),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: MarqueeWidget(),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
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

  Widget PixelArtButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go(Routes.pixelArt);
      },
      child: Container(
        color: Colors.blue,
        padding: const EdgeInsets.all(8),
        child: const Center(
          child: Text(
            'Pixel Art',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector RouletteButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go(Routes.roulette);
      },
      child: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(8),
        child: const Center(
          child: Text(
            'Roulette',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector PuzzleButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go(Routes.puzzle);
      },
      child: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(8),
        child: const Center(
          child: Text(
            'Puzzle',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector CreatorsButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go(Routes.creators);
      },
      child: Container(
        color: Colors.blue,
        padding: const EdgeInsets.all(8),
        child: const Center(
          child: Text(
            'Creators',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector FeedbackButton(BuildContext context) {
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

  GestureDetector AdsButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go(Routes.ads);
      },
      child: Container(
        color: Colors.blue,
        padding: const EdgeInsets.all(8),
        child: const Center(
          child: Text(
            'Ads',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget CounterButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go(Routes.counter);
      },
      onLongPress: () {
        context.go(Routes.counter, extra: true);
      },
      child: Container(
        color: Colors.blue,
        padding: const EdgeInsets.all(8),
        child: const Center(
          child: Text(
            'Counter',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget LanguageButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go(Routes.selectLanguage);
      },
      child: Container(
        color: Colors.blue,
        padding: const EdgeInsets.all(8),
        child: const Center(
          child: Text(
            'Lang',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget UpdatesButton(BuildContext context) {
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
