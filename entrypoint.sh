#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

# データベースの準備（デフォルトではRailsサーバを起動する前に実行）
bundle exec rails db:prepare

exec "$@"
