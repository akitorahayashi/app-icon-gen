import '../model/ios_icon_template.dart';

/// iOS用の従来のアイコンテンプレートリスト
const List<IOSIconTemplate> kIosTraditionalIconTemplates = [
  // iPhone用アイコン
  IOSIconTemplate(
      size: 20, scale: 2, idiom: 'iphone', filename: 'Icon-App-20x20@2x.png'),
  IOSIconTemplate(
      size: 20, scale: 3, idiom: 'iphone', filename: 'Icon-App-20x20@3x.png'),
  IOSIconTemplate(
      size: 29, scale: 1, idiom: 'iphone', filename: 'Icon-App-29x29@1x.png'),
  IOSIconTemplate(
      size: 29, scale: 2, idiom: 'iphone', filename: 'Icon-App-29x29@2x.png'),
  IOSIconTemplate(
      size: 29, scale: 3, idiom: 'iphone', filename: 'Icon-App-29x29@3x.png'),
  IOSIconTemplate(
      size: 40, scale: 2, idiom: 'iphone', filename: 'Icon-App-40x40@2x.png'),
  IOSIconTemplate(
      size: 40, scale: 3, idiom: 'iphone', filename: 'Icon-App-40x40@3x.png'),
  IOSIconTemplate(
      size: 60, scale: 2, idiom: 'iphone', filename: 'Icon-App-60x60@2x.png'),
  IOSIconTemplate(
      size: 60, scale: 3, idiom: 'iphone', filename: 'Icon-App-60x60@3x.png'),

  // iPad用アイコン
  IOSIconTemplate(
      size: 20, scale: 1, idiom: 'ipad', filename: 'Icon-App-20x20@1x.png'),
  IOSIconTemplate(
      size: 20, scale: 2, idiom: 'ipad', filename: 'Icon-App-20x20@2x.png'),
  IOSIconTemplate(
      size: 29, scale: 1, idiom: 'ipad', filename: 'Icon-App-29x29@1x.png'),
  IOSIconTemplate(
      size: 29, scale: 2, idiom: 'ipad', filename: 'Icon-App-29x29@2x.png'),
  IOSIconTemplate(
      size: 40, scale: 1, idiom: 'ipad', filename: 'Icon-App-40x40@1x.png'),
  IOSIconTemplate(
      size: 40, scale: 2, idiom: 'ipad', filename: 'Icon-App-40x40@2x.png'),
  IOSIconTemplate(
      size: 76, scale: 1, idiom: 'ipad', filename: 'Icon-App-76x76@1x.png'),
  IOSIconTemplate(
      size: 76, scale: 2, idiom: 'ipad', filename: 'Icon-App-76x76@2x.png'),
  IOSIconTemplate(
      size: 83.5,
      scale: 2,
      idiom: 'ipad',
      filename: 'Icon-App-83.5x83.5@2x.png'),

  // App Store用
  IOSIconTemplate(
      size: 1024,
      scale: 1,
      idiom: 'ios-marketing',
      filename: 'Icon-App-1024x1024@1x.png'),
];

/// 最新のiOS用アイコンテンプレートリスト
const List<IOSIconTemplate> kIosModernIconTemplates = [
  // 標準アイコン
  IOSIconTemplate(
    size: 1024,
    scale: 0, // スケール不要
    idiom: 'universal',
    filename: '',
    platform: 'ios',
  ),
  // ダークモードアイコン
  IOSIconTemplate(
    size: 1024,
    scale: 0, // スケール不要
    idiom: 'universal',
    filename: '',
    platform: 'ios',
    appearance: {
      'type': 'luminosity',
      'value': 'dark',
    },
  ),
  // ティント付きアイコン
  IOSIconTemplate(
    size: 1024,
    scale: 0, // スケール不要
    idiom: 'universal',
    filename: '',
    platform: 'ios',
    appearance: {
      'type': 'luminosity',
      'value': 'tinted',
    },
  ),
];
