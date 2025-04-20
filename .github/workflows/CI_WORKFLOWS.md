# CI Workflows

このディレクトリには `app-icon-gen` CLIツール用の GitHub Actions ワークフローファイルが含まれています。

## ファイル構成

- **`ci-pipeline.yml`**: メインとなる統合CIパイプライン。Pull Request作成時や`main`ブランチへのプッシュ時、または手動でトリガーされ、後述の他のワークフローを順次実行します。
- **`format-and-lint.yml`**: コードのフォーマットチェック (`dart format`) と静的解析 (`dart analyze`) を実行する再利用可能ワークフロー。
- **`run-unit-tests.yml`**: ユニットテスト (`dart test`) を実行し、結果をテキストファイルとしてアーティファクトにアップロードする再利用可能ワークフロー。
- **`run-integration-tests.yml`**: 統合テストとして、各プラットフォーム (iOS, Android, watchOS) 向けのアイコン生成スクリプト (`app-icon-gen.sh`) を実行し、期待される出力ファイルが存在するかを検証する再利用可能ワークフロー。結果はテキストファイルとしてアーティファクトにアップロードされます。
- **`test-reporter.yml`**: テスト結果（JUnit XML形式を想定）をダウンロードし、GitHub Checksタブにレポートを表示し、PRに結果へのリンクを含むコメントを投稿する再利用可能ワークフロー。（注意：現在のテストワークフローはJUnit XMLを生成していません。）
- **`copilot-pr-review.yml`**: GitHub CopilotによるPRレビューをリクエストする再利用可能ワークフロー。
- **`notify-completion.yml`**: パイプラインの各ジョブの完了ステータスをPRにコメントとして投稿する再利用可能ワークフロー。

## CIの特徴

### ワークフローの分割
メインの`ci-pipeline.yml`が、フォーマット/Lintチェック、ユニットテスト、統合テスト、Copilotレビューリクエスト、テストレポート、完了通知といった個別の再利用可能ワークフローを呼び出す構造になっています。

### 包括的な検証プロセス
Pull Requestや`main`ブランチへのプッシュ時に、以下の自動チェックを実行します:
- コードフォーマット (`dart format`) と静的解析 (`dart analyze`)
- ユニットテスト (`dart test`)
- 統合テスト（各プラットフォーム向けのアイコン生成検証）

### Pull Request への自動フィードバック
Pull Requestに対して、以下の自動処理を行います:
- GitHub Copilotによる自動レビューリクエスト
- テスト結果レポート（Checksタブへの表示とPRコメント、現状はJUnit形式待ち）
- パイプライン全体の完了ステータス通知（各ジョブの成否サマリーコメント）

### 成果物管理
- **成果物管理**: 各テストの結果はテキストファイルとしてGitHub Artifactsにアップロード・管理されます (`unit-test-results`, `integration-test-results`)。
- **出力先**: スクリプトによるアイコン生成の出力先は `output/` ディレクトリです。テスト結果アーティファクトは `ci-outputs/test-results` にダウンロードされる想定ですが、アップロード名と一致していません。

### ローカルでの検証
(このセクションは現在のワークフロー構造と関係ないため削除または更新が必要です。Dartプロジェクトでは通常 `dart test` や `dart analyze` をローカルで実行します。)

## 機能詳細

### `ci-pipeline.yml` (メインパイプライン)

- **トリガー**: `main`/`master`へのPush、`main`/`master`ターゲットのPR、手動実行 (`workflow_dispatch`)
- **処理**:
    1.  コード品質チェック (`format-and-lint.yml`)
    2.  ユニットテスト実行 (`run-unit-tests.yml`)
    3.  統合テスト実行 (`run-integration-tests.yml`、ユニットテスト後に実行)
    4.  Copilotレビュー依頼 (PR時, `copilot-pr-review.yml`、フォーマット/Lint後に実行)
    5.  テスト結果レポート (PR時, `test-reporter.yml`、統合テスト後に実行)
    6.  パイプライン完了ステータス通知 (PR時, `notify-completion.yml`、全ジョブ完了後に実行)

### `format-and-lint.yml` (フォーマット & Lint)

- **トリガー**: `ci-pipeline.yml` から `workflow_call` で呼び出し
- **処理**:
    1.  Dart SDK セットアップ
    2.  依存関係インストール (`dart pub get`)
    3.  フォーマットチェック (`dart format --set-exit-if-changed .`)
    4.  静的解析 (`dart analyze`)
    5.  Git diffによるフォーマット変更最終確認

### `run-unit-tests.yml` (ユニットテスト実行)

- **トリガー**: `ci-pipeline.yml` から `workflow_call` で呼び出し
- **処理**:
    1.  Dart SDK セットアップ
    2.  依存関係インストール (`dart pub get`)
    3.  `app-icon-gen.sh` に実行権限付与
    4.  ユニットテスト実行 (`dart test --reporter expanded`)、結果を `unit_test_results.txt` に出力
    5.  結果テキストファイルをアーティファクト (`unit-test-results`) としてアップロード
    6.  テスト失敗時にジョブを失敗させる

### `run-integration-tests.yml` (統合テスト実行)

- **トリガー**: `ci-pipeline.yml` から `workflow_call` で呼び出し
- **処理**:
    1.  Dart SDK セットアップ
    2.  依存関係インストール (`dart pub get`)
    3.  `app-icon-gen.sh` に実行権限付与
    4.  各プラットフォーム (iOS, Android, watchOS) 向けに `app-icon-gen.sh` を実行し、出力ディレクトリと `Contents.json` (iOS/watchOS) の存在を確認
    5.  各プラットフォームの成否を `integration_test_results.txt` に追記
    6.  結果テキストファイルをアーティファクト (`integration-test-results`) としてアップロード
    7.  いずれかのプラットフォームのテスト失敗時にジョブを失敗させる

### `test-reporter.yml` (テスト結果レポート)

- **トリガー**: `ci-pipeline.yml` から `workflow_call` で呼び出し (PR時)
- **処理**:
    1.  `test-results` アーティファクトを `./ci-outputs/test-results` にダウンロード (注意: 名前が不一致の可能性)
    2.  `./ci-outputs/test-results/unit/junit.xml` または `ui/junit.xml` が存在すれば、`mikepenz/action-junit-report` を使用してChecksタブにレポートを表示
    3.  JUnitファイルが見つかった場合、Pull RequestにChecksタブで結果が利用可能であることを示すコメント (`<!-- test-results-summary -->`) を投稿または更新

### `copilot-pr-review.yml` (Copilotレビュー依頼)

- **トリガー**: `ci-pipeline.yml` から `workflow_call` で呼び出し (PR時)
- **処理**:
    1.  入力されたPR番号に対して `copilot` をレビュアーとして追加リクエスト
    2.  失敗した場合、エラー理由を含むコメントをPRに投稿

### `notify-completion.yml` (完了通知)

- **トリガー**: `ci-pipeline.yml` から `workflow_call` で呼び出し (PR時、常に実行)
- **処理**:
    1.  各先行ジョブ (format/lint, unit tests, integration tests, copilot review, test report) の結果を受け取る
    2.  全体ステータスアイコンを決定
    3.  Pull Requestに各ジョブの成否を示すサマリーコメント (`<!-- ci-status-summary -->`) を投稿または更新

## 使用方法

メインパイプライン (`ci-pipeline.yml`) は以下のタイミングで自動実行されます:

- **プッシュ時**: `main` または `master` ブランチへのプッシュ
- **PR作成/更新時**: `main` または `master` ブランチをターゲットとするPull Request
- **手動実行**: GitHub Actionsタブから `ci-pipeline.yml` を選択して実行可能

個別のワークフローは通常、直接実行するのではなく、`ci-pipeline.yml` によって呼び出されます。

## 技術仕様

- **Dart SDK**: `>=2.17.0 <4.0.0`
- **主要な依存パッケージ**:
  - `args`: コマンドライン引数の解析
  - `image`: 画像処理
  - `path`: ファイルパス操作
- **開発時の依存パッケージ**:
  - `lints`: コードの静的解析ルール
  - `test`: ユニットテストフレームワーク
- **パッケージ管理**: Pub (Dart's package manager)
