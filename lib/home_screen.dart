import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:what_the_banana/gen/colors.gen.dart';
import 'package:what_the_banana/routes.dart';
import 'package:what_the_banana/ui/banana_background.dart';
import 'package:what_the_banana/ui/banana_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _setAdUnitId();
    _loadAd();
  }

  void _setAdUnitId() {
    if (!kReleaseMode) {
      adUnitId = 'ca-app-pub-3940256099942544/2934735716';
    } else {
      if (Platform.isAndroid) {
        adUnitId = 'ca-app-pub-4452713350716636/7691375888';
      } else {
        adUnitId = 'ca-app-pub-4452713350716636/7023985645';
      }
    }
  }

  int tappedBananaLevel = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.yellowBackground,
      body: Stack(
        children: [
          const BananaBackground(),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: GestureDetector(
                          onTap: tapBanana,
                          child: BananaImage(tappedBananaLevel),
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        height: 400,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              mainAxisExtent: 50,
                            ),
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return PixelArtButton(context);
                              } else if (index == 1) {
                                return RouletteButton(context);
                              } else if (index == 2) {
                                return PuzzleButton(context);
                              } else if (index == 3) {
                                return CreatorsButton(context);
                              } else if (index == 4) {
                                return FeedbackButton(context);
                              } else if (index == 5) {
                                return AdsButton(context);
                              } else if (index == 6) {
                                return CounterButton(context);
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_ad != null && _isLoaded)
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: _ad!.size.width.toDouble(),
                  height: _ad!.size.height.toDouble(),
                  child: AdWidget(ad: _ad!),
                ),
              ),
            ),
        ],
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
    return CupertinoButton(
      onPressed: () {
        context.go(Routes.pixelArt);
      },
      color: Colors.blue,
      child: const Center(
        child: Text(
          'Pixel Art',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
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
        color: Colors.blue,
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
        color: Colors.blue,
        padding: const EdgeInsets.all(8),
        child: const Text(
          'Puzzle',
          style: TextStyle(
            color: Colors.white,
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
        child: const Text(
          'Creators',
          style: TextStyle(
            color: Colors.white,
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
        child: const Text(
          'Feedback',
          style: TextStyle(
            color: Colors.white,
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
        child: const Text(
          'Ads',
          style: TextStyle(
            color: Colors.white,
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

  late String adUnitId;
  BannerAd? _ad;
  bool _isLoaded = false;

  void _loadAd() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.sizeOf(context).width.truncate(),
      );
      if (size == null) return;

      _ad = BannerAd(
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
            ad.dispose();
          },
        ),
      )..load();
    });
  }
}
