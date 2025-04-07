import 'icon_template.dart';

/// iOS用アイコンテンプレート
class IOSIconTemplate extends IconTemplate {
  /// プラットフォーム (ios など)
  final String? platform;

  /// アピアランス (luminosity:dark など)
  final Map<String, String>? appearance;

  IOSIconTemplate({
    required super.size,
    required super.scale,
    required super.idiom,
    required super.filename,
    this.platform,
    this.appearance,
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
