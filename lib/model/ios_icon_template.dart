/// iOS用アイコンテンプレート
class IOSIconTemplate {
  /// サイズ（ポイント単位）
  final num size;

  /// 倍率（1x, 2x, 3x）
  final int scale;

  /// デバイス区分（iphone, ipad, ios-marketing, universal など）
  final String idiom;

  /// ファイル名
  final String filename;

  /// プラットフォーム (ios など)
  final String? platform;

  /// アピアランス (luminosity:dark など)
  final Map<String, String>? appearance;

  IOSIconTemplate({
    required this.size,
    required this.scale,
    required this.idiom,
    required this.filename,
    this.platform,
    this.appearance,
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

    // プラットフォームがある場合は追加
    if (platform != null) {
      map['platform'] = platform;
    }

    // アピアランスがある場合は追加
    if (appearance != null && appearance!.isNotEmpty) {
      map['appearances'] = [
        {
          'appearance': appearance!['type'] ?? 'luminosity',
          'value': appearance!['value'] ?? 'dark'
        }
      ];
    }

    return map;
  }
}
