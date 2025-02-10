/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/banana.webp
  AssetGenImage get banana => const AssetGenImage('assets/images/banana.webp');

  /// File path: assets/images/big_banana.png
  AssetGenImage get bigBanana =>
      const AssetGenImage('assets/images/big_banana.png');

  /// File path: assets/images/checked.png
  AssetGenImage get checked => const AssetGenImage('assets/images/checked.png');

  /// File path: assets/images/earth_icon.png
  AssetGenImage get earthIcon =>
      const AssetGenImage('assets/images/earth_icon.png');

  /// File path: assets/images/final_banana.webp
  AssetGenImage get finalBanana =>
      const AssetGenImage('assets/images/final_banana.webp');

  /// File path: assets/images/first_banana.webp
  AssetGenImage get firstBanana =>
      const AssetGenImage('assets/images/first_banana.webp');

  /// File path: assets/images/forth_banana.webp
  AssetGenImage get forthBanana =>
      const AssetGenImage('assets/images/forth_banana.webp');

  /// File path: assets/images/hanna.webp
  AssetGenImage get hanna => const AssetGenImage('assets/images/hanna.webp');

  /// File path: assets/images/home_top_banana.png
  AssetGenImage get homeTopBanana =>
      const AssetGenImage('assets/images/home_top_banana.png');

  /// File path: assets/images/hyegyeong_profile.webp
  AssetGenImage get hyegyeongProfile =>
      const AssetGenImage('assets/images/hyegyeong_profile.webp');

  /// File path: assets/images/main_banana.webp
  AssetGenImage get mainBanana =>
      const AssetGenImage('assets/images/main_banana.webp');

  /// File path: assets/images/pixel_art.png
  AssetGenImage get pixelArt =>
      const AssetGenImage('assets/images/pixel_art.png');

  /// File path: assets/images/salt_bread.webp
  AssetGenImage get saltBread =>
      const AssetGenImage('assets/images/salt_bread.webp');

  /// File path: assets/images/second_banana.webp
  AssetGenImage get secondBanana =>
      const AssetGenImage('assets/images/second_banana.webp');

  /// File path: assets/images/small_banana.webp
  AssetGenImage get smallBanana =>
      const AssetGenImage('assets/images/small_banana.webp');

  /// File path: assets/images/snowbun.webp
  AssetGenImage get snowbun =>
      const AssetGenImage('assets/images/snowbun.webp');

  /// File path: assets/images/star_butterfly.webp
  AssetGenImage get starButterfly =>
      const AssetGenImage('assets/images/star_butterfly.webp');

  /// File path: assets/images/third_banana.webp
  AssetGenImage get thirdBanana =>
      const AssetGenImage('assets/images/third_banana.webp');

  /// File path: assets/images/yewon_profile.webp
  AssetGenImage get yewonProfile =>
      const AssetGenImage('assets/images/yewon_profile.webp');

  /// List of all assets
  List<AssetGenImage> get values => [
        banana,
        bigBanana,
        checked,
        earthIcon,
        finalBanana,
        firstBanana,
        forthBanana,
        hanna,
        homeTopBanana,
        hyegyeongProfile,
        mainBanana,
        pixelArt,
        saltBread,
        secondBanana,
        smallBanana,
        snowbun,
        starButterfly,
        thirdBanana,
        yewonProfile
      ];
}

class $AssetsTranslationsGen {
  const $AssetsTranslationsGen();

  /// File path: assets/translations/en.json
  String get en => 'assets/translations/en.json';

  /// File path: assets/translations/ja.json
  String get ja => 'assets/translations/ja.json';

  /// File path: assets/translations/ko.json
  String get ko => 'assets/translations/ko.json';

  /// File path: assets/translations/zh.json
  String get zh => 'assets/translations/zh.json';

  /// List of all assets
  List<String> get values => [en, ja, ko, zh];
}

class $AssetsUpdateNotesGen {
  const $AssetsUpdateNotesGen();

  /// File path: assets/update_notes/v1.0.0.json
  String get v100 => 'assets/update_notes/v1.0.0.json';

  /// File path: assets/update_notes/v1.0.2.json
  String get v102 => 'assets/update_notes/v1.0.2.json';

  /// File path: assets/update_notes/v1.0.3.json
  String get v103 => 'assets/update_notes/v1.0.3.json';

  /// File path: assets/update_notes/v1.0.4.json
  String get v104 => 'assets/update_notes/v1.0.4.json';

  /// List of all assets
  List<String> get values => [v100, v102, v103, v104];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsTranslationsGen translations = $AssetsTranslationsGen();
  static const $AssetsUpdateNotesGen updateNotes = $AssetsUpdateNotesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
