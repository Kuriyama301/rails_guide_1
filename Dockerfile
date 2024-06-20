FROM ruby:3.1

# パッケージのインストール
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    nodejs \
    npm

# RubyGemsの最新バージョンをインストール
RUN gem update --system

# アプリケーションのディレクトリを設定
WORKDIR /app

# GemfileとGemfile.lockをコピー
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# Gemのインストール
RUN bundle install

# アプリケーションのファイルをコピー
COPY . /app

# entrypoint.shの設定と実行権限の付与
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# コンテナが起動する際のデフォルトのエントリーポイント
ENTRYPOINT ["entrypoint.sh"]

# コンテナがlistenするポートの設定
EXPOSE 3111

# Railsサーバーの起動コマンド
CMD ["rails", "server", "-b", "0.0.0.0"]
