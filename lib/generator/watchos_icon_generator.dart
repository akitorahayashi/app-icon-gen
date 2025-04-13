import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import '../model/watchos_icon_template.dart';
import '../content/watchos_icon_content.dart';

/// watchOS向けアイコン生成クラス
class WatchOSIconGenerator {
  /// watchOS用のアイコンを生成
  static void generateIcons(img.Image originalImage) {
    print('watchOS用アイコンを生成中...');

    // 出力ディレクトリ
    final outputDir = Directory('output/watchos/AppIcon.appiconset');
    outputDir.createSync(recursive: true);

    // 各サイズを生成
    final List<Map<String, dynamic>> images = [];

    for (var template in kWatchOSIconTemplates) {
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
}
