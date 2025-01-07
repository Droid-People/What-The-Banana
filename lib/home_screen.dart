import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:what_the_banana/gen/assets.gen.dart';
import 'package:what_the_banana/gen/colors.gen.dart';
import 'package:what_the_banana/routes.dart';
import 'package:what_the_banana/ui/banana_background.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.yellowBackground,
      body: Stack(
        children: [
          const BananaBackground(),
          Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Assets.images.mainBanana.image(
                    fit: BoxFit.cover,
                    width: 300,
                    height: 300,
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
                          return DevelopersButton(context);
                        } else if (index == 4) {
                          return FeedbackButton(context);
                        } else if (index == 5) {
                          return AdsButton(context);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

  GestureDetector DevelopersButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go(Routes.developers);
      },
      child: Container(
        color: Colors.blue,
        padding: const EdgeInsets.all(8),
        child: const Text(
          'Developers',
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
}
