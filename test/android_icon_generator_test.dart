import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'package:app_icon_gen/generator/android_icon_generator.dart';

void main() {
  group('AndroidIconGenerator Tests', () {
    final testImage = File('assets/icon_gen_sample.png');
    final androidOutputDir = Directory('output/android');

    tearDownAll(() {
      // 生成された出力ディレクトリを削除
      if (androidOutputDir.existsSync()) {
        androidOutputDir.deleteSync(recursive: true);
      }
    });

    test('Android用アイコンが正しく生成される', () async {
      // テスト前にディレクトリをクリーンアップ
      if (androidOutputDir.existsSync()) {
        androidOutputDir.deleteSync(recursive: true);
      }

      // サンプル画像を読み込む
      final bytes = testImage.readAsBytesSync();
      final originalImage = img.decodeImage(bytes)!;

      // Android用のアイコンを生成
      AndroidIconGenerator.generateIcons(originalImage);

      // 出力ディレクトリを確認
      expect(androidOutputDir.existsSync(), isTrue);

      // 各密度のディレクトリを確認
      final densities = ['mdpi', 'hdpi', 'xhdpi', 'xxhdpi', 'xxxhdpi'];
      for (final density in densities) {
        final densityDir =
            Directory(path.join(androidOutputDir.path, 'mipmap-$density'));
        expect(densityDir.existsSync(), isTrue);
      }

      // Play Store用アイコンを確認
      final playStoreIcon = File(
          path.join(androidOutputDir.path, 'playstore', 'play_store_icon.png'));
      expect(playStoreIcon.existsSync(), isTrue);
    });

    test('各密度のアイコンが正しいサイズで生成される', () async {
      // テスト前にディレクトリをクリーンアップ
      if (androidOutputDir.existsSync()) {
        androidOutputDir.deleteSync(recursive: true);
      }

      // サンプル画像を読み込む
      final bytes = testImage.readAsBytesSync();
      final originalImage = img.decodeImage(bytes)!;

      // Android用のアイコンを生成
      AndroidIconGenerator.generateIcons(originalImage);

      // 各密度のアイコンサイズを確認
      final densitySizes = {
        'mdpi': 48,
        'hdpi': 72,
        'xhdpi': 96,
        'xxhdpi': 144,
        'xxxhdpi': 192,
      };

      for (final entry in densitySizes.entries) {
        final density = entry.key;
        final expectedSize = entry.value;
        final iconPath = path.join(
            androidOutputDir.path, 'mipmap-$density', 'ic_launcher.png');
        final icon = File(iconPath);
        expect(icon.existsSync(), isTrue);

        final iconImage = img.decodePng(icon.readAsBytesSync());
        expect(iconImage!.width, equals(expectedSize));
        expect(iconImage.height, equals(expectedSize));
      }
    });

    test('Play Store用アイコンが正しいサイズで生成される', () async {
      // テスト前にディレクトリをクリーンアップ
      if (androidOutputDir.existsSync()) {
        androidOutputDir.deleteSync(recursive: true);
      }

      // サンプル画像を読み込む
      final bytes = testImage.readAsBytesSync();
      final originalImage = img.decodeImage(bytes)!;

      // Android用のアイコンを生成
      AndroidIconGenerator.generateIcons(originalImage);

      // Play Store用アイコンを確認 (512x512)
      final playStoreIcon = File(
          path.join(androidOutputDir.path, 'playstore', 'play_store_icon.png'));
      expect(playStoreIcon.existsSync(), isTrue);

      final playStoreImage = img.decodePng(playStoreIcon.readAsBytesSync());
      expect(playStoreImage!.width, equals(512));
      expect(playStoreImage.height, equals(512));
    });
  });
}
