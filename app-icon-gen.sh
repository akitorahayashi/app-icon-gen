#!/bin/bash

# App Icon Generator 実行スクリプト

# スクリプト自体の場所を取得
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# スクリプトのディレクトリをプロジェクトディレクトリとして使用
cd "$SCRIPT_DIR" && dart run bin/app_icon_gen.dart "$@" 