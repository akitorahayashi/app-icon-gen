/// 標準的なAndroidアイコンサイズ (px)
const Map<String, int> kTraditionalDensitySizes = {
  'mdpi': 48, // 1.0x
  'hdpi': 72, // 1.5x
  'xhdpi': 96, // 2.0x
  'xxhdpi': 144, // 3.0x
  'xxxhdpi': 192 // 4.0x
};

/// アダプティブアイコンサイズ (px)
const Map<String, int> kAdaptiveSizes = {
  'mdpi': 108, // 1.0x
  'hdpi': 162, // 1.5x
  'xhdpi': 216, // 2.0x
  'xxhdpi': 324, // 3.0x
  'xxxhdpi': 432, // 4.0x
};

/// Play Store用アイコンサイズ (px)
const int kPlayStoreSize = 512;

/// アダプティブアイコンXMLファイル名 (API v26+)
const String kAdaptiveIconXmlName = 'ic_launcher.xml';

/// モノクロアイコンXMLファイル名 (API v33+)
const String kMonochromeIconXmlName = 'ic_launcher_monochrome.xml';

/// アダプティブアイコンXMLテンプレート
const String kAdaptiveIconXmlTemplate = '''
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@mipmap/ic_launcher_background"/>
    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>
</adaptive-icon>
''';

/// モノクロアイコンXMLテンプレート
const String kMonochromeIconXmlTemplate = '''
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@mipmap/ic_launcher_background"/>
    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>
    <monochrome android:drawable="@mipmap/ic_launcher_foreground"/> 
</adaptive-icon>
''';
