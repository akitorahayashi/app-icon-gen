import 'dart:io';
import 'package:image/image.dart' as img;

import 'platform/android_icon_generator.dart';
import 'platform/ios_icon_generator.dart';
import 'platform/watchos_icon_generator.dart';

/// アイコン生成のための統合クラス
class AppIconGenerator {
  /// 指定されたプラットフォーム用のアイコンを生成する
  ///
  /// [inputPath] 入力画像へのパス
  /// [platform] 対象プラットフォーム（'ios'、'android'、'watchos'）
  static void generateIcons(String inputPath, String platform) {
    // 入力画像を読み込む
    final inputFile = File(inputPath);
    if (!inputFile.existsSync()) {
      throw Exception('入力ファイルが見つかりません: $inputPath');
    }

    final bytes = inputFile.readAsBytesSync();
    final originalImage = img.decodeImage(bytes);
    if (originalImage == null) {
      throw Exception('画像のデコードに失敗しました。');
    }

    print('画像を処理中: $inputPath');

    // プラットフォームごとに処理
    switch (platform) {
      case 'ios':
        IOSIconGenerator.generateIcons(originalImage);
        break;
      case 'android':
        AndroidIconGenerator.generateIcons(originalImage);
        break;
      case 'watchos':
        WatchOSIconGenerator.generateIcons(originalImage);
        break;
      default:
        throw Exception(
            'サポートされていないプラットフォーム: $platform\n有効なプラットフォーム: ios, android, watchos');
    }
  }
}
