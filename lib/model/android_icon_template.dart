import 'icon_template.dart';

/// Android用アイコンテンプレート
class AndroidIconTemplate extends IconTemplate {
  /// アダプティブアイコンのタイプ(foreground, background など)
  final String? type;

  /// 密度 (mdpi, hdpi など)
  final String? density;

  AndroidIconTemplate({
    required super.size,
    required super.scale,
    required super.idiom,
    required super.filename,
    this.type,
    this.density,
  });

  @override
  Map<String, dynamic> toContentsJsonMap() {
    final map = <String, dynamic>{
      'size': '${size}x$size',
      'idiom': idiom,
    };

    // ファイル名がある場合のみ追加
    if (filename.isNotEmpty) {
      map['filename'] = filename;
    }

    // タイプがある場合は追加
    if (type != null) {
      map['type'] = type;
    }

    // 密度がある場合は追加
    if (density != null) {
      map['density'] = density;
    }

    return map;
  }
}
