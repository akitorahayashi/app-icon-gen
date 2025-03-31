import 'dart:io';

import 'package:app_icon_gen/app_icon_generator.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  group('Icon Generator Tests', () {
    late Directory tempDir;
    late String testImagePath;

    setUpAll(() {
      // 一時ディレクトリとテスト画像を作成
      tempDir = Directory.systemTemp.createTempSync('icon_gen_test_');
      testImagePath = _createTestImage(tempDir);
    });

    tearDownAll(() {
      // クリーンアップ
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }

      // 生成された出力ディレクトリを削除
      final iosOutputDir = Directory('build/ios');
      if (iosOutputDir.existsSync()) {
        iosOutputDir.deleteSync(recursive: true);
      }

      final androidOutputDir = Directory('build/android');
      if (androidOutputDir.existsSync()) {
        androidOutputDir.deleteSync(recursive: true);
      }
    });

    test('プラットフォームがiosの場合、iOSアイコンが生成されるべき', () {
      // iOS用のアイコンを生成
      AppIconGenerator.generateIcons(testImagePath, 'ios');

      final iosOutputDir = Directory('build/ios/AppIcon.appiconset');
      expect(iosOutputDir.existsSync(), isTrue);

      // Contents.jsonが生成されたことを確認
      final contentsFile = File(path.join(iosOutputDir.path, 'Contents.json'));
      expect(contentsFile.existsSync(), isTrue);

      // 生成されたPNGファイルをカウント
      final iconFiles = iosOutputDir
          .listSync()
          .whereType<File>()
          .where((file) => path.extension(file.path) == '.png')
          .toList();

      // 複数のアイコンファイルが存在するはず
      expect(iconFiles.length, greaterThanOrEqualTo(10));

      // 特定のサイズを確認: 60pt@2x (120x120ピクセル)
      final icon60x60 = iconFiles.firstWhere(
          (file) => path.basename(file.path) == 'Icon-App-60x60@2x.png',
          orElse: () => throw Exception('期待されるiOSアイコンファイルが見つかりません'));

      // 寸法を確認
      final icon60Image = img.decodePng(icon60x60.readAsBytesSync());
      expect(icon60Image!.width, equals(120)); // 60pt x 2x = 120px
      expect(icon60Image.height, equals(120));
    });

    test('プラットフォームがandroidの場合、Androidアイコンが生成されるべき', () {
      // Android用のアイコンを生成
      AppIconGenerator.generateIcons(testImagePath, 'android');

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

    test('プラットフォームがbothの場合、iOSとAndroid両方のアイコンが生成されるべき', () {
      // 両プラットフォーム用のアイコンを生成
      AppIconGenerator.generateIcons(testImagePath, 'both');

      // iOS出力を確認
      final iosOutputDir = Directory('build/ios/AppIcon.appiconset');
      expect(iosOutputDir.existsSync(), isTrue);

      // Android出力を確認
      final androidBaseDir = Directory('build/android');
      expect(androidBaseDir.existsSync(), isTrue);
    });

    test('存在しないファイルに対して例外が throw されるべき', () {
      // 存在しないファイルでアイコン生成を試みる
      expect(
          () => AppIconGenerator.generateIcons('non_existent_file.png', 'both'),
          throwsA(isA<Exception>().having(
              (e) => e.toString(), 'message', contains('入力ファイルが見つかりません'))));
    });
  });
}

/// テスト画像を作成してそのファイルパスを返す
String _createTestImage(Directory tempDir) {
  // テスト用に512x512の画像を作成
  final image = img.Image(width: 512, height: 512);

  // カラーグラデーションで塗りつぶす
  for (var y = 0; y < image.height; y++) {
    for (var x = 0; x < image.width; x++) {
      final r = (x * 255 ~/ image.width).clamp(0, 255);
      final g = (y * 255 ~/ image.height).clamp(0, 255);
      final b = 128;
      image.setPixel(x, y, img.ColorRgb8(r, g, b));
    }
  }

  // 中央に白い円を追加
  img.fillCircle(image,
      x: image.width ~/ 2,
      y: image.height ~/ 2,
      radius: image.width ~/ 4,
      color: img.ColorRgb8(255, 255, 255));

  // 画像を保存
  final outputPath = path.join(tempDir.path, 'test_icon.png');
  File(outputPath).writeAsBytesSync(img.encodePng(image));

  return outputPath;
}
