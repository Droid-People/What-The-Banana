import 'package:go_router/go_router.dart';
import 'package:what_the_banana/contents/pixel_art/crop_screen.dart';
import 'package:what_the_banana/contents/pixel_art/pixel_art_screen.dart';
import 'package:what_the_banana/contents/puzzle/puzzle_screen.dart';
import 'package:what_the_banana/contents/roulette/roulette_screen.dart';
import 'package:what_the_banana/etc/ads_screen.dart';
import 'package:what_the_banana/etc/creators_screen.dart';
import 'package:what_the_banana/etc/feedback_screen.dart';
import 'package:what_the_banana/home_screen.dart';

class Routes {
  static const String home = '/';
  static const String pixelArt = '/pixelArt';
  static const String crop = '/crop';

  static const String roulette = '/roulette';
  static const String puzzle = '/puzzle';
  static const String creators = '/creators';
  static const String feedback = '/feedback';
  static const String ads = '/ads';

  static GoRouter getRouter = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(
        path: home,
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: pixelArt,
            builder: (context, state) => const PixelArtScreen(),
            routes: [
              GoRoute(
                  path: crop,
                  builder: (context, state) => const CropScreen(),
              ),
            ],
          ),
          GoRoute(
            path: roulette,
            builder: (context, state) => const RouletteScreen(),
          ),
          GoRoute(
            path: puzzle,
            builder: (context, state) => const PuzzleScreen(),
          ),
          GoRoute(
            path: creators,
            builder: (context, state) => const CreatorsScreen(),
          ),
          GoRoute(
            path: feedback,
            builder: (context, state) => const FeedbackScreen(),
          ),
          GoRoute(
            path: ads,
            builder: (context, state) => const AdsScreen(),
          ),
        ],
      ),
    ],
  );
}
