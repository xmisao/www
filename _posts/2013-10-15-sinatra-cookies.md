---
layout: blog
title: SinatraでCookieを扱う
tag: ruby
---



軽量Webアプリケーションフレームワーク[Sinatra](http://www.sinatrarb.com/intro-jp.html)でCookieを扱うには、`Sinatra::Cookies`エクステンションを使う。

エクステンションを有効にするには`sinatra/cookies`をrequireする。
すると`get()`などのブロック内で`cookies`が使用可能になる。
ブラウザへのCookieの設定は以下。`redirect`と組み合わせて使うこともできる。

~~~~
require 'sinatra'
require 'sinatra/cookies'

get '/set_cookie' do
	cookies[:something] = 'foobar'
	redirect to('/')
end
~~~~

ブラウザから送信されたCookieを取得するには以下のようにする。
先ほどとは逆に`cookies`から値を得る。

~~~~
require 'sinatra'
require 'sinatra/cookies'

get '/get_cookie' do
	value = cookies[:something]
end
~~~~

なお`Sinatra::Base`を継承して作成しているアプリケーションの場合は、`helpers`を使ってエクステンションを有効にしてやる必要がある。

~~~~
require "sinatra/base"
require "sinatra/cookies"

class MyApp < Sinatra::Base
  helpers Sinatra::Cookies

  # The rest of your modular application code goes here...
end
~~~~

参考:

- [Sinatra::Cookies](http://www.sinatrarb.com/contrib/cookies.html)
