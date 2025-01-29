import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:what_the_banana/common/logger.dart';
import 'package:what_the_banana/etc/ads/admob_ids.dart';
import 'package:what_the_banana/gen/assets.gen.dart';
import 'package:what_the_banana/gen/colors.gen.dart';

class NativeAdScreen extends StatefulWidget {
  const NativeAdScreen({super.key});

  @override
  State<NativeAdScreen> createState() => _NativeAdScreenState();
}

class _NativeAdScreenState extends State<NativeAdScreen> {
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;

  @override
  Widget build(BuildContext context) => Scaffold(
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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.separated(
              itemCount: 6,
              separatorBuilder: (BuildContext context, int index) {
                return Container(
                  height: 20,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                if (index == 3 && _nativeAd != null && _nativeAdIsLoaded) {
                  return ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 300,
                      minHeight: 350,
                      maxHeight: 350,
                      maxWidth: 450,
                    ),
                    child: AdWidget(ad: _nativeAd!),
                  );
                }
                final item = Assets.images.smallBanana.image(width: 40, height: 40);
                return GestureDetector(
                  onTap: () {
                    final message = List.generate(index + 1, (index) => '🍌').join();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(index + 1, (index) => item),
                  ),
                );
              },
            ),
          ),
        ),
      );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Create the ad objects and load ads.
    _nativeAd = NativeAd(
      adUnitId: AdmobIds.getNativeAdId(),
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          Log.i('$NativeAd loaded.');
          setState(() {
            _nativeAdIsLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          Log.e('$NativeAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => Log.d('$NativeAd onAdOpened.'),
        onAdClosed: (Ad ad) => Log.d('$NativeAd onAdClosed.'),
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor: Colors.white12,
        callToActionTextStyle: NativeTemplateTextStyle(
          size: 16,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black38,
          backgroundColor: Colors.white70,
        ),
      ),
    )..load();
  }

  @override
  void dispose() {
    super.dispose();
    _nativeAd?.dispose();
  }
}
