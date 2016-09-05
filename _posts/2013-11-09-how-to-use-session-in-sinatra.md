---
layout: blog
title: Sinatraでセッションを使う方法
tag: sinatra
---



軽量Webアプリケーションフレームワーク、SinatraではデフォルトでRackのセッション機能は無効化されている。セッションを有効にするには以下の指定を行う。

~~~~
enable :sessions
~~~~

これによってアプリケーション内で`session`変数が使用可能になる。`session`を使ったアプリケーションの例は以下の通り。ルート`/foo`でセッションに`Hello World!`という文字列を追加し、別のルート`/bar`でセッションから値を取り出して表示するものだ。

~~~~
get '/foo' do
  session[:message] = 'Hello World!'
  redirect to('/bar')
end

get '/bar' do
  session[:message]   # => 'Hello World!'
end
~~~~

なおセッションのCookieをカスタマイズするには、`use Rack::Session::Cookie`を使う。

~~~~
use Rack::Session::Cookie, :key => 'rack.session',
                           :domain => 'foo.com',
                           :path => '/',
                           :expire_after => 2592000, # In seconds
                           :secret => 'change_me'
~~~~

- [How do I use sessions?](http://www.sinatrarb.com/faq.html#sessions)
