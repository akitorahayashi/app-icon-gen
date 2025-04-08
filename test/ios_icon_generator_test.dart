import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'package:app_icon_gen/generator/ios_icon_generator.dart';

void main() {
  group('IOSIconGenerator Tests', () {
    final testImage = File('assets/icon_gen_sample.png');
    final iosOutputDir = Directory('output/ios');

    tearDownAll(() {
      // 生成された出力ディレクトリを削除
      if (iosOutputDir.existsSync()) {
        iosOutputDir.deleteSync(recursive: true);
      }
    });

    test('iOS用アイコンが正しく生成される', () async {
      // テスト前にディレクトリをクリーンアップ
      if (iosOutputDir.existsSync()) {
        iosOutputDir.deleteSync(recursive: true);
      }

      // サンプル画像を読み込む
      final bytes = testImage.readAsBytesSync();
      final originalImage = img.decodeImage(bytes)!;

      // iOS用のアイコンを生成
      IOSIconGenerator.generateIcons(originalImage);

      // AppIcon.appiconsetディレクトリが作成されたことを確認
      final appIconDir = Directory('output/ios/AppIcon.appiconset');
      expect(appIconDir.existsSync(), isTrue);

      // Contents.jsonが生成されていることを確認
      final contentsJson = File(path.join(appIconDir.path, 'Contents.json'));
      expect(contentsJson.existsSync(), isTrue);

      // 少なくとも一部のiOSアイコンが生成されていることを確認
      final iconList = appIconDir.listSync();
      expect(iconList.length, greaterThan(10));
    });

    test('iOS用アイコンの正しいサイズが生成される', () async {
      // テスト前にディレクトリをクリーンアップ
      if (iosOutputDir.existsSync()) {
        iosOutputDir.deleteSync(recursive: true);
      }

      // サンプル画像を読み込む
      final bytes = testImage.readAsBytesSync();
      final originalImage = img.decodeImage(bytes)!;

      // iOS用のアイコンを生成
      IOSIconGenerator.generateIcons(originalImage);

      // App Store用アイコンを確認 (1024x1024)
      final appStoreIcon = File(path.join(
          'output/ios/AppIcon.appiconset', 'Icon-App-1024x1024@1x.png'));
      expect(appStoreIcon.existsSync(), isTrue);

      final appStoreImage = img.decodePng(appStoreIcon.readAsBytesSync());
      expect(appStoreImage!.width, equals(1024));
      expect(appStoreImage.height, equals(1024));

      // iPhone用アイコンを確認 (60pt @3x = 180x180)
      final iphoneIcon = File(
          path.join('output/ios/AppIcon.appiconset', 'Icon-App-60x60@3x.png'));
      expect(iphoneIcon.existsSync(), isTrue);

      final iphoneImage = img.decodePng(iphoneIcon.readAsBytesSync());
      expect(iphoneImage!.width, equals(180));
      expect(iphoneImage.height, equals(180));
    });

    test('iOS 17用の最新形式アイコンが生成される', () async {
      // テスト前にディレクトリをクリーンアップ
      if (iosOutputDir.existsSync()) {
        iosOutputDir.deleteSync(recursive: true);
      }

      // サンプル画像を読み込む
      final bytes = testImage.readAsBytesSync();
      final originalImage = img.decodeImage(bytes)!;

      // iOS用のアイコンを生成
      IOSIconGenerator.generateIcons(originalImage);

      // Universalアイコンを確認
      final universalIcon = File(
          path.join('output/ios/AppIcon.appiconset', 'AppIcon-1024x1024.png'));
      expect(universalIcon.existsSync(), isTrue);

      // ダークモードアイコンを確認
      final darkIcon = File(path.join(
          'output/ios/AppIcon.appiconset', 'AppIcon-1024x1024-dark.png'));
      expect(darkIcon.existsSync(), isTrue);

      // Tintedモードアイコンを確認
      final tintedIcon = File(path.join(
          'output/ios/AppIcon.appiconset', 'AppIcon-1024x1024-tinted.png'));
      expect(tintedIcon.existsSync(), isTrue);
    });
  });
}
