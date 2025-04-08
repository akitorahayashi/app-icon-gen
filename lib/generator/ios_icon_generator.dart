import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import '../model/ios_icon_template.dart';

/// iOS向けアイコン生成クラス
class IOSIconGenerator {
  /// iPhoneとiPad用のアイコンテンプレートリスト
  static final List<IOSIconTemplate> iosIconTemplates =
      _createIosIconTemplates();

  /// 最新のiOS用アイコンテンプレート（universal）
  static final List<IOSIconTemplate> modernIosIconTemplates =
      _createModernIosIconTemplates();

  /// iOS用のアイコンを生成
  static void generateIcons(img.Image originalImage) {
    print('iOS用アイコンを生成中...');

    // 出力ディレクトリ
    final outputDir = Directory('output/ios/AppIcon.appiconset');
    outputDir.createSync(recursive: true);

    // 各サイズを生成
    final List<Map<String, dynamic>> images = [];

    // 旧式のアイコンも生成（互換性のため）
    for (var template in iosIconTemplates) {
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

      print('iOS用アイコン作成: $filename (${width}x$height)');
    }

    // 最新の形式のアイコンを生成
    for (var template in modernIosIconTemplates) {
      final width = (template.size).toInt();
      final height = (template.size).toInt();

      // 画像をリサイズ
      final resized =
          img.copyResize(originalImage, width: width, height: height);

      // ファイル名（appearance付きの場合はファイル名を変更）
      String filename = '';
      if (template.appearance != null) {
        final appearanceValue = template.appearance!['value'] ?? 'unknown';
        filename = 'AppIcon-$width' 'x' '$height-$appearanceValue.png';
      } else {
        filename = 'AppIcon-$width' 'x' '$height.png';
      }

      final filePath = path.join(outputDir.path, filename);

      // PNGとして書き出し
      final pngBytes = img.encodePng(resized);
      File(filePath).writeAsBytesSync(pngBytes);

      // Contents.json用のマップを作成
      final Map<String, dynamic> imageMap = template.toContentsJsonMap();
      if (filename.isNotEmpty) {
        imageMap['filename'] = filename;
      }
      images.add(imageMap);

      print('iOS用最新形式アイコン作成: $filename ($width' 'x' '$height)');
    }

    // Contents.jsonを生成
    final contents = {
      'images': images,
      'info': {'version': 1, 'author': 'app_icon_gen'}
    };

    // JSON出力
    final contentsFile = File(path.join(outputDir.path, 'Contents.json'));
    contentsFile.writeAsStringSync(jsonEncode(contents), flush: true);

    print('iOS用アイコンのContents.jsonを生成しました');
    print('iOS用アイコンの生成が完了しました。');
  }

  /// iOS用の従来のアイコンテンプレートを作成
  static List<IOSIconTemplate> _createIosIconTemplates() {
    return [
      // iPhone用アイコン
      IOSIconTemplate(
          size: 20,
          scale: 1,
          idiom: 'iphone',
          filename: 'Icon-App-20x20@1x.png'),
      IOSIconTemplate(
          size: 20,
          scale: 2,
          idiom: 'iphone',
          filename: 'Icon-App-20x20@2x.png'),
      IOSIconTemplate(
          size: 20,
          scale: 3,
          idiom: 'iphone',
          filename: 'Icon-App-20x20@3x.png'),
      IOSIconTemplate(
          size: 29,
          scale: 1,
          idiom: 'iphone',
          filename: 'Icon-App-29x29@1x.png'),
      IOSIconTemplate(
          size: 29,
          scale: 2,
          idiom: 'iphone',
          filename: 'Icon-App-29x29@2x.png'),
      IOSIconTemplate(
          size: 29,
          scale: 3,
          idiom: 'iphone',
          filename: 'Icon-App-29x29@3x.png'),
      IOSIconTemplate(
          size: 40,
          scale: 2,
          idiom: 'iphone',
          filename: 'Icon-App-40x40@2x.png'),
      IOSIconTemplate(
          size: 40,
          scale: 3,
          idiom: 'iphone',
          filename: 'Icon-App-40x40@3x.png'),
      IOSIconTemplate(
          size: 60,
          scale: 2,
          idiom: 'iphone',
          filename: 'Icon-App-60x60@2x.png'),
      IOSIconTemplate(
          size: 60,
          scale: 3,
          idiom: 'iphone',
          filename: 'Icon-App-60x60@3x.png'),

      // iPad用アイコン
      IOSIconTemplate(
          size: 20, scale: 1, idiom: 'ipad', filename: 'Icon-App-20x20@1x.png'),
      IOSIconTemplate(
          size: 20, scale: 2, idiom: 'ipad', filename: 'Icon-App-20x20@2x.png'),
      IOSIconTemplate(
          size: 29, scale: 1, idiom: 'ipad', filename: 'Icon-App-29x29@1x.png'),
      IOSIconTemplate(
          size: 29, scale: 2, idiom: 'ipad', filename: 'Icon-App-29x29@2x.png'),
      IOSIconTemplate(
          size: 40, scale: 1, idiom: 'ipad', filename: 'Icon-App-40x40@1x.png'),
      IOSIconTemplate(
          size: 40, scale: 2, idiom: 'ipad', filename: 'Icon-App-40x40@2x.png'),
      IOSIconTemplate(
          size: 76, scale: 1, idiom: 'ipad', filename: 'Icon-App-76x76@1x.png'),
      IOSIconTemplate(
          size: 76, scale: 2, idiom: 'ipad', filename: 'Icon-App-76x76@2x.png'),
      IOSIconTemplate(
          size: 83.5,
          scale: 2,
          idiom: 'ipad',
          filename: 'Icon-App-83.5x83.5@2x.png'),

      // App Store用
      IOSIconTemplate(
          size: 1024,
          scale: 1,
          idiom: 'ios-marketing',
          filename: 'Icon-App-1024x1024@1x.png'),
    ];
  }

  /// 最新のiOS用アイコンテンプレートを作成
  static List<IOSIconTemplate> _createModernIosIconTemplates() {
    return [
      // 標準アイコン
      IOSIconTemplate(
        size: 1024,
        scale: 0, // スケール不要
        idiom: 'universal',
        filename: '',
        platform: 'ios',
      ),

      // ダークモードアイコン
      IOSIconTemplate(
        size: 1024,
        scale: 0, // スケール不要
        idiom: 'universal',
        filename: '',
        platform: 'ios',
        appearance: {
          'type': 'luminosity',
          'value': 'dark',
        },
      ),

      // ティント付きアイコン
      IOSIconTemplate(
        size: 1024,
        scale: 0, // スケール不要
        idiom: 'universal',
        filename: '',
        platform: 'ios',
        appearance: {
          'type': 'luminosity',
          'value': 'tinted',
        },
      ),
    ];
  }
}
