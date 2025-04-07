# App Icon Generator

## Features

### iOS
- Support for the latest format
  - Universal icon (1024x1024)
  - Dark mode icon (1024x1024)
  - Tinted mode icon (1024x1024)
- Legacy format (iOS 16 and below compatibility)
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

## Directory Structure
```
app_icon_gen
├── app-icon-gen.sh         
├── bin/
│   └── app_icon_gen.dart    
├── lib/
│   ├── command_line_runner.dart 
│   ├── model/
│   │   └── watchos_icon_template.dart 
│   └── generator/
│       ├── android_icon_generator.dart 
│       ├── ios_icon_generator.dart     
│       └── watchos_icon_generator.dart  
├── test/
│   ├── android_icon_generator_test.dart
│   ├── ios_icon_generator_test.dart
│   └── watchos_icon_generator_test.dart
└── assets/
    └── icon_gen_sample.png   # サンプルアイコン
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

1. アプリアイコン用の正方形のPNG画像を作成または入手（推奨：1024x1024ピクセル）
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

生成されたすべてのアイコンは、プロジェクトの `app_icon_gen/build/` ディレクトリに保存されます。

#### iOS 17のダークモードとTintedモードの対応

デフォルトでは、すべてのモード（ライト/ダーク/Tinted）に同じアイコン画像が使用されますが、最適な表示のためには、各モード専用のアイコンを用意することをお勧めします：

- **ダークモード用アイコン**: 暗い背景に映えるようにデザインされたアイコン（自動生成されたものを `AppIcon-1024x1024-dark.png` と交換）
- **Tintedモード用アイコン**: システムのアクセントカラーが効果的に適用できるモノクロや単色ベースのデザイン（自動生成されたものを `AppIcon-1024x1024-tinted.png` と交換）

各モード用のアイコンを用意したら、生成後に `build/ios/AppIcon.appiconset/` ディレクトリ内の対応するファイルを置き換えてください。

