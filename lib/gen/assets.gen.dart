// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsIconGen {
  const $AssetsIconGen();

  /// File path: assets/icon/MoonForge-Logo-Icon-W_1024.png
  AssetGenImage get moonForgeLogoIconW1024 =>
      const AssetGenImage('assets/icon/MoonForge-Logo-Icon-W_1024.png');

  /// File path: assets/icon/MoonForge-Logo-Icon-W_256.png
  AssetGenImage get moonForgeLogoIconW256 =>
      const AssetGenImage('assets/icon/MoonForge-Logo-Icon-W_256.png');

  /// File path: assets/icon/MoonForge-Logo-Icon-W_512.png
  AssetGenImage get moonForgeLogoIconW512 =>
      const AssetGenImage('assets/icon/MoonForge-Logo-Icon-W_512.png');

  /// File path: assets/icon/MoonForge-Logo-Icon.afdesign
  String get moonForgeLogoIcon => 'assets/icon/MoonForge-Logo-Icon.afdesign';

  /// File path: assets/icon/MoonForge-Logo-Icon_1024.png
  AssetGenImage get moonForgeLogoIcon1024 =>
      const AssetGenImage('assets/icon/MoonForge-Logo-Icon_1024.png');

  /// File path: assets/icon/MoonForge-Logo-Icon_256.png
  AssetGenImage get moonForgeLogoIcon256 =>
      const AssetGenImage('assets/icon/MoonForge-Logo-Icon_256.png');

  /// File path: assets/icon/MoonForge-Logo-Icon_512.png
  AssetGenImage get moonForgeLogoIcon512 =>
      const AssetGenImage('assets/icon/MoonForge-Logo-Icon_512.png');

  /// File path: assets/icon/MoonForge-Logo-W_1024.png
  AssetGenImage get moonForgeLogoW1024 =>
      const AssetGenImage('assets/icon/MoonForge-Logo-W_1024.png');

  /// File path: assets/icon/MoonForge-Logo-W_256.png
  AssetGenImage get moonForgeLogoW256 =>
      const AssetGenImage('assets/icon/MoonForge-Logo-W_256.png');

  /// File path: assets/icon/MoonForge-Logo-W_512.png
  AssetGenImage get moonForgeLogoW512 =>
      const AssetGenImage('assets/icon/MoonForge-Logo-W_512.png');

  /// File path: assets/icon/MoonForge-Logo.afdesign
  String get moonForgeLogo => 'assets/icon/MoonForge-Logo.afdesign';

  /// File path: assets/icon/MoonForge-Logo_1024.png
  AssetGenImage get moonForgeLogo1024 =>
      const AssetGenImage('assets/icon/MoonForge-Logo_1024.png');

  /// File path: assets/icon/MoonForge-Logo_256.png
  AssetGenImage get moonForgeLogo256 =>
      const AssetGenImage('assets/icon/MoonForge-Logo_256.png');

  /// File path: assets/icon/MoonForge-Logo_512.png
  AssetGenImage get moonForgeLogo512 =>
      const AssetGenImage('assets/icon/MoonForge-Logo_512.png');

  /// List of all assets
  List<dynamic> get values => [
    moonForgeLogoIconW1024,
    moonForgeLogoIconW256,
    moonForgeLogoIconW512,
    moonForgeLogoIcon,
    moonForgeLogoIcon1024,
    moonForgeLogoIcon256,
    moonForgeLogoIcon512,
    moonForgeLogoW1024,
    moonForgeLogoW256,
    moonForgeLogoW512,
    moonForgeLogo,
    moonForgeLogo1024,
    moonForgeLogo256,
    moonForgeLogo512,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsIconGen icon = $AssetsIconGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

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
    FilterQuality filterQuality = FilterQuality.medium,
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

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
