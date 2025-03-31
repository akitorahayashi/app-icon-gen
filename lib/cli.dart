import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;

import 'app_icon_generator.dart';

/// CLIツールのエントリーポイント
void run(List<String> arguments) {
  // ファイルパスのみで直接使用されているかチェック
  if (arguments.isNotEmpty &&
      !arguments[0].startsWith('-') &&
      File(arguments[0]).existsSync()) {
    AppIconGenerator.generateIcons(arguments[0], 'both');
    print('アイコン生成が正常に完了しました！');
    return;
  }

  final parser = ArgParser()
    ..addOption(
      'platform',
      abbr: 'p',
      help: 'プラットフォーム: ios, android, both',
      defaultsTo: 'both',
      allowed: ['ios', 'android', 'both'],
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
      print('使用法: app_icon_gen [画像パス] [オプション]');
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

    AppIconGenerator.generateIcons(inputPath, platform);
    print('アイコン生成が正常に完了しました！');
  } catch (e) {
    print('エラー: $e');
    print('使用法: app_icon_gen [画像パス] [オプション]');
    exit(1);
  }
}
