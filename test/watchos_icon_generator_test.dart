import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'package:app_icon_gen/generator/watchos_icon_generator.dart';

void main() {
  group('WatchOSIconGenerator Tests', () {
    final testImage = File('assets/icon_gen_sample.png');
    final watchosOutputDir = Directory('output/watchos');

    tearDownAll(() {
      // 生成された出力ディレクトリを削除
      if (watchosOutputDir.existsSync()) {
        watchosOutputDir.deleteSync(recursive: true);
      }
    });

    test('watchOS用アイコンが正しく生成される', () async {
      // テスト前にディレクトリをクリーンアップ
      if (watchosOutputDir.existsSync()) {
        watchosOutputDir.deleteSync(recursive: true);
      }

      // サンプル画像を読み込む
      final bytes = testImage.readAsBytesSync();
      final originalImage = img.decodeImage(bytes)!;

      // watchOS用のアイコンを生成
      WatchOSIconGenerator.generateIcons(originalImage);

      // 出力ディレクトリを確認
      final appIconDir = Directory('output/watchos/AppIcon.appiconset');
      expect(appIconDir.existsSync(), isTrue);

      // Contents.jsonが生成されていることを確認
      final contentsJson = File(path.join(appIconDir.path, 'Contents.json'));
      expect(contentsJson.existsSync(), isTrue);

      // 少なくとも一部のwatchOSアイコンが生成されていることを確認
      final iconList = appIconDir.listSync();
      expect(iconList.length, greaterThan(10));
    });

    test('watchOS用アイコンの正しいサイズが生成される', () async {
      // テスト前にディレクトリをクリーンアップ
      if (watchosOutputDir.existsSync()) {
        watchosOutputDir.deleteSync(recursive: true);
      }

      // サンプル画像を読み込む
      final bytes = testImage.readAsBytesSync();
      final originalImage = img.decodeImage(bytes)!;

      // watchOS用のアイコンを生成
      WatchOSIconGenerator.generateIcons(originalImage);

      // App Store用アイコンを確認 (1024x1024)
      final appStoreIcon = File(path.join(
          'output/watchos/AppIcon.appiconset', 'AppIcon1024x1024@1x.png'));
      expect(appStoreIcon.existsSync(), isTrue);

      final appStoreImage = img.decodePng(appStoreIcon.readAsBytesSync());
      expect(appStoreImage!.width, equals(1024));
      expect(appStoreImage.height, equals(1024));

      // Companion設定用アイコンを確認 (29pt @3x = 87x87)
      final companionIcon = File(path.join(
          'output/watchos/AppIcon.appiconset', 'AppIcon29x29@3x.png'));
      expect(companionIcon.existsSync(), isTrue);

      final companionImage = img.decodePng(companionIcon.readAsBytesSync());
      expect(companionImage!.width, equals(87));
      expect(companionImage.height, equals(87));
    });

    test('各Apple Watchサイズのアイコンが生成される', () async {
      // テスト前にディレクトリをクリーンアップ
      if (watchosOutputDir.existsSync()) {
        watchosOutputDir.deleteSync(recursive: true);
      }

      // サンプル画像を読み込む
      final bytes = testImage.readAsBytesSync();
      final originalImage = img.decodeImage(bytes)!;

      // watchOS用のアイコンを生成
      WatchOSIconGenerator.generateIcons(originalImage);

      final appiconDir = Directory('output/watchos/AppIcon.appiconset');

      // 主要なApple Watch向けアイコンをチェック（いくつかのモデルのみ）

      // 38mm watch
      final icon24 = File(path.join(appiconDir.path, 'AppIcon24x24@2x.png'));
      expect(icon24.existsSync(), isTrue);

      // 42mm watch
      final icon27 =
          File(path.join(appiconDir.path, 'AppIcon27.5x27.5@2x.png'));
      expect(icon27.existsSync(), isTrue);

      // 44mm watch
      final icon50 = File(path.join(appiconDir.path, 'AppIcon50x50@2x.png'));
      expect(icon50.existsSync(), isTrue);

      // 45mm watch
      final icon51 = File(path.join(appiconDir.path, 'AppIcon51x51@2x.png'));
      expect(icon51.existsSync(), isTrue);

      // 49mm watch
      final icon54 = File(path.join(appiconDir.path, 'AppIcon54x54@2x.png'));
      expect(icon54.existsSync(), isTrue);
    });

    test('watchOSアイコンのContents.jsonが生成される', () {
      // Contents.jsonを確認
      final appiconDir = Directory('output/watchos/AppIcon.appiconset');
      final contentsJson = File(path.join(appiconDir.path, 'Contents.json'));
      expect(contentsJson.existsSync(), isTrue);
    });
  });
}
