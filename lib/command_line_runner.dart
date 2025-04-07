import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;

import 'generator/android_icon_generator.dart';
import 'generator/ios_icon_generator.dart';
import 'generator/watchos_icon_generator.dart';

void run(List<String> arguments) {
  final parser = ArgParser()
    ..addOption(
      'platform',
      abbr: 'p',
      help: 'プラットフォーム: ios, android, watchos',
      allowed: ['ios', 'android', 'watchos'],
      mandatory: true,
    );

  try {
    final argResults = parser.parse(arguments);

    String? inputPath;

    // 入力パスは位置引数から取得
    if (argResults.rest.isNotEmpty) {
      inputPath = argResults.rest[0];
    }

    final platform = argResults['platform'] as String;

    if (inputPath == null || inputPath.isEmpty) {
      print('エラー: 入力画像パスが指定されていません');
      _printUsage(parser);
      exit(1);
    }

    // ファイルが存在するか確認
    if (!File(inputPath).existsSync()) {
      // assetsディレクトリ内を確認
      final assetsPath = path.join('assets', path.basename(inputPath));
      if (File(assetsPath).existsSync()) {
        print('ファイルが "$inputPath" で見つかりませんでした。代わりに "$assetsPath" を使用します。');
        inputPath = assetsPath;
      } else {
        // プロジェクトルートを確認
        final rootPath = path.basename(inputPath);
        if (File(rootPath).existsSync() && rootPath != inputPath) {
          print('ファイルが "$inputPath" で見つかりませんでした。代わりに "$rootPath" を使用します。');
          inputPath = rootPath;
        } else {
          print('エラー: ファイルが見つかりません: $inputPath');
          print('アイコンを "assets" ディレクトリまたはプロジェクトルートに配置してください。');
          exit(1);
        }
      }
    }

    // 入力画像を読み込む
    final inputFile = File(inputPath);
    final bytes = inputFile.readAsBytesSync();
    final originalImage = img.decodeImage(bytes);
    if (originalImage == null) {
      throw Exception('画像のデコードに失敗しました。');
    }

    print('画像を処理中: $inputPath');

    // プラットフォームごとに処理
    switch (platform) {
      case 'ios':
        IOSIconGenerator.generateIcons(originalImage);
        break;
      case 'android':
        AndroidIconGenerator.generateIcons(originalImage);
        break;
      case 'watchos':
        WatchOSIconGenerator.generateIcons(originalImage);
        break;
      default:
        throw Exception(
            'サポートされていないプラットフォーム: $platform\n有効なプラットフォーム: ios, android, watchos');
    }

    print('アイコン生成が正常に完了しました！');
  } on FormatException catch (e) {
    print('エラー: コマンドライン引数の解析に失敗しました: $e');
    _printUsage(parser);
    exit(1);
  } catch (e) {
    print('エラー: $e');
    _printUsage(parser);
    exit(1);
  }
}

/// 使用方法を表示
void _printUsage(ArgParser parser) {
  print('使用法: app_icon_gen -p <platform> [画像パス]');
  print('');
  print('例:');
  print('  app_icon_gen -p ios assets/icon.png     # iOS用アイコン生成');
  print('  app_icon_gen -p android assets/icon.png # Android用アイコン生成');
  print('  app_icon_gen -p watchos assets/icon.png # watchOS用アイコン生成');
  print('');
  print('オプション:');
  print(parser.usage);
}
