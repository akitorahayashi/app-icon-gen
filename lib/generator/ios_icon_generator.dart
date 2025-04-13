import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import '../content/ios_icon_content.dart';

/// iOS向けアイコン生成クラス
class IOSIconGenerator {
  /// iOS用のアイコンを生成
  static void generateIcons(img.Image originalImage) {
    print('iOS用アイコンを生成中...');

    // 出力ディレクトリ
    final outputDir = Directory('output/ios/AppIcon.appiconset');
    outputDir.createSync(recursive: true);

    // 各サイズを生成
    final List<Map<String, dynamic>> images = [];

    // 旧式のアイコンも生成（互換性のため）
    for (var template in kIosTraditionalIconTemplates) {
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
    for (var template in kIosModernIconTemplates) {
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
}
