# App Icon Generator

## Features

### iOS
- 最新のiOS 17/Xcode 15形式に対応
  - Universal アイコン (1024x1024)
  - ダークモード対応アイコン (1024x1024)
  - Tinted モード対応アイコン (1024x1024)
- 従来形式 (iOS 16以下の互換性)
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

## Directory Structure
```
app-icon-gen.sh             # 実行用のシェルスクリプト

lib/
├── app_icon_generator.dart  
├── cli.dart                 
├── model/                   
│   └── icon_template.dart   
└── platform/               
    ├── android_icon_generator.dart  
    └── ios_icon_generator.dart      

bin/
└── app_icon_gen.dart       

test/
└── icon_generator_test.dart 

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
$ chmod +x app-icon-gen.sh  # シェルスクリプトに実行権限を付与
```

## Preparing Your Icon

1. アプリアイコン用の正方形のPNG画像を作成または入手（1024x1024ピクセル）
2. プロジェクト内の `assets` ディレクトリに画像を配置

## Usage

```bash
$ ./app-icon-gen.sh assets/your_icon.png
```

### Examples

**iOSアイコンのみ生成**
```bash
$ ./app-icon-gen.sh -p ios assets/your_icon.png
```

**Androidアイコンのみ生成**
```bash
$ ./app-icon-gen.sh -p android assets/your_icon.png
```

**両プラットフォーム用アイコンを生成：**
```bash
$ ./app-icon-gen.sh assets/your_icon.png
```

生成されたすべてのアイコンは、プロジェクトの `build/` ディレクトリに保存されます。

#### iOS 17のダークモードとTintedモード対応

デフォルトでは、すべてのモード（ライト/ダーク/Tinted）に同じアイコン画像が使用されますが、最適な表示のためには、各モード専用のアイコンを用意することをお勧めします

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
├── AppIcon-1024x1024.png      # iOS 17用標準アイコン
├── AppIcon-1024x1024-dark.png # iOS 17用ダークモードアイコン
└── AppIcon-1024x1024-tinted.png # iOS 17用ティントモードアイコン
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

