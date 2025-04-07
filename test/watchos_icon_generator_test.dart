import 'dart:io';

import 'package:app_icon_gen/app_icon_generator.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  group('watchOS Icon Generator Tests', () {
    // サンプル画像のパス
    final String sampleImagePath = 'assets/icon_gen_sample.png';

    tearDownAll(() {
      // 生成された出力ディレクトリを削除
      final watchosOutputDir = Directory('build/watchos');
      if (watchosOutputDir.existsSync()) {
        watchosOutputDir.deleteSync(recursive: true);
      }
    });

    test('watchOS用アイコンが正しく生成される', () {
      // watchOS用のアイコンを生成
      AppIconGenerator.generateIcons(sampleImagePath, 'watchos');

      final watchosOutputDir = Directory('build/watchos/AppIcon.appiconset');
      expect(watchosOutputDir.existsSync(), isTrue);

      // Contents.jsonが生成されたことを確認
      final contentsFile =
          File(path.join(watchosOutputDir.path, 'Contents.json'));
      expect(contentsFile.existsSync(), isTrue);

      // 生成されたPNGファイルをカウント
      final iconFiles = watchosOutputDir
          .listSync()
          .whereType<File>()
          .where((file) => path.extension(file.path) == '.png')
          .toList();

      // 複数のアイコンファイルが存在するはず
      expect(iconFiles.length, greaterThanOrEqualTo(10));

      // 特定のアイコンを確認（通知センター用38mm）
      final notificationIcon = iconFiles.firstWhere(
          (file) => path.basename(file.path) == 'AppIcon24x24@2x.png',
          orElse: () => throw Exception('期待されるwatchOSアイコンファイルが見つかりません'));

      // 寸法を確認 (24pt x 2x = 48px)
      final notificationImage =
          img.decodePng(notificationIcon.readAsBytesSync());
      expect(notificationImage!.width, equals(48));
      expect(notificationImage.height, equals(48));
    });

    test('コンパニオン設定用のアイコンが生成される', () {
      // watchOS用のアイコンを生成
      AppIconGenerator.generateIcons(sampleImagePath, 'watchos');

      final watchosOutputDir = Directory('build/watchos/AppIcon.appiconset');

      // 29pt@2xのコンパニオン設定アイコンを確認
      final companionIcon =
          File(path.join(watchosOutputDir.path, 'AppIcon29x29@2x.png'));
      expect(companionIcon.existsSync(), isTrue);

      // 29pt@3xのコンパニオン設定アイコンを確認
      final companionIcon3x =
          File(path.join(watchosOutputDir.path, 'AppIcon29x29@3x.png'));
      expect(companionIcon3x.existsSync(), isTrue);

      // アイコンのサイズを確認（29pt x 2x = 58px）
      final companionImage = img.decodePng(companionIcon.readAsBytesSync());
      expect(companionImage!.width, equals(58));
      expect(companionImage.height, equals(58));
    });

    test('App Store用アイコンが生成される', () {
      // watchOS用のアイコンを生成
      AppIconGenerator.generateIcons(sampleImagePath, 'watchos');

      final watchosOutputDir = Directory('build/watchos/AppIcon.appiconset');

      // App Store用アイコンを確認
      final appStoreIcon =
          File(path.join(watchosOutputDir.path, 'AppIcon1024x1024@1x.png'));
      expect(appStoreIcon.existsSync(), isTrue);

      // アイコンのサイズを確認
      final appStoreImage = img.decodePng(appStoreIcon.readAsBytesSync());
      expect(appStoreImage!.width, equals(1024));
      expect(appStoreImage.height, equals(1024));
    });

    test('シェルスクリプトで実行した場合もwatchOS用アイコンが生成される', () {
      // 既存のビルドディレクトリをクリア
      final watchosOutputDir = Directory('build/watchos');
      if (watchosOutputDir.existsSync()) {
        watchosOutputDir.deleteSync(recursive: true);
      }

      // シェルスクリプトを実行
      final result = Process.runSync(
        './app-icon-gen.sh',
        ['-p', 'watchos', sampleImagePath],
      );

      expect(result.exitCode, equals(0), reason: '${result.stderr}');
      expect(watchosOutputDir.existsSync(), isTrue,
          reason: 'watchOSビルドディレクトリが見つかりません');

      // Contents.jsonが生成されたことを確認
      final contentsFile = File(path.join(
          watchosOutputDir.path, 'AppIcon.appiconset', 'Contents.json'));
      expect(contentsFile.existsSync(), isTrue);
    });
  });
}
