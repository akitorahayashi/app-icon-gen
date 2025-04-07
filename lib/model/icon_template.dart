/// アイコンテンプレートのモデルクラス
class IconTemplate {
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

  /// コンストラクタ
  IconTemplate({
    required this.size,
    required this.scale,
    required this.idiom,
    required this.filename,
    this.platform,
    this.appearance,
  });

  /// マップからIconTemplateオブジェクトを作成
  factory IconTemplate.fromMap(Map<String, dynamic> map) {
    return IconTemplate(
      size: map['size'] as num,
      scale: map['scale'] as int,
      idiom: map['idiom'] as String,
      filename: map['filename'] as String,
      platform: map['platform'] as String?,
      appearance: map['appearance'] != null
          ? Map<String, String>.from(map['appearance'] as Map<dynamic, dynamic>)
          : null,
    );
  }

  /// IconTemplateオブジェクトをマップに変換
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'size': size,
      'scale': scale,
      'idiom': idiom,
      'filename': filename,
    };

    if (platform != null) {
      map['platform'] = platform;
    }

    if (appearance != null) {
      map['appearance'] = appearance;
    }

    return map;
  }

  /// Contents.json用のマップを作成
  Map<String, dynamic> toContentsJsonMap() {
    final map = <String, dynamic>{
      'size': '${size}x$size',
      'idiom': idiom,
    };

    // ファイル名がある場合のみ追加（新しいフォーマットではない場合がある）
    if (filename.isNotEmpty) {
      map['filename'] = filename;
    }

    // スケールがある場合のみ追加（新しいフォーマットでは不要な場合がある）
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
