import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import '../model/icon_template.dart';
import '../model/android_icon_template.dart';

/// Android向けアイコン生成クラス
class AndroidIconGenerator {
  // 標準的なAndroidアイコンサイズ (px) - 典型的なアイコンサイズ
  static const Map<String, int> _densitySizes = {
    'mdpi': 48, // 1.0x
    'hdpi': 72, // 1.5x
    'xhdpi': 96, // 2.0x
    'xxhdpi': 144, // 3.0x
    'xxxhdpi': 192 // 4.0x
  };

  // アダプティブアイコンサイズ (px)
  static const Map<String, int> _adaptiveSizes = {
    'mdpi': 108, // 1.0x
    'hdpi': 162, // 1.5x
    'xhdpi': 216, // 2.0x
    'xxhdpi': 324, // 3.0x
    'xxxhdpi': 432, // 4.0x
  };

  // Play Store用アイコンサイズ (px)
  static const int _playStoreIconSize = 512;

  /// Android用のアイコンを生成
  static void generateIcons(img.Image originalImage) {
    print('Android用アイコンを生成中...');

    // ディレクトリを作成
    _ensureDirectoriesExist();

    // 通常アイコンを生成
    _generateTraditionalIcons(originalImage);

    // アダプティブアイコンを生成
    _generateAdaptiveIcons(originalImage);

    // Playストアアイコンを生成
    _generatePlayStoreIcon(originalImage);

    print('Androidアイコンの生成が完了しました。');
  }

  /// 必要なディレクトリを作成
  static void _ensureDirectoriesExist() {
    // 各密度のミップマップディレクトリ
    for (final density in _densitySizes.keys) {
      Directory('build/android/mipmap-$density').createSync(recursive: true);
    }

    // xml用のディレクトリ
    Directory('build/android/mipmap-anydpi-v26').createSync(recursive: true);

    // valuesディレクトリ
    Directory('build/android/values').createSync(recursive: true);

    // プレイストアディレクトリ
    Directory('build/android/playstore').createSync(recursive: true);
  }

  /// 標準的なアイコンを生成（古いAndroid用）
  static void _generateTraditionalIcons(img.Image originalImage) {
    for (final entry in _densitySizes.entries) {
      final density = entry.key;
      final size = entry.value;

      final resized = img.copyResize(originalImage, width: size, height: size);
      final outputPath = 'build/android/mipmap-$density/ic_launcher.png';

      // テンプレートを作成
      final template = AndroidIconTemplate(
        size: size.toDouble(),
        scale: 1,
        idiom: 'android',
        filename: 'ic_launcher.png',
        density: density,
      );

      // ファイルに保存
      File(outputPath).writeAsBytesSync(img.encodePng(resized));
      print('Androidアイコン作成: mipmap-$density/ic_launcher.png (${size}x$size)');

      // アダプティブアイコンも作成
      _generateAdaptiveIconsForDensity(originalImage, density);
    }
  }

  /// 特定の密度のアダプティブアイコンを生成（Android 8.0+用）
  static void _generateAdaptiveIconsForDensity(
      img.Image originalImage, String density) {
    final adaptiveSize = _adaptiveSizes[density]!;
    final outputDir = 'build/android/mipmap-$density';

    // 前景レイヤーを作成
    final foregroundImage = _createForegroundLayer(originalImage, adaptiveSize);
    File('$outputDir/ic_launcher_foreground.png')
        .writeAsBytesSync(img.encodePng(foregroundImage));

    // 背景レイヤーを作成
    final backgroundImage = _createBackgroundLayer(adaptiveSize);
    File('$outputDir/ic_launcher_background.png')
        .writeAsBytesSync(img.encodePng(backgroundImage));

    print(
        'Androidアダプティブアイコン作成: Directory: \'$outputDir\' (${adaptiveSize}x$adaptiveSize)');
  }

  /// アダプティブアイコン用のXMLファイルを生成
  static void _generateAdaptiveIconsXml() {
    // ic_launcher.xml
    final launcherXml = '''<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@mipmap/ic_launcher_background"/>
    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>
</adaptive-icon>''';

    // ic_launcher_round.xml
    final roundXml = '''<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@mipmap/ic_launcher_background"/>
    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>
</adaptive-icon>''';

    // colors.xml
    final colorsXml = '''<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_launcher_background">#FFFFFF</color>
</resources>''';

    // XMLファイルを保存
    File('build/android/mipmap-anydpi-v26/ic_launcher.xml')
        .writeAsStringSync(launcherXml);
    File('build/android/mipmap-anydpi-v26/ic_launcher_round.xml')
        .writeAsStringSync(roundXml);
    File('build/android/values/colors.xml').writeAsStringSync(colorsXml);

    print('AndroidアダプティブアイコンのXMLファイルを作成しました');
  }

  /// アダプティブアイコンを生成（Android 8.0+用）
  static void _generateAdaptiveIcons(img.Image originalImage) {
    // 各密度のアダプティブアイコンを生成
    for (final density in _densitySizes.keys) {
      _generateAdaptiveIconsForDensity(originalImage, density);
    }

    // XMLファイルを生成
    _generateAdaptiveIconsXml();
  }

  /// Play Store用アイコンを生成
  static void _generatePlayStoreIcon(img.Image originalImage) {
    final size = _playStoreIconSize;
    final resized = img.copyResize(originalImage, width: size, height: size);

    // テンプレートを作成
    final template = AndroidIconTemplate(
      size: size.toDouble(),
      scale: 1,
      idiom: 'android-marketing',
      filename: 'play_store_icon.png',
    );

    final output = 'build/android/playstore/play_store_icon.png';
    File(output).writeAsBytesSync(img.encodePng(resized));
    print('Play Storeアイコン作成: playstore/play_store_icon.png (${size}x$size)');
  }

  /// アダプティブアイコンの前景レイヤーを作成
  static img.Image _createForegroundLayer(img.Image original, int size) {
    // アイコンサイズを前景レイヤーのための小さいサイズにする（通常72%くらい）
    final iconSize = (size * 0.72).toInt();

    // オリジナル画像をリサイズ
    final resizedIcon =
        img.copyResize(original, width: iconSize, height: iconSize);

    // 新しい前景レイヤー画像を作成（透明背景）
    final foreground = img.Image(width: size, height: size, numChannels: 4);

    // 前景レイヤーの中央にアイコンを配置
    final offsetX = (size - iconSize) ~/ 2;
    final offsetY = (size - iconSize) ~/ 2;

    img.compositeImage(foreground, resizedIcon, dstX: offsetX, dstY: offsetY);

    return foreground;
  }

  /// アダプティブアイコンの背景レイヤーを作成
  static img.Image _createBackgroundLayer(int size) {
    // 白背景のレイヤーを作成
    final background = img.Image(width: size, height: size, numChannels: 4);

    // 背景を白色で埋める
    img.fill(background, color: img.ColorRgba8(255, 255, 255, 255));

    return background;
  }
}
