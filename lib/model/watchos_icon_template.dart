/// watchOS用アイコンテンプレート
class WatchOSIconTemplate {
  /// サイズ（ポイント単位）
  final num size;

  /// 倍率（1x, 2x, 3x）
  final int scale;

  /// デバイス区分（watch, watch-marketing など）
  final String idiom;

  /// ファイル名
  final String filename;

  /// 役割 (appLauncher, companionSettings など)
  final String? role;

  /// サブタイプ (38mm, 42mm など)
  final String? subtype;

  const WatchOSIconTemplate({
    required this.size,
    required this.scale,
    required this.idiom,
    required this.filename,
    this.role,
    this.subtype,
  });

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
