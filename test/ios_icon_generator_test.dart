import 'dart:io';

import 'package:app_icon_gen/app_icon_generator.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  group('iOS Icon Generator Tests', () {
    // サンプル画像のパス
    final String sampleImagePath = 'assets/icon_gen_sample.png';

    tearDownAll(() {
      // 生成された出力ディレクトリを削除
      final iosOutputDir = Directory('build/ios');
      if (iosOutputDir.existsSync()) {
        iosOutputDir.deleteSync(recursive: true);
      }
    });

    test('iOS用アイコンが正しく生成される', () {
      // iOS用のアイコンを生成
      AppIconGenerator.generateIcons(sampleImagePath, 'ios');

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

      // App Store用アイコンを確認
      final appStoreIcon = iconFiles.firstWhere(
          (file) => path.basename(file.path) == 'ItunesArtwork@2x.png',
          orElse: () => throw Exception('App Store用アイコンファイルが見つかりません'));

      // App Store用アイコンの寸法を確認（1024x1024）
      final appStoreImage = img.decodePng(appStoreIcon.readAsBytesSync());
      expect(appStoreImage!.width, equals(1024));
      expect(appStoreImage.height, equals(1024));
    });

    test('iOS 17以降に対応するアイコンが生成される', () {
      // iOS用のアイコンを生成
      AppIconGenerator.generateIcons(sampleImagePath, 'ios');

      final iosOutputDir = Directory('build/ios/AppIcon.appiconset');

      // 標準アイコンの確認
      final standardIcon =
          File(path.join(iosOutputDir.path, 'Icon-App-60x60@3x.png'));
      expect(standardIcon.existsSync(), isTrue);

      // ダークモードアイコンの確認 (存在する場合)
      final darkModeIcon =
          File(path.join(iosOutputDir.path, 'Icon-App-60x60@3x-dark.png'));
      if (darkModeIcon.existsSync()) {
        final darkImage = img.decodePng(darkModeIcon.readAsBytesSync());
        expect(darkImage!.width, equals(180)); // 60pt x 3x = 180px
      }

      // ティント付きアイコンの確認 (存在する場合)
      final tintedIcon =
          File(path.join(iosOutputDir.path, 'Icon-App-60x60@3x-tinted.png'));
      if (tintedIcon.existsSync()) {
        final tintedImage = img.decodePng(tintedIcon.readAsBytesSync());
        expect(tintedImage!.width, equals(180)); // 60pt x 3x = 180px
      }
    });

    test('シェルスクリプトで実行した場合もiOS用アイコンが生成される', () {
      // 既存のビルドディレクトリをクリア
      final iosOutputDir = Directory('build/ios');
      if (iosOutputDir.existsSync()) {
        iosOutputDir.deleteSync(recursive: true);
      }

      // シェルスクリプトを実行
      final result = Process.runSync(
        './app-icon-gen.sh',
        ['-p', 'ios', sampleImagePath],
      );

      expect(result.exitCode, equals(0), reason: '${result.stderr}');
      expect(iosOutputDir.existsSync(), isTrue, reason: 'iOSビルドディレクトリが見つかりません');

      // Contents.jsonが生成されたことを確認
      final contentsFile = File(
          path.join(iosOutputDir.path, 'AppIcon.appiconset', 'Contents.json'));
      expect(contentsFile.existsSync(), isTrue);
    });
  });
}
