import 'package:go_router/go_router.dart';
import 'package:what_the_banana/contents/counter/counter_screen.dart';
import 'package:what_the_banana/contents/ghost_leg_screen.dart';
import 'package:what_the_banana/contents/pace_counter/pace_counter_screen.dart';
import 'package:what_the_banana/contents/pixel_art/crop_screen.dart';
import 'package:what_the_banana/contents/pixel_art/pixel_art_screen.dart';
import 'package:what_the_banana/contents/qr_maker_screen.dart';
import 'package:what_the_banana/contents/roulette/roulette_screen.dart';
import 'package:what_the_banana/etc/ads/ads_screen.dart';
import 'package:what_the_banana/etc/ads/interstitial_ad_screen.dart';
import 'package:what_the_banana/etc/ads/native_ad_screen.dart';
import 'package:what_the_banana/etc/ads/open_app_ad_screen.dart';
import 'package:what_the_banana/etc/creators_screen.dart';
import 'package:what_the_banana/etc/donation/donation_screen.dart';
import 'package:what_the_banana/etc/feedback/feedback_screen.dart';
import 'package:what_the_banana/etc/feedback/sent_success_screen.dart';
import 'package:what_the_banana/etc/introduction_screen.dart';
import 'package:what_the_banana/etc/oss_licenses_view.dart';
import 'package:what_the_banana/etc/select_language_screen.dart';
import 'package:what_the_banana/etc/updates_screen.dart';
import 'package:what_the_banana/home_screen.dart';

class Routes {
  static const String home = '/';

  static const String pixelArt = '/pixelArt';
  static const String crop = '/crop';
  static const String roulette = '/roulette';
  static const String qrMaker = '/qrMaker';
  static const String paceCounter = '/paceCounter';
  static const String ghostLeg = '/ghostLeg';
  static const String counter = '/counter';

  static const String creators = '/creators';
  static const String feedback = '/feedback';
  static const String sentSuccess = '/sentSuccess';
  static const String donation = '/donation';

  static const String ads = '/ads';
  static const String openAppAd = '/openAppAd';
  static const String nativeAd = '/nativeAd';
  static const String interstitialAd = '/interstitialAd';

  static const String selectLanguage = '/selectLanguage';
  static const String updates = '/updates';
  static const String introduction = '/introduction';
  static const String ossLicenses = '/ossLicenses';

  static GoRouter getRouter = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(
        path: home,
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: introduction,
            builder: (context, state) => const IntroductionScreen(),
            routes: [
              GoRoute(
                path: ossLicenses,
                builder: (context, state) => const OssLicensesView(),
              ),
            ],
          ),
          GoRoute(
            path: donation,
            builder: (context, state) => const DonationScreen(),
          ),
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
            path: qrMaker,
            builder: (context, state) => const QrMakerScreen(),
          ),
          GoRoute(
            path: paceCounter,
            builder: (context, state) => const PaceCounterScreen(),
          ),
          GoRoute(
            path: ghostLeg,
            builder: (context, state) => const GhostLegScreen(),
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
