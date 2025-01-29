import 'dart:io';

import 'package:flutter/foundation.dart';

class AdmobIds {
  static String getHomeBannerAdId() {
    if (kDebugMode) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/6300978111';
      } else {
        return 'ca-app-pub-3940256099942544/2934735716';
      }
    } else {
      if (Platform.isAndroid) {
        return 'ca-app-pub-4452713350716636/7691375888';
      } else {
        return 'ca-app-pub-4452713350716636/7023985645';
      }
    }
  }

  static String getSingleBannerAdId() {
    if (kDebugMode) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/6300978111';
      } else {
        return 'ca-app-pub-3940256099942544/2934735716';
      }
    }
    if (Platform.isAndroid) {
      return 'ca-app-pub-4452713350716636/1474714876';
    } else {
      return 'ca-app-pub-4452713350716636/5603210308';
    }
  }

  static String getNativeAdId() {
    if (kDebugMode) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/2247696110';
      } else {
        return 'ca-app-pub-3940256099942544/3986624511';
      }
    }
    if (Platform.isAndroid) {
      return 'ca-app-pub-4452713350716636/3241962816';
    } else {
      return 'ca-app-pub-4452713350716636/2924511427';
    }
  }

  static String getInterstitialAdId() {
    if (kDebugMode) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/1033173712';
      } else {
        print('ca-app-pub-3940256099942544/4411468910');
        return 'ca-app-pub-3940256099942544/4411468910';
      }
    }
    if (Platform.isAndroid) {
      return 'ca-app-pub-4452713350716636/7181207828';
    } else {
      return 'ca-app-pub-4452713350716636/4237593090';
    }
  }

  // ios ca-app-pub-4452713350716636/5223371704
  // android ca-app-pub-4452713350716636/4940865327
  static String getOpenAppAdId() {
    if (kDebugMode) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/9257395921';
      } else {
        return 'ca-app-pub-3940256099942544/5575463023';
      }
    }
    if (Platform.isAndroid) {
      return 'ca-app-pub-4452713350716636/4940865327';
    } else {
      return 'ca-app-pub-4452713350716636/5223371704';
    }
  }
}
