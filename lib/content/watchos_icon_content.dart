import '../model/watchos_icon_template.dart';

/// watchOS用のアイコンテンプレートリスト
const List<WatchOSIconTemplate> kWatchOSIconTemplates = [
  // 通知センター
  WatchOSIconTemplate(
      size: 24,
      scale: 2,
      idiom: 'watch',
      filename: 'AppIcon24x24@2x.png',
      role: 'notificationCenter',
      subtype: '38mm'),
  WatchOSIconTemplate(
      size: 27.5,
      scale: 2,
      idiom: 'watch',
      filename: 'AppIcon27.5x27.5@2x.png',
      role: 'notificationCenter',
      subtype: '42mm'),
  WatchOSIconTemplate(
      size: 33,
      scale: 2,
      idiom: 'watch',
      filename: 'AppIcon33x33@2x.png',
      role: 'notificationCenter',
      subtype: '45mm'),

  // 設定
  WatchOSIconTemplate(
      size: 29,
      scale: 2,
      idiom: 'watch',
      filename: 'AppIcon29x29@2x.png',
      role: 'companionSettings'),
  WatchOSIconTemplate(
      size: 29,
      scale: 3,
      idiom: 'watch',
      filename: 'AppIcon29x29@3x.png',
      role: 'companionSettings'),

  // ホーム画面
  WatchOSIconTemplate(
      size: 40,
      scale: 2,
      idiom: 'watch',
      filename: 'AppIcon40x40@2x.png',
      role: 'appLauncher',
      subtype: '38mm'),
  WatchOSIconTemplate(
      size: 44,
      scale: 2,
      idiom: 'watch',
      filename: 'AppIcon44x44@2x.png',
      role: 'appLauncher',
      subtype: '40mm'),
  WatchOSIconTemplate(
      size: 46,
      scale: 2,
      idiom: 'watch',
      filename: 'AppIcon46x46@2x.png',
      role: 'appLauncher',
      subtype: '41mm'),
  WatchOSIconTemplate(
      size: 50,
      scale: 2,
      idiom: 'watch',
      filename: 'AppIcon50x50@2x.png',
      role: 'appLauncher',
      subtype: '44mm'),
  WatchOSIconTemplate(
      size: 51,
      scale: 2,
      idiom: 'watch',
      filename: 'AppIcon51x51@2x.png',
      role: 'appLauncher',
      subtype: '45mm'),
  WatchOSIconTemplate(
      size: 54,
      scale: 2,
      idiom: 'watch',
      filename: 'AppIcon54x54@2x.png',
      role: 'appLauncher',
      subtype: '49mm'),

  // ショートルック
  WatchOSIconTemplate(
      size: 86,
      scale: 2,
      idiom: 'watch',
      filename: 'AppIcon86x86@2x.png',
      role: 'quickLook',
      subtype: '38mm'),
  WatchOSIconTemplate(
      size: 98,
      scale: 2,
      idiom: 'watch',
      filename: 'AppIcon98x98@2x.png',
      role: 'quickLook',
      subtype: '42mm'),
  WatchOSIconTemplate(
      size: 108,
      scale: 2,
      idiom: 'watch',
      filename: 'AppIcon108x108@2x.png',
      role: 'quickLook',
      subtype: '44mm'),
  WatchOSIconTemplate(
      size: 117,
      scale: 2,
      idiom: 'watch',
      filename: 'AppIcon117x117@2x.png',
      role: 'quickLook',
      subtype: '45mm'),
  WatchOSIconTemplate(
      size: 129,
      scale: 2,
      idiom: 'watch',
      filename: 'AppIcon129x129@2x.png',
      role: 'quickLook',
      subtype: '49mm'),

  // App Store
  WatchOSIconTemplate(
      size: 1024,
      scale: 1,
      idiom: 'watch-marketing',
      filename: 'AppIcon1024x1024@1x.png'),
];
