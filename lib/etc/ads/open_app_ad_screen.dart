import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:what_the_banana/common/logger.dart';
import 'package:what_the_banana/etc/ads/admob_ids.dart';
import 'package:what_the_banana/gen/colors.gen.dart';

class OpenAppAdScreen extends StatefulWidget {
  const OpenAppAdScreen({super.key});

  @override
  State<OpenAppAdScreen> createState() => _OpenAppAdScreenState();
}

class _OpenAppAdScreenState extends State<OpenAppAdScreen> {

  @override
  void initState() {
    super.initState();
    AppOpenAd.load(
      adUnitId: AdmobIds.getOpenAppAdId(),
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (AppOpenAd ad) {
          ad..fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (Ad ad) {
              Log.i('$ad onAdShowedFullScreenContent.');
            },
            onAdDismissedFullScreenContent: (Ad ad) {
              context.pop();
            },
          )
          ..show();
        },
        onAdFailedToLoad: (LoadAdError error) {
          Log.e('Failed to load open app ad: $error');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorName.yellowBackground,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: ColorName.yellowBackground,
      body: const Center(
        child: Text('Open App Ad Screen', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
