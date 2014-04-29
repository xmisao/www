---
layout: blog
title: Sinatraでログをファイルに保存する方法
tag: sinatra
---

# Sinatraでログをファイルに保存する方法

Sinatraで`Rack::CommonLogger`を使ってアクセスログを取る方法のメモ。
アプリケーションに以下を記述する。

~~~~
configure do
  enable :logging
  file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
  file.sync = true
  use Rack::CommonLogger, file
end
~~~~

ロギングを有効にするために`enable :logging`する。
`Sinatra::Base`を継承しないクラシックスタイルアプリケーションの場合は、デフォルトでロギングが有効なので、この1行は必要ない。

続いてログを出力したいファイルをオープンする。
ログは即座にファイルに書き出したいため`file.sync = true`しておく。

最後に`use Rack::CommonLogger`で開いたファイルを渡してロガーを初期化してやればok。

参考

- [Sinatra Recipes Rack::CommonLogger](http://recipes.sinatrarb.com/p/middleware/rack_commonlogger)
