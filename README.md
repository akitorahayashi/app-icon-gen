# App Icon Generator

## Features

### iOS
- 最新のiOS 17/Xcode 15形式に対応
  - Universal アイコン (1024x1024)
  - ダークモード対応アイコン (1024x1024)
  - Tinted モード対応アイコン (1024x1024)
- 従来の形式 (iOS 16以下の互換性)
  - iPhone Icons
    - Notification icons (20pt @1x, @2x, @3x)
    - Settings icons (29pt @1x, @2x, @3x)
    - Spotlight icons (40pt @2x, @3x)
    - App icons (60pt @2x, @3x)
  - iPad Icons
    - Notification icons (20pt @1x, @2x)
    - Settings icons (29pt @1x, @2x)
    - Spotlight icons (40pt @1x, @2x)
    - App icons (76pt @1x, @2x)
    - iPad Pro icons (83.5pt @2x)
  - App Store icon (1024x1024)
- Automatic Contents.json generation

### Android
- Traditional icons (all densities)
  - mdpi (48x48)
  - hdpi (72x72)
  - xhdpi (96x96)
  - xxhdpi (144x144)
  - xxxhdpi (192x192)
- Adaptive icons (Android 8.0+)
  - Foreground layer (ic_launcher_foreground.png)
  - Background layer (ic_launcher_background.png)
  - Required XML resources
- Play Store icon (512x512)

### watchOS
- App icons for all Apple Watch models
  - 38mm watch (24pt, 86pt)
  - 40mm watch (44pt)
  - 42mm watch (27.5pt, 98pt)
  - 44mm watch (50pt, 108pt)
  - 45mm watch (51pt, 117pt)
  - 49mm watch (54pt, 129pt)
- Companion settings icons (29pt @2x, @3x)
- App Store icon (1024x1024)
- Automatic Contents.json generation

## Directory Structure
```
app-icon-gen.sh             # 実行用のシェルスクリプト

lib/
├── app_icon_generator.dart  
├── command_line_runner.dart                 
├── model/                   
│   ├── ios_icon_template.dart    # iOS用テンプレート
│   └── watchos_icon_template.dart # watchOS用テンプレート
└── platform/               
    ├── android_icon_generator.dart  
    ├── ios_icon_generator.dart      
    └── watchos_icon_generator.dart  

bin/
└── app_icon_gen.dart       

test/
├── android_icon_generator_test.dart
├── ios_icon_generator_test.dart
└── watchos_icon_generator_test.dart

assets/
└── icon_gen_sample.png     
```

## Installation

### Prerequisites

- Dart SDK (2.17.0以上)

### Clone Repository

```bash
$ git clone https://github.com/akitorahayashi/app_icon_gen.git
$ cd app_icon_gen
$ dart pub get
$ chmod +x app-icon-gen.sh  # 実行権限を付与
```

## Preparing Your Icon

1. アプリアイコン用の正方形のPNG画像を作成または入手（1024x1024ピクセル）
2. プロジェクト内の `assets` ディレクトリに画像を配置

## Usage

プラットフォームの指定が必須です

```bash
$ ./app-icon-gen.sh -p <platform> assets/your_icon.png
```

### Examples

**iOSアイコンを生成**
```bash
$ ./app-icon-gen.sh -p ios assets/your_icon.png
```

**watchOSアイコンを生成**
```bash
$ ./app-icon-gen.sh -p watchos assets/your_icon.png
```

**Androidアイコンを生成**
```bash
$ ./app-icon-gen.sh -p android assets/your_icon.png
```

生成されたすべてのアイコンは、プロジェクトの `build/` ディレクトリに保存されます。

#### iOS 17のダークモードとTintedモード対応

デフォルトでは、すべてのモード（ライト/ダーク/Tinted）に同じアイコン画像が使用されますが、最適な表示のためには、各モード専用のアイコンを用意することをお勧めします：

- **ダークモード用アイコン**: 暗い背景に映えるようにデザインされたアイコン（自動生成されたものを `AppIcon-1024x1024-dark.png` と交換）
- **Tintedモード用アイコン**: システムのアクセントカラーが効果的に適用できるモノクロや単色ベースのデザイン（自動生成されたものを `AppIcon-1024x1024-tinted.png` と交換）

各モード用のアイコンを用意したら、生成後に `build/ios/AppIcon.appiconset/` ディレクトリ内の対応するファイルを置き換えてください。

### iOS

```
build/ios/AppIcon.appiconset/
├── Contents.json
├── Icon-App-20x20@1x.png
├── Icon-App-20x20@2x.png
├── Icon-App-20x20@3x.png
├── ... (その他のサイズ)
├── Icon-App-1024x1024@1x.png
├── AppIcon-1024x1024.png      
├── AppIcon-1024x1024-dark.png 
└── AppIcon-1024x1024-tinted.png 
```

### Android

```
build/android/
├── mipmap-mdpi/
│   ├── ic_launcher.png
│   ├── ic_launcher_background.png
│   └── ic_launcher_foreground.png
├── mipmap-hdpi/
│   └── ... (同様のファイル)
├── ... (その他の解像度)
├── mipmap-anydpi-v26/
│   ├── ic_launcher.xml
│   └── ic_launcher_round.xml
├── values/
│   └── colors.xml
└── playstore/
    └── play_store_icon.png
```

### watchOS

```
build/watchos/AppIcon.appiconset/
├── Contents.json
├── AppIcon24x24@2x.png
├── AppIcon27.5x27.5@2x.png
├── AppIcon29x29@2x.png
├── AppIcon29x29@3x.png
├── AppIcon40x40@2x.png
├── AppIcon44x44@2x.png
├── AppIcon50x50@2x.png
├── AppIcon51x51@2x.png
├── AppIcon54x54@2x.png
├── AppIcon86x86@2x.png
├── AppIcon98x98@2x.png
├── AppIcon108x108@2x.png
├── AppIcon117x117@2x.png
├── AppIcon129x129@2x.png
└── AppIcon1024x1024@1x.png
```

