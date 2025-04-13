import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path; // path をインポート
import '../content/android_icon_content.dart';

/// Android向けアイコン生成クラス
class AndroidIconGenerator {
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
    // 各密度のミップマップディレクトリ (アダプティブ用も含む)
    final densities = {
      ...kTraditionalDensitySizes.keys,
      ...kAdaptiveSizes.keys
    };
    for (final density in densities) {
      Directory('output/android/mipmap-$density').createSync(recursive: true);
    }

    // xml用のディレクトリ
    Directory('output/android/mipmap-anydpi-v26').createSync(recursive: true);

    // valuesディレクトリ (XMLで参照される場合)
    // Directory('output/android/values').createSync(recursive: true);

    // プレイストアディレクトリ
    Directory('output/android/playstore').createSync(recursive: true);
  }

  /// 標準的なアイコンを生成（古いAndroid用）
  static void _generateTraditionalIcons(img.Image originalImage) {
    print('標準アイコンを生成中...');
    for (final entry in kTraditionalDensitySizes.entries) {
      final density = entry.key;
      final size = entry.value;

      final resized = img.copyResize(originalImage, width: size, height: size);
      final outputPath = 'output/android/mipmap-$density/ic_launcher.png';

      // ファイルに保存
      File(outputPath).writeAsBytesSync(img.encodePng(resized));
      print('Androidアイコン作成: mipmap-$density/ic_launcher.png (${size}x$size)');

      // round版も作成 (同じ画像を使用)
      // TODO: 本来は円形クリッピングすべき
      final roundOutputPath =
          'output/android/mipmap-$density/ic_launcher_round.png';
      File(roundOutputPath).writeAsBytesSync(img.encodePng(resized));
      print(
          'Android Roundアイコン作成: mipmap-$density/ic_launcher_round.png (${size}x$size)');

      // 削除: _generateAdaptiveIconsForDensity(originalImage, density);
    }
    print('標準アイコンの生成が完了しました。');
  }

  /// 特定の密度のアダプティブアイコンレイヤーを生成
  static void _generateAdaptiveIconsForDensity(
      img.Image originalImage, String density) {
    final size = kAdaptiveSizes[density]!;
    final outputDir = 'output/android/mipmap-$density';

    // 前景レイヤーを作成
    final foregroundImage = _createForegroundLayer(originalImage, size);
    File(path.join(outputDir, 'ic_launcher_foreground.png')) // pathを使用
        .writeAsBytesSync(img.encodePng(foregroundImage));

    // 背景レイヤーを作成
    final backgroundImage = _createBackgroundLayer(size);
    File(path.join(outputDir, 'ic_launcher_background.png')) // pathを使用
        .writeAsBytesSync(img.encodePng(backgroundImage));

    print('Androidアダプティブアイコン作成: mipmap-$density (${size}x$size)');
  }

  /// アダプティブアイコン用のXMLファイルを生成
  static void _generateAdaptiveIconsXml() {
    final xmlDir = 'output/android/mipmap-anydpi-v26';

    // ic_launcher.xml
    File(path.join(xmlDir, kAdaptiveIconXmlName))
        .writeAsStringSync(kAdaptiveIconXmlTemplate);

    // ic_launcher_monochrome.xml (例)
    File(path.join(xmlDir, kMonochromeIconXmlName))
        .writeAsStringSync(kMonochromeIconXmlTemplate);

    // colors.xml (もし背景色定義が必要なら)
    // final valuesDir = 'output/android/values';
    // Directory(valuesDir).createSync(recursive: true);
    // File(path.join(valuesDir, 'colors.xml'))
    //     .writeAsStringSync('...');

    print('AndroidアダプティブアイコンのXMLファイルを作成しました');
  }

  /// アダプティブアイコンを生成（Android 8.0+用）
  static void _generateAdaptiveIcons(img.Image originalImage) {
    print('アダプティブアイコンを生成中...');
    // 各密度のアダプティブアイコンレイヤーを生成
    for (final density in kAdaptiveSizes.keys) {
      _generateAdaptiveIconsForDensity(originalImage, density);
    }

    // XMLファイルを生成
    _generateAdaptiveIconsXml();
    print('アダプティブアイコンの生成が完了しました。');
  }

  /// Play Store用アイコンを生成
  static void _generatePlayStoreIcon(img.Image originalImage) {
    print('Play Storeアイコンを生成中...');
    final size = kPlayStoreSize;
    final resized = img.copyResize(originalImage, width: size, height: size);

    final output = 'output/android/playstore/play_store_icon.png';
    File(output).writeAsBytesSync(img.encodePng(resized));
    print('Play Storeアイコン作成: playstore/play_store_icon.png (${size}x$size)');
    print('Play Storeアイコンの生成が完了しました。');
  }

  /// アダプティブアイコンの前景レイヤーを作成
  static img.Image _createForegroundLayer(img.Image original, int size) {
    // アイコンサイズを前景レイヤーのための小さいサイズにする（中心の72%）
    final iconSize = (size * 0.72).toInt();

    // オリジナル画像をリサイズ
    final resizedIcon =
        img.copyResize(original, width: iconSize, height: iconSize);

    // 新しい前景レイヤー画像を作成（透明背景）
    final foreground = img.Image(width: size, height: size, numChannels: 4);
    // 透明で初期化
    img.fill(foreground, color: img.ColorRgba8(0, 0, 0, 0));

    // 前景レイヤーの中央にアイコンを配置
    final offsetX = (size - iconSize) ~/ 2;
    final offsetY = (size - iconSize) ~/ 2;

    img.compositeImage(foreground, resizedIcon, dstX: offsetX, dstY: offsetY);

    return foreground;
  }

  /// アダプティブアイコンの背景のレイヤーを作成
  static img.Image _createBackgroundLayer(int size) {
    // デフォルトは白背景のレイヤーを作成
    final background = img.Image(width: size, height: size);
    img.fill(background, color: img.ColorRgb8(255, 255, 255));
    return background;
  }
}
