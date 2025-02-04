import 'package:go_router/go_router.dart';
import 'package:what_the_banana/contents/counter/counter_screen.dart';
import 'package:what_the_banana/contents/pixel_art/crop_screen.dart';
import 'package:what_the_banana/contents/pixel_art/pixel_art_screen.dart';
import 'package:what_the_banana/contents/puzzle/puzzle_screen.dart';
import 'package:what_the_banana/contents/roulette/roulette_screen.dart';
import 'package:what_the_banana/etc/ads/ads_screen.dart';
import 'package:what_the_banana/etc/ads/interstitial_ad_screen.dart';
import 'package:what_the_banana/etc/ads/native_ad_screen.dart';
import 'package:what_the_banana/etc/ads/open_app_ad_screen.dart';
import 'package:what_the_banana/etc/creators_screen.dart';
import 'package:what_the_banana/etc/feedback/feedback_screen.dart';
import 'package:what_the_banana/etc/feedback/sent_success_screen.dart';
import 'package:what_the_banana/etc/select_language_screen.dart';
import 'package:what_the_banana/etc/updates_screen.dart';
import 'package:what_the_banana/home_screen.dart';

class Routes {
  static const String home = '/';

  static const String pixelArt = '/pixelArt';
  static const String crop = '/crop';
  static const String roulette = '/roulette';
  static const String puzzle = '/puzzle';
  static const String counter = '/counter';

  static const String creators = '/creators';
  static const String feedback = '/feedback';
  static const String sentSuccess = '/sentSuccess';

  static const String ads = '/ads';
  static const String openAppAd = '/openAppAd';
  static const String nativeAd = '/nativeAd';
  static const String interstitialAd = '/interstitialAd';

  static const String selectLanguage = '/selectLanguage';
  static const String updates = '/updates';

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
            routes: [
              GoRoute(
                path: sentSuccess,
                builder: (context, state) => const SentSuccessScreen(),
              ),
            ],
          ),
          GoRoute(
            path: ads,
            builder: (context, state) => const AdsScreen(),
            routes: [
              GoRoute(
                path: openAppAd,
                builder: (context, state) => const OpenAppAdScreen(),
              ),
              GoRoute(
                path: nativeAd,
                builder: (context, state) => const NativeAdScreen(),
              ),
              GoRoute(
                path: interstitialAd,
                builder: (context, state) => const InterstitialAdScreen(),
              ),
            ],
          ),
          GoRoute(
            path: counter,
            builder: (context, state) => const CounterScreen(),
          ),
          GoRoute(
            path: selectLanguage,
            builder: (context, state) => const SelectLanguageScreen(),
          ),
          GoRoute(
            path: updates,
            builder: (context, state) => const UpdatesScreen(),
          ),
        ],
      ),
    ],
  );
}
