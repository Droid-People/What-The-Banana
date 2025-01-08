import 'package:go_router/go_router.dart';
import 'package:what_the_banana/contents/pixel_art/pixel_art_screen.dart';
import 'package:what_the_banana/contents/puzzle/puzzle_screen.dart';
import 'package:what_the_banana/contents/roulette/roulette_screen.dart';
import 'package:what_the_banana/etc/ads_screen.dart';
import 'package:what_the_banana/etc/developers_screen.dart';
import 'package:what_the_banana/etc/feedback_screen.dart';
import 'package:what_the_banana/home_screen.dart';

class Routes {
  static const String home = '/';
  static const String pixelArt = '/pixelArt';
  static const String roulette = '/roulette';
  static const String puzzle = '/puzzle';
  static const String developers = '/developers';
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
            path: developers,
            builder: (context, state) => const DevelopersScreen(),
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
