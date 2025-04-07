import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import '../model/watchos_icon_template.dart';

/// watchOS向けアイコン生成クラス
class WatchOSIconGenerator {
  /// watchOS用のアイコンテンプレートリスト
  static final List<WatchOSIconTemplate> watchOSIconTemplates =
      _createWatchOSIconTemplates();

  /// watchOS用のアイコンを生成
  static void generateIcons(img.Image originalImage) {
    print('watchOS用アイコンを生成中...');

    // 出力ディレクトリ
    final outputDir = Directory('build/watchos/AppIcon.appiconset');
    outputDir.createSync(recursive: true);

    // 各サイズを生成
    final List<Map<String, dynamic>> images = [];

    for (var template in watchOSIconTemplates) {
      final width = (template.size * template.scale).toInt();
      final height = (template.size * template.scale).toInt();

      // 画像をリサイズ
      final resized =
          img.copyResize(originalImage, width: width, height: height);

      // ファイル名
      final filename = template.filename;
      final filePath = path.join(outputDir.path, filename);

      // PNGとして書き出し
      final pngBytes = img.encodePng(resized);
      File(filePath).writeAsBytesSync(pngBytes);

      // Contents.json用のメタデータ
      images.add(template.toContentsJsonMap());

      print('watchOS用アイコン作成: $filename (${width}x$height)');
    }

    // Contents.jsonを生成
    final contents = {
      'images': images,
      'info': {'version': 1, 'author': 'app_icon_gen'}
    };

    // JSON出力
    final contentsFile = File(path.join(outputDir.path, 'Contents.json'));
    contentsFile.writeAsStringSync(jsonEncode(contents), flush: true);

    print('watchOS用アイコンのContents.jsonを生成しました');
    print('watchOS用アイコンの生成が完了しました。');
  }

  /// watchOS用のアイコンテンプレートを作成
  static List<WatchOSIconTemplate> _createWatchOSIconTemplates() {
    return [
      // 通知センター
      WatchOSIconTemplate(
          size: 24,
          scale: 2,
          idiom: 'watch',
          filename: 'AppIcon24x24@2x.png',
          role: 'notificationCenter',
          subtype: '38mm'),
      WatchOSIconTemplate(
          size: 27.5,
          scale: 2,
          idiom: 'watch',
          filename: 'AppIcon27.5x27.5@2x.png',
          role: 'notificationCenter',
          subtype: '42mm'),

      // コンパニオン設定
      WatchOSIconTemplate(
          size: 29,
          scale: 2,
          idiom: 'watch',
          filename: 'AppIcon29x29@2x.png',
          role: 'companionSettings'),
      WatchOSIconTemplate(
          size: 29,
          scale: 3,
          idiom: 'watch',
          filename: 'AppIcon29x29@3x.png',
          role: 'companionSettings'),

      // ホーム画面
      WatchOSIconTemplate(
          size: 40,
          scale: 2,
          idiom: 'watch',
          filename: 'AppIcon40x40@2x.png',
          role: 'appLauncher',
          subtype: '38mm'),
      WatchOSIconTemplate(
          size: 44,
          scale: 2,
          idiom: 'watch',
          filename: 'AppIcon44x44@2x.png',
          role: 'appLauncher',
          subtype: '40mm'),
      WatchOSIconTemplate(
          size: 50,
          scale: 2,
          idiom: 'watch',
          filename: 'AppIcon50x50@2x.png',
          role: 'appLauncher',
          subtype: '44mm'),
      WatchOSIconTemplate(
          size: 51,
          scale: 2,
          idiom: 'watch',
          filename: 'AppIcon51x51@2x.png',
          role: 'appLauncher',
          subtype: '45mm'),
      WatchOSIconTemplate(
          size: 54,
          scale: 2,
          idiom: 'watch',
          filename: 'AppIcon54x54@2x.png',
          role: 'appLauncher',
          subtype: '49mm'),

      // ショートルック
      WatchOSIconTemplate(
          size: 86,
          scale: 2,
          idiom: 'watch',
          filename: 'AppIcon86x86@2x.png',
          role: 'quickLook',
          subtype: '38mm'),
      WatchOSIconTemplate(
          size: 98,
          scale: 2,
          idiom: 'watch',
          filename: 'AppIcon98x98@2x.png',
          role: 'quickLook',
          subtype: '42mm'),
      WatchOSIconTemplate(
          size: 108,
          scale: 2,
          idiom: 'watch',
          filename: 'AppIcon108x108@2x.png',
          role: 'quickLook',
          subtype: '44mm'),
      WatchOSIconTemplate(
          size: 117,
          scale: 2,
          idiom: 'watch',
          filename: 'AppIcon117x117@2x.png',
          role: 'quickLook',
          subtype: '45mm'),
      WatchOSIconTemplate(
          size: 129,
          scale: 2,
          idiom: 'watch',
          filename: 'AppIcon129x129@2x.png',
          role: 'quickLook',
          subtype: '49mm'),

      // App Store
      WatchOSIconTemplate(
          size: 1024,
          scale: 1,
          idiom: 'watch-marketing',
          filename: 'AppIcon1024x1024@1x.png'),
    ];
  }
}
