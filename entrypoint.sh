#!/bin/bash
# set -e は「エラーが発生するとスクリプトを終了する」オプション
set -e

# exec "$@"でCMDで渡されたコマンドを実行。(→rails s)
# コンテナのプロセスを実行する。（Dockerfile 内の CMD に設定されているもの。）
exec "$@"