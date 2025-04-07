/// アイコンテンプレートの基底クラス
abstract class IconTemplate {
  /// サイズ（ポイント単位）
  final num size;

  /// 倍率（1x, 2x, 3x）
  final int scale;

  /// デバイス区分（iphone, ipad, ios-marketing, universal, watch など）
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

  /// Contents.json用のマップを作成
  Map<String, dynamic> toContentsJsonMap();
}
