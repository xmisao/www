---
layout: blog
title: Sinatraのエラーハンドラはdevelopment環境(デフォルト)では動作しない
tag: sinatra
---



Sinatraでは例外発生時にエラー画面を表示するためのエラーハンドラ`error`が用意されている。これにより以下のようなエラーハンドリングが可能である。

~~~~
error do
  # すべての例外を捕捉
end

error MyException do
  # MyException例外を捕捉
end

error 403
  # ステータスコード403を捕捉
end
~~~~

ただし、注意点としてdevelopment環境(デフォルト)では、Sinatraのエラー画面が出てきてしまい、これらのエラーハンドラは動作しない。エラーハンドラを期待通り動作させるには、Sinatraの環境を設定してやる必要がある。環境を設定するには以下3つの方法がある。

# 環境変数

`RACK_ENV`環境変数に`production`を設定してSinatraアプリケーションを起動することで環境を設定することができる。

~~~~
RACK_ENV=production rackup
~~~~

# config.ru

`config.ru`で`set`を使って`:environment`を`:production`にすることで環境を設定することができる。

~~~~
set :environment, :production
~~~~

# アプリケーション

`config.ru`と同様にアプリケーション内で`set`を使うことで環境を設定することができる。

~~~~
set :environment, :production
~~~~
