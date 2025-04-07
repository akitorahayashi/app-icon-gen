import 'icon_template.dart';

/// watchOS用アイコンテンプレート
class WatchOSIconTemplate extends IconTemplate {
  /// 役割 (appLauncher, companionSettings など)
  final String? role;

  /// サブタイプ (38mm, 42mm など)
  final String? subtype;

  WatchOSIconTemplate({
    required super.size,
    required super.scale,
    required super.idiom,
    required super.filename,
    this.role,
    this.subtype,
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

    // スケールがある場合のみ追加
    if (scale > 0) {
      map['scale'] = '${scale}x';
    }

    // 役割がある場合は追加
    if (role != null) {
      map['role'] = role;
    }

    // サブタイプがある場合は追加
    if (subtype != null) {
      map['subtype'] = subtype;
    }

    return map;
  }
}
