import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

/// Android向けアイコン生成クラス
class AndroidIconGenerator {
  /// 各Android密度ごとのサイズマップ
  static const Map<String, int> densitySizes = {
    'mdpi': 48,
    'hdpi': 72,
    'xhdpi': 96,
    'xxhdpi': 144,
    'xxxhdpi': 192,
  };

  /// Android用のアイコンを生成
  static void generateIcons(img.Image originalImage) {
    print('Android用アイコンを生成中...');

    // 出力ディレクトリ
    final outputDir = Directory('build/android');
    outputDir.createSync(recursive: true);

    // 通常のmipmapアイコン（ランチャーアイコン）
    for (var entry in densitySizes.entries) {
      final dirName = 'mipmap-${entry.key}';
      final size = entry.value;

      // リサイズ
      final resized = img.copyResize(originalImage, width: size, height: size);
      final pngBytes = img.encodePng(resized);

      // 出力ディレクトリ
      final densityDir = Directory(path.join(outputDir.path, dirName));
      densityDir.createSync(recursive: true);

      // ファイル保存
      final iconFile = File(path.join(densityDir.path, 'ic_launcher.png'));
      iconFile.writeAsBytesSync(pngBytes);

      print('Androidアイコン作成: $dirName/ic_launcher.png (${size}x$size)');

      // アダプティブアイコン用のフォアグラウンドを作成（Android 8.0+）
      _generateAdaptiveIcon(originalImage, densityDir, size);
    }

    // アダプティブアイコン用のXMLファイルを生成
    _generateAdaptiveIconXml(outputDir);

    // Play Store用の高解像度アイコン（512x512）
    _generatePlayStoreIcon(originalImage, outputDir);

    print('Androidアイコンの生成が完了しました。');
  }

  /// Play Storeアイコンを生成
  static void _generatePlayStoreIcon(
      img.Image originalImage, Directory outputDir) {
    final playStoreDir = Directory(path.join(outputDir.path, 'playstore'));
    playStoreDir.createSync(recursive: true);

    final playStoreImage =
        img.copyResize(originalImage, width: 512, height: 512);
    final playStorePngBytes = img.encodePng(playStoreImage);
    final playStoreIconFile =
        File(path.join(playStoreDir.path, 'play_store_icon.png'));
    playStoreIconFile.writeAsBytesSync(playStorePngBytes);

    print('Play Storeアイコン作成: playstore/play_store_icon.png (512x512)');
  }

  /// アダプティブアイコンを生成（Android 8.0+）
  static void _generateAdaptiveIcon(
      img.Image original, Directory densityDir, int size) {
    // フォアグラウンドレイヤー（サイズの約70%を使用）
    final foregroundSize = (size * 0.7).toInt();
    final padding = (size - foregroundSize) ~/ 2;

    // 背景色（白）で画像を作成
    final backgroundImage = img.Image(width: size, height: size);
    img.fill(backgroundImage, color: img.ColorRgb8(255, 255, 255));

    // フォアグラウンド画像を作成（元画像をリサイズ）
    final foregroundImage =
        img.copyResize(original, width: foregroundSize, height: foregroundSize);

    // 背景を保存
    final backgroundFile =
        File(path.join(densityDir.path, 'ic_launcher_background.png'));
    backgroundFile.writeAsBytesSync(img.encodePng(backgroundImage));

    // リサイズされたフォアグラウンド画像を中央に配置
    final adaptiveForeground = img.Image(width: size, height: size);
    img.fill(adaptiveForeground, color: img.ColorRgba8(0, 0, 0, 0)); // 透明で初期化

    for (int y = 0; y < foregroundSize; y++) {
      for (int x = 0; x < foregroundSize; x++) {
        final pixelColor = foregroundImage.getPixel(x, y);
        adaptiveForeground.setPixel(x + padding, y + padding, pixelColor);
      }
    }

    // フォアグラウンドを保存
    final foregroundFile =
        File(path.join(densityDir.path, 'ic_launcher_foreground.png'));
    foregroundFile.writeAsBytesSync(img.encodePng(adaptiveForeground));

    print('Androidアダプティブアイコン作成: $densityDir (${size}x$size)');
  }

  /// Android用アダプティブアイコンのXMLファイルを生成
  static void _generateAdaptiveIconXml(Directory outputDir) {
    // valuesフォルダを作成
    final valuesDir = Directory(path.join(outputDir.path, 'values'));
    valuesDir.createSync(recursive: true);

    // colors.xmlを生成
    final colorsXml = '''<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_launcher_background">#FFFFFF</color>
</resources>
''';

    File(path.join(valuesDir.path, 'colors.xml')).writeAsStringSync(colorsXml);

    // v26用のmipmap-anydpi-v26フォルダを作成
    final v26Dir = Directory(path.join(outputDir.path, 'mipmap-anydpi-v26'));
    v26Dir.createSync(recursive: true);

    // ic_launcher.xmlを生成
    final launcherXml = '''<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/ic_launcher_background"/>
    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>
</adaptive-icon>
''';

    File(path.join(v26Dir.path, 'ic_launcher.xml'))
        .writeAsStringSync(launcherXml);

    // ic_launcher_round.xmlも同様に生成
    File(path.join(v26Dir.path, 'ic_launcher_round.xml'))
        .writeAsStringSync(launcherXml);

    print('AndroidアダプティブアイコンのXMLファイルを作成しました');
  }
}
