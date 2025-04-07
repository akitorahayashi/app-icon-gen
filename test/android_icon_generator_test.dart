import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'package:app_icon_gen/generator/android_icon_generator.dart';

void main() {
  group('Android Icon Generator Tests', () {
    // サンプル画像のパス
    final String sampleImagePath = 'assets/icon_gen_sample.png';

    tearDownAll(() {
      // 生成された出力ディレクトリを削除
      final androidOutputDir = Directory('build/android');
      if (androidOutputDir.existsSync()) {
        androidOutputDir.deleteSync(recursive: true);
      }
    });

    test('Android用アイコンが正しく生成される', () {
      // サンプル画像を読み込む
      final inputFile = File(sampleImagePath);
      final bytes = inputFile.readAsBytesSync();
      final originalImage = img.decodeImage(bytes)!;

      // Android用のアイコンを生成
      AndroidIconGenerator.generateIcons(originalImage);

      final androidBaseDir = Directory('build/android');
      expect(androidBaseDir.existsSync(), isTrue);

      // 各密度フォルダを確認
      final densities = ['mdpi', 'hdpi', 'xhdpi', 'xxhdpi', 'xxxhdpi'];
      for (final density in densities) {
        final densityDir =
            Directory(path.join(androidBaseDir.path, 'mipmap-$density'));
        expect(densityDir.existsSync(), isTrue);

        // アイコンファイルが存在することを確認
        final launcherIcon =
            File(path.join(densityDir.path, 'ic_launcher.png'));
        expect(launcherIcon.existsSync(), isTrue);

        // アダプティブアイコンファイルを確認
        final foregroundIcon =
            File(path.join(densityDir.path, 'ic_launcher_foreground.png'));
        expect(foregroundIcon.existsSync(), isTrue);

        final backgroundIcon =
            File(path.join(densityDir.path, 'ic_launcher_background.png'));
        expect(backgroundIcon.existsSync(), isTrue);
      }

      // アダプティブアイコン用のXMLファイルを確認
      final anydpiDir =
          Directory(path.join(androidBaseDir.path, 'mipmap-anydpi-v26'));
      expect(anydpiDir.existsSync(), isTrue);

      // XMLファイルが存在することを確認
      final launcherXml = File(path.join(anydpiDir.path, 'ic_launcher.xml'));
      expect(launcherXml.existsSync(), isTrue);

      final roundXml = File(path.join(anydpiDir.path, 'ic_launcher_round.xml'));
      expect(roundXml.existsSync(), isTrue);
    });

    test('Play Store用のアイコンが正しく生成される', () {
      // サンプル画像を読み込む
      final inputFile = File(sampleImagePath);
      final bytes = inputFile.readAsBytesSync();
      final originalImage = img.decodeImage(bytes)!;

      // Android用のアイコンを生成
      AndroidIconGenerator.generateIcons(originalImage);

      final androidBaseDir = Directory('build/android');
      // Play Storeアイコンを確認
      final playStoreDir =
          Directory(path.join(androidBaseDir.path, 'playstore'));
      expect(playStoreDir.existsSync(), isTrue);

      final playStoreIcon =
          File(path.join(playStoreDir.path, 'play_store_icon.png'));
      expect(playStoreIcon.existsSync(), isTrue);

      // Play Storeアイコンの寸法を確認（512x512）
      final playStoreImage = img.decodePng(playStoreIcon.readAsBytesSync());
      expect(playStoreImage!.width, equals(512));
      expect(playStoreImage.height, equals(512));
    });

    test('Round Androidアイコンが生成される', () {
      // サンプル画像を読み込む
      final inputFile = File(sampleImagePath);
      final bytes = inputFile.readAsBytesSync();
      final originalImage = img.decodeImage(bytes)!;

      // Android用のアイコンを生成
      AndroidIconGenerator.generateIcons(originalImage);

      final androidBaseDir = Directory('build/android');
      final densities = ['mdpi', 'hdpi', 'xhdpi', 'xxhdpi', 'xxxhdpi'];

      // ラウンドアイコンを確認
      for (final density in densities) {
        final densityDir =
            Directory(path.join(androidBaseDir.path, 'mipmap-$density'));
        final roundIcon =
            File(path.join(densityDir.path, 'ic_launcher_round.png'));
        expect(roundIcon.existsSync(), isTrue);
      }
    });
  });
}
