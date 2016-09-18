---
layout: blog
title: 楽々スクレイピング! Ruby Mechanizeの使い方(2)
tag: ruby
---



[楽々スクレイピング! Ruby Mechanizeの使い方](/2013/10/05/ruby-www-mechanize.html)では、Mechanizeの基本的な使い方を紹介した。このエントリーではもう一歩踏み込んだMechanizeの便利な使い方を紹介する。

# User-Agentを設定する

スクレイピングにおいてUser-Agentを偽装するのは有効な方法だ。
Mechanizeでは`Mechanize#user_agent_alias=`で特定の文字列を指定してやることで、User-Agentを設定することができる。
以下はMechanizeをWindowsのInternetExplorer 9に見せかける例である。

~~~~
require 'mechanize'
agent = Mechanize.new
agent.user_agent_alias = 'Windows IE 9'
~~~~

なお`Mechanize#user_agent_alias=`には以下の文字列が指定可能だ。

- Linux Firefox
- Linux Konqueror
- Linux Mozilla
- Mac Firefox
- Mac Mozilla
- Mac Safari
- Mac Safari 4
- Mechanize
- Windows IE 6
- Windows IE 7
- Windows IE 8
- Windows IE 9
- Windows Mozilla
- iPhone
- iPad

# ログを保存する

スクレイピングのスクリプトはcron等で定期実行することも多いので、ログを保存しておけると便利である。
Mechanizeにはロギング機能があり、`Mechanize#log=`でロガーを指定することで、スクレイピングのログを取ることができる。
ログにはHTTPのリクエスト/レスポンスヘッダなどが記録される。
以下はデバッグ目的で標準エラー出力にログを出力する例である。

~~~~
require 'mechanize'
require 'logger'

agent = Mechanize.new
agent.log = Logger.new $stderr
page = agent.get('http://www.yahoo.co.jp/')
~~~~

# HTTPプロキシを利用する

HTTPプロキシの設定は`Mechanize#set_proxy`で行う。
引数にはアドレス、ポート、ユーザ名、パスワードを指定する。
このうちユーザ名とパスワードは省略可能である。

~~~~
agent = Mechanize.new
agent.set_proxy('proxy.example.com', 8080)
~~~~

# BASIC認証する

MechanizeでBASIC認証するには`Mechanize#add_auth`を使う。
`Mechanize#add_auth`の引数にはBASIC認証の対象とするURLの一部、ユーザ名、パスワードを指定する。
これでMechanizeはBASIC認証の対象とするURLにマッチするアクセスでBASIC認証を試みるようになる。

~~~~
require 'mechanize'
agent = Mechanize.new
agent.add_auth('http://example.org', 'foo', 'bar')
page = agent.get('http://example.org/buz') # BASIC認証を試行
~~~~

# 不正なSSL証明書を受け入れる

イントラ内のホスト等で不正なSSL証明書をやむを得ず受け入れないといけない場合もあるだろう。
そのような場合は`Mechanize#verify_mode=`で検証モードを無効に設定してやると不正なSSL証明書を受け入れてhttpsでアクセスすることもできる。

~~~~
require 'mechanize'
agent = Mechanize.new
agent.add_auth('https://example.com/', 'user', 'pass')
agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
~~~~

ただ、これはセキュリティに問題があるので、乱用すべきではない。
正しくは`Mechanize#ca_file=`で証明書を設定してアクセスできるようにすべきだろう。

# ファイルをダウンロードする

`Mechanize#get_file`を使えばMechanizeを使ってファイルをダウンロードすることができる。
返り値はファイルの内容のバイナリ文字列である。
これは`agent.get(url).body`とするのと同じであるが、意味が明確になるのでこちらを使おう。

~~~~
require 'mechanize'
agent = Mechanize.new
agent.get_file('http://example.com/file.zip')
~~~~

# ヒストリー機能を利用する

MechanizeはブラウザのようにアクセスしたURLの一覧をヒストリーとして保持している。
ヒストリーを上手に活用することで、リファラも含めてあたかもブラウジングしているかのように、Webアクセスすることができる。

ヒストリーは`Mechanize#get`や`Mechanize::Link#click`によるWebアクセスで蓄積されていく。
現在のヒストリーは`Mechanize#history`で確認可能だ。
ヒストリーは`Mechanize#back`で遡りカレントページを以前のページに戻す事ができる。

~~~~
require 'mechanize'
agent = Mechanize.new
agent.get('http://www.google.com/')
agent.get('http://www.yahoo.co.jp/')
p agent.history #=> [http://www.google.com/, http://www.google.co.jp/?gfe_rd=cr&ei=RK08U8_mBKbH8gfNxYDICg, http://www.yahoo.co.jp/]
agent.back
p agent.history #=> [http://www.google.com/, http://www.google.co.jp/?gfe_rd=cr&ei=RK08U8_mBKbH8gfNxYDICg]
~~~~

# 要素を検索する

`Mechanize::Page#search`はCSS記法やXPathでページのHTMLを検索して目的の要素を取り出すメソッドである。
スクレイピングで良く使うメソッドであるが、`Mechanize::Page#search`は少々長い。

実は`Mechanize::Page#/`が`Mechanize::Page#search`のエイリアスとなっており、検索は以下のように書くことができる。
これなら簡単だ。

~~~~
require 'mechanize'
agent = Mechanize.new
page = agent.get('http://example.com/')
page / 'ul li'
~~~~

# 条件にマッチしたリンクを取得する

`Mechanize::Page#links`ではページに存在するリンクの一覧を取得することができる。
だが、実際にはリンクの一覧ではなく、テキストやリンク先が条件にマッチしたリンクを取得したい場合が大半だろう。

リンクの一覧から目的のリンクを自力で抽出する処理を書いても良いが、手間である。
`Mechanize::Page#link_with`や`Mechanize::Page::links_with`はまさにこの目的で使えるメソッドだ。
`Mechanize::Page#link_with`は最初にマッチしたリンクを、`Mechanize::Page::links_with`はマッチしたリンクの配列を返す。

以下はリンク先が正規表現`/foo/`とマッチするリンクの一覧を取得する例である。

~~~~
require 'mechanize'
agent = Mechanize.new
page = agent.get('http://example.com/')
page.links_with(:href => /foo/).each do |link|
  puts link.href
end
~~~~

# 条件にマッチしたフォームを取得する

条件にマッチしたリンクを取得するのと同様に、条件にマッチしたフォームも取得することができる。
条件にマッチしたフォームの取得には`Mechanize::Page#form_with`や`Page#forms_with`を使う。
実際にはフォームのnameやactionを手がかりにフォームを特定することが多いだろう。

以下はフォームのactionが`/post/login.php`であるフォームを取得する例である。

~~~~
require 'mechanize'
agent = Mechanize.new
page = agent.get('http://example.com/')
page.forms_with(:action => '/post/login.php').each do |f|
  # do something
end
~~~~

# フレームの一覧を得る

時にはフレームを使ったWebページをスクレイピングすることがあるかもしれない。
frameの一覧は`Mechanize::Page#frams`で、iframeの一覧は`Mechanize::Page#iframs`で取得できる。
これにも条件にマッチしたフレームを取得する`Mechanize::Page#frames_with`などのメソッドがある。
なお`Mechanize::Page::Frame`はリンクと同様に`click`メソッドでフレーム内に遷移できる。

~~~~
require 'mechanize'
agent = Mechanize.new
page = agent.get('http://example.com/')
page.iframe_with(:src => /foo/).click
~~~~

# 画像の一覧を得る

リンクやフォームと同様に、Mechanizeでは画像の一覧を`Mechanize#images`で得られる。
条件にマッチした画像を得る`Mechanize#images_with`や`Mechanize#image_with`もある。
返り値は`Mechanize::Page::Image`オブジェクトである。

抽出した画像は`Mechanize::Page::Image#fetch`でダウンロードすると良いだろう。
返り値は`Mechanize::File`なので、そのまま`Mechanize::File#save`で保存することもできる。

以下はページからJPG画像を探しだしてそれらを全てダウンロードしてカレントディレクトリに保存する例である。

~~~~
require 'mechanize'
agent = Mechanize.new
page = agent.get('http://example.com/')
page.images_with(:src => /jpg\Z/).each do |img|
  img.fetch.save
end
~~~~
