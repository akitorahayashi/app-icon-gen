/// アイコンテンプレートのモデルクラス
class IconTemplate {
  /// サイズ（ポイント単位）
  final num size;

  /// 倍率（1x, 2x, 3x）
  final int scale;

  /// デバイス区分（iphone, ipad, ios-marketing など）
  final String idiom;

  /// ファイル名
  final String filename;

  /// コンストラクタ
  IconTemplate({
    required this.size,
    required this.scale,
    required this.idiom,
    required this.filename,
  });

  /// マップからIconTemplateオブジェクトを作成
  factory IconTemplate.fromMap(Map<String, dynamic> map) {
    return IconTemplate(
      size: map['size'] as num,
      scale: map['scale'] as int,
      idiom: map['idiom'] as String,
      filename: map['filename'] as String,
    );
  }

  /// IconTemplateオブジェクトをマップに変換
  Map<String, dynamic> toMap() {
    return {
      'size': size,
      'scale': scale,
      'idiom': idiom,
      'filename': filename,
    };
  }

  /// Contents.json用のマップを作成
  Map<String, dynamic> toContentsJsonMap() {
    return {
      'size': '${size}x$size',
      'idiom': idiom,
      'filename': filename,
      'scale': '${scale}x',
    };
  }
}
