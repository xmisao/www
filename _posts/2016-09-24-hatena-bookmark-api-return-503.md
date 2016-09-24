---
layout: blog
title: はてなブックマークエントリー情報取得APIが503を返す / はてなはRubyが嫌い?
tag: ['ruby', 'hatena']
---

# TL;DR

* はてなブックマークエントリー情報取得APIは、User-Agentが存在しないリクエストに対して`503`を返す
* さらに、なぜか`Ruby`という文字列に前方一致するUser-Agentのリクエストに対しても`503`を返す
* はてなブックマークエントリー情報取得APIを使用する時は、`Ruby`から始まらないUser-Agentを指定してリクエストする必要がある

# 概要

[はてなブックマークエントリー情報取得API](http://developer.hatena.ne.jp/ja/documents/bookmark/apis/getinfo)を使用すると、あるURLについて、はてなブックマークのエントリー情報(件数やコメント等)を取得することができます。

大変魅力的なAPIですが、このAPIを使用しようとしたところ、はてなのドキュメントには書かれていない奇妙な挙動に気づいたので、書き留めておくことにします。

奇妙な挙動を確認したのは2016年9月24日です。
Web APIは生モノなので、明日には違う挙動になっているかも知れません。

エンドポイントは`http://b.hatena.ne.jp/entry/json/`も`http://b.hatena.ne.jp/entry/jsonlite/`の2種類あり、このエントリでは後者を使用していますが、どちらも同じ挙動です。

# 気付き

以下のようなopen-uriを使用したRubyスクリプトで、はてなブックマークエントリー情報取得APIにアクセスしたところ、503が返ってくることに気付きました。
`url=`のパラメータには、このブログの[古いトップページ](http://www.xmisao.com/)(`http://www.xmisao.com/`)をエンコードした値を指定しています。

~~~~ruby
require 'open-uri'

puts open('http://b.hatena.ne.jp/entry/jsonlite/?url=http%3A%2F%2Fwww.xmisao.com%2F'){|f| f.read }
~~~~

実行結果は以下のとおりです。

~~~~txt
/usr/lib/ruby/2.3.0/open-uri.rb:359:in `open_http': 503 Service Temporarily Unavailable (OpenURI::HTTPError)
        from /usr/lib/ruby/2.3.0/open-uri.rb:737:in `buffer_open'
        from /usr/lib/ruby/2.3.0/open-uri.rb:212:in `block in open_loop'
        from /usr/lib/ruby/2.3.0/open-uri.rb:210:in `catch'
        from /usr/lib/ruby/2.3.0/open-uri.rb:210:in `open_loop'
        from /usr/lib/ruby/2.3.0/open-uri.rb:151:in `open_uri'
        from /usr/lib/ruby/2.3.0/open-uri.rb:717:in `open'
        from /usr/lib/ruby/2.3.0/open-uri.rb:35:in `open'
        from test.rb:3:in `<main>'
~~~~

URLはあっているはずで、ドキュメントにも特に必須のヘッダは書かれていないため、なぜ503が返ってくるのかわかりませんでした。
試しにブラウザや`curl`コマンドで同じURLにアクセスしてみると、特に問題なく200が返ってくることもわかりました。

~~~~txt
$ curl --verbose http://b.hatena.ne.jp/entry/jsonlite/?url=http%3A%2F%2Fwww.xmisao.com%2F
*   Trying 59.106.194.17...
* Connected to b.hatena.ne.jp (59.106.194.17) port 80 (#0)
> GET /entry/jsonlite/?url=http%3A%2F%2Fwww.xmisao.com%2F HTTP/1.1
> Host: b.hatena.ne.jp
> User-Agent: curl/7.47.0
> Accept: */*
> 
< HTTP/1.1 200 OK
< Server: nginx
< Date: Sat, 24 Sep 2016 08:36:00 GMT
< Content-Type: application/json; charset=utf-8
< Content-Length: 376
< Connection: keep-alive
< Set-Cookie: b=$1$YGv7mcQR$DQZybhcQrFFmU0D169CQT/; expires=Fri, 19-Sep-2036 08:36:00 GMT; domain=hatena.ne.jp; path=/
< Cache-Control: max-age=1800
< Expires: Sat, 24 Sep 2016 09:02:15 GMT
< X-Content-Type-Options: nosniff
< X-Framework: Ridge/0.11
< X-Ridge-Dispatch: Hatena::Bookmark::Engine::Entry::Jsonlite#default
< X-Runtime: 7ms
< X-View-Runtime: 0ms
< X-Cache: HIT from squid.hatena.ne.jp
< X-Cache-Lookup: HIT from squid.hatena.ne.jp:8080
< Via: 1.1 bookmark2squid14.hatena.ne.jp:8080 (squid/2.7.STABLE6)
< X-Roles: [sb]
< 
* Connection #0 to host b.hatena.ne.jp left intact
{"count":1,"bookmarks":[{"timestamp":"2014/01/28 14:00:14","comment":"","user":"cald","tags":["!personal"]}],"url":"http://www.xmisao.com/","eid":179605530,"title":"\u307a\u3051\u307f\u3055\u304a -- xmisao","screenshot":"http://screenshot.hatena.ne.jp/images/200x150/9/7/4/2/9/b620a4d4f24411fa1d7e19210a4a25dba24.jpg","entry_url":"http://b.hatena.ne.jp/entry/www.xmisao.com/"}
~~~~

気になってぐぐると、はてなブックマークエントリー情報取得APIは、ヘッダにUser-Agentがないと503を返す、という記載のある、比較的最近のページがいくつか見つかります。(括弧の中には公開されたと思われる日付を記入しています)

* [はてなブックマークの RSS を Ruby で取得していたのですが、こ… - 人力検索はてな](http://q.hatena.ne.jp/1451205850) (2015/12/27)
* [はてなのAPIを使う際に503エラーが出る問題と解決策 - Qiita](http://qiita.com/takuya-andou/items/97a68bdae1) (2016/3/10)
* [はてなAPIをPHPで取得すると503エラーになる問題の対処方法 \| karakaram-blog](http://www.karakaram.com/hatena-api-503-error) (2016/5/30)

いまいち納得はいきませんが、とりあえずUser-Agentを付けてアクセスすれば良いのだろうと思い、[Rubyのリファレンスマニュアル](https://docs.ruby-lang.org/ja/latest/library/open=2duri.html)に倣って、`Ruby/#{RUBY_VERSION}`の形のUser-Agentを付けてみました。
私の環境はRuby 2.3.0ですので、これで`Ruby/2.3.0`というUser-Agentを送ることになります。

修正後のスクリプトと実行結果は以下です。

~~~~ruby
require 'open-uri'

puts open('http://b.hatena.ne.jp/entry/jsonlite/?url=http%3A%2F%2Fwww.xmisao.com%2F', 'User-Agent' => "Ruby/#{RUBY_VERSION}"){|f| f.read }
~~~~

~~~~txt
/usr/lib/ruby/2.3.0/open-uri.rb:359:in `open_http': 503 Service Temporarily Unavailable (OpenURI::HTTPError)
        from /usr/lib/ruby/2.3.0/open-uri.rb:737:in `buffer_open'
        from /usr/lib/ruby/2.3.0/open-uri.rb:212:in `block in open_loop'
        from /usr/lib/ruby/2.3.0/open-uri.rb:210:in `catch'
        from /usr/lib/ruby/2.3.0/open-uri.rb:210:in `open_loop'
        from /usr/lib/ruby/2.3.0/open-uri.rb:151:in `open_uri'
        from /usr/lib/ruby/2.3.0/open-uri.rb:717:in `open'
        from /usr/lib/ruby/2.3.0/open-uri.rb:35:in `open'
        from test.rb:3:in `<main>'
~~~~

失敗です。また503が返ってきました。
User-Agentは指定したのに、なぜ…。

ここで、実はUser-Agent以外に何か条件があるのか、許容されるUser-Agentが限られているのでは、と考えました。
とりあえずRubyから`curl`コマンドと同じ`curl/7.47.0`を送信してみます。

~~~~ruby
require 'open-uri'

puts open('http://b.hatena.ne.jp/entry/jsonlite/?url=http%3A%2F%2Fwww.xmisao.com%2F', 'User-Agent' => 'curl/7.47.0'){|f| f.read }
~~~~

~~~~txt
{"count":1,"bookmarks":[{"timestamp":"2014/01/28 14:00:14","comment":"","user":"cald","tags":["!personal"]}],"url":"http://www.xmisao.com/","eid":179605530,"title":"\u307a\u3051\u307f\u3055\u304a -- xmisao","screenshot":"http://screenshot.hatena.ne.jp/images/200x150/9/7/4/2/9/b620a4d4f24411fa1d7e19210a4a25dba24.jpg","entry_url":"http://b.hatena.ne.jp/entry/www.xmisao.com/"}
~~~~

成功です。問題なく結果が返ってきました。
Rubyのopen-uriであっても、`curl`コマンド相当のUser-Agentを指定すれば、うまく結果が取得できるようです。

今度は`curl`コマンドで、Rubyスクリプトと同じ`Ruby/2.3.0`をUser-Agentを指定して、アクセスしてみます。

~~~~txt
$ curl --verbose --user-agent 'Ruby/2.3.0' http://b.hatena.ne.jp/entry/jsonlite/?url=http%3A%2F%2Fwww.xmisao.com%2F
*   Trying 59.106.194.17...
* Connected to b.hatena.ne.jp (59.106.194.17) port 80 (#0)
> GET /entry/jsonlite/?url=http%3A%2F%2Fwww.xmisao.com%2F HTTP/1.1
> Host: b.hatena.ne.jp
> User-Agent: Ruby/2.3.0
> Accept: */*
> 
< HTTP/1.1 503 Service Temporarily Unavailable
< Server: nginx
< Date: Sat, 24 Sep 2016 09:05:28 GMT
< Content-Type: text/html
< Content-Length: 206
< Connection: keep-alive
< 
<html>
<head><title>503 Service Temporarily Unavailable</title></head>
<body bgcolor="white">
<center><h1>503 Service Temporarily Unavailable</h1></center>
<hr><center>nginx</center>
</body>
</html>
* Connection #0 to host b.hatena.ne.jp left intact
~~~~

失敗です。503が返ってきました。

やはり特にUser-Agent以外のヘッダは必要とされておらず、User-Agentが`Ruby/2.3.0`の場合に、はてなブックマークエントリー情報取得APIは、503を返してくることがわかりました。

## 実験

ここまで来ると、どのようなUser-Agentで503が返ってくるのか、いろいろ試してみたくなるのが人間のさがです。
`curl`コマンドで実験してみることにします。

### どのようなUser-Agentだと失敗するのか

`Ruby/2.3.0`よりシンプルな、`Ruby`ではどうでしょうか。

~~~~txt
$ curl --verbose --user-agent 'Ruby' http://b.hatena.ne.jp/entry/jsonlite/?url=http%3A%2F%2Fwww.xmisao.com%2F
*   Trying 59.106.194.16...
* Connected to b.hatena.ne.jp (59.106.194.16) port 80 (#0)
> GET /entry/jsonlite/?url=http%3A%2F%2Fwww.xmisao.com%2F HTTP/1.1
> Host: b.hatena.ne.jp
> User-Agent: Ruby
> Accept: */*
> 
< HTTP/1.1 503 Service Temporarily Unavailable
< Server: nginx
< Date: Sat, 24 Sep 2016 09:10:00 GMT
< Content-Type: text/html
< Content-Length: 206
< Connection: keep-alive
< 
<html>
<head><title>503 Service Temporarily Unavailable</title></head>
<body bgcolor="white">
<center><h1>503 Service Temporarily Unavailable</h1></center>
<hr><center>nginx</center>
</body>
</html>
* Connection #0 to host b.hatena.ne.jp left intact
~~~~

失敗です。503でした。

`Ruby`のような、いい加減なUser-Agentではダメなのでしょうか。
実は`curl/7.47.0`のような一般的なUser-Agentだけが許可されているのでしょうか。

### ブラックリストなのかホワイトリストなのか

`Ruby`よりも、かなりいい加減と思われる`hoge`をUser-Agentに指定してみます。
`Ruby`だけがブラックリストなら成功し、一般的なUser-Agentのホワイトリストならまず失敗するはずです。

~~~~txt
curl --verbose --user-agent 'hoge' http://b.hatena.ne.jp/entry/jsonlite/?url=http%3A%2F%2Fwww.xmisao.com%2F
*   Trying 59.106.194.16...
* Connected to b.hatena.ne.jp (59.106.194.16) port 80 (#0)
> GET /entry/jsonlite/?url=http%3A%2F%2Fwww.xmisao.com%2F HTTP/1.1
> Host: b.hatena.ne.jp
> User-Agent: hoge
> Accept: */*
> 
< HTTP/1.1 200 OK
< Server: nginx
< Date: Sat, 24 Sep 2016 09:11:38 GMT
< Content-Type: application/json; charset=utf-8
< Content-Length: 376
< Connection: keep-alive
< Set-Cookie: b=$1$o208ls1g$IjliG7R0Cqs4/Z/7lQr6R/; expires=Fri, 19-Sep-2036 09:11:38 GMT; domain=hatena.ne.jp; path=/
< Cache-Control: max-age=1800
< Expires: Sat, 24 Sep 2016 09:41:38 GMT
< X-Content-Type-Options: nosniff
< X-Framework: Ridge/0.11
< X-Ridge-Dispatch: Hatena::Bookmark::Engine::Entry::Jsonlite#default
< X-Runtime: 9ms
< X-View-Runtime: 0ms
< X-Cache: MISS from squid.hatena.ne.jp
< X-Cache-Lookup: HIT from squid.hatena.ne.jp:8080
< Via: 1.1 bookmark2squid10.hatena.ne.jp:8080 (squid/2.7.STABLE6)
< X-Roles: [sd]
< 
* Connection #0 to host b.hatena.ne.jp left intact
{"count":1,"bookmarks":[{"timestamp":"2014/01/28 14:00:14","comment":"","user":"cald","tags":["!personal"]}],"url":"http://www.xmisao.com/","eid":179605530,"title":"\u307a\u3051\u307f\u3055\u304a -- xmisao","screenshot":"http://screenshot.hatena.ne.jp/images/200x150/9/7/4/2/9/b620a4d4f24411fa1d7e19210a4a25dba24.jpg","entry_url":"http://b.hatena.ne.jp/entry/www.xmisao.com/"}
~~~~

成功です。
取得できてしまいました…。

### Rubyだけが失敗するのか

Ruby以外プログラミング言語で、`Python`や`Perl`なら良いのでしょうか。
(このようなUser-Agentを指定するシチュエーションがあるのかは知りませんが…)

~~~~txt
curl --verbose --user-agent 'Python' http://b.hatena.ne.jp/entry/jsonlite/?url=http%3A%2F%2Fwww.xmisao.com%2F
*   Trying 59.106.194.16...
* Connected to b.hatena.ne.jp (59.106.194.16) port 80 (#0)
> GET /entry/jsonlite/?url=http%3A%2F%2Fwww.xmisao.com%2F HTTP/1.1
> Host: b.hatena.ne.jp
> User-Agent: Python
> Accept: */*
> 
< HTTP/1.1 200 OK
< Server: nginx
< Date: Sat, 24 Sep 2016 09:15:13 GMT
< Content-Type: application/json; charset=utf-8
< Content-Length: 376
< Connection: keep-alive
< Set-Cookie: b=$1$UAGYZaf5$W9Xj7PmyFPgVEo4LRqbQx0; expires=Fri, 19-Sep-2036 09:15:13 GMT; domain=hatena.ne.jp; path=/
< Cache-Control: max-age=1800
< Expires: Sat, 24 Sep 2016 09:41:38 GMT
< X-Content-Type-Options: nosniff
< X-Framework: Ridge/0.11
< X-Ridge-Dispatch: Hatena::Bookmark::Engine::Entry::Jsonlite#default
< X-Runtime: 9ms
< X-View-Runtime: 0ms
< X-Cache: HIT from squid.hatena.ne.jp
< X-Cache-Lookup: HIT from squid.hatena.ne.jp:8080
< Via: 1.1 bookmark2squid10.hatena.ne.jp:8080 (squid/2.7.STABLE6)
< X-Roles: [sd]
< 
* Connection #0 to host b.hatena.ne.jp left intact
{"count":1,"bookmarks":[{"timestamp":"2014/01/28 14:00:14","comment":"","user":"cald","tags":["!personal"]}],"url":"http://www.xmisao.com/","eid":179605530,"title":"\u307a\u3051\u307f\u3055\u304a -- xmisao","screenshot":"http://screenshot.hatena.ne.jp/images/200x150/9/7/4/2/9/b620a4d4f24411fa1d7e19210a4a25dba24.jpg","entry_url":"http://b.hatena.ne.jp/entry/www.xmisao.com/"}
~~~~

~~~~txt
curl --verbose --user-agent 'Perl' http://b.hatena.ne.jp/entry/jsonlite/?url=http%3A%2F%2Fwww.xmisao.com%2F
*   Trying 59.106.194.16...
* Connected to b.hatena.ne.jp (59.106.194.16) port 80 (#0)
> GET /entry/jsonlite/?url=http%3A%2F%2Fwww.xmisao.com%2F HTTP/1.1
> Host: b.hatena.ne.jp
> User-Agent: Perl
> Accept: */*
> 
< HTTP/1.1 200 OK
< Server: nginx
< Date: Sat, 24 Sep 2016 09:15:36 GMT
< Content-Type: application/json; charset=utf-8
< Content-Length: 376
< Connection: keep-alive
< Set-Cookie: b=$1$Owv0mqXd$Mui4YgnnD97RjZZwT5Vx40; expires=Fri, 19-Sep-2036 09:15:36 GMT; domain=hatena.ne.jp; path=/
< Cache-Control: max-age=1800
< Expires: Sat, 24 Sep 2016 09:41:38 GMT
< X-Content-Type-Options: nosniff
< X-Framework: Ridge/0.11
< X-Ridge-Dispatch: Hatena::Bookmark::Engine::Entry::Jsonlite#default
< X-Runtime: 9ms
< X-View-Runtime: 0ms
< X-Cache: HIT from squid.hatena.ne.jp
< X-Cache-Lookup: HIT from squid.hatena.ne.jp:8080
< Via: 1.1 bookmark2squid10.hatena.ne.jp:8080 (squid/2.7.STABLE6)
< X-Roles: [sd]
< 
* Connection #0 to host b.hatena.ne.jp left intact
{"count":1,"bookmarks":[{"timestamp":"2014/01/28 14:00:14","comment":"","user":"cald","tags":["!personal"]}],"url":"http://www.xmisao.com/","eid":179605530,"title":"\u307a\u3051\u307f\u3055\u304a -- xmisao","screenshot":"http://screenshot.hatena.ne.jp/images/200x150/9/7/4/2/9/b620a4d4f24411fa1d7e19210a4a25dba24.jpg","entry_url":"http://b.hatena.ne.jp/entry/www.xmisao.com/"}
~~~~

成功です。見事に取得できていますね。
`Ruby`だけがブラックリストのようです。

### 前方一致でRubyだと失敗するのか

`Ruby/2.3.0`で失敗したので、これも失敗するかなと想像しますが、念の為`Rubyist`と指定してみます。

~~~~txt
$ curl --verbose --user-agent 'Rubyist' http://b.hatena.ne.jp/entry/jsonlite/?url=http%3A%2F%2Fwww.xmisao.com%2F
*   Trying 59.106.194.16...
* Connected to b.hatena.ne.jp (59.106.194.16) port 80 (#0)
> GET /entry/jsonlite/?url=http%3A%2F%2Fwww.xmisao.com%2F HTTP/1.1
> Host: b.hatena.ne.jp
> User-Agent: Rubyist
> Accept: */*
> 
< HTTP/1.1 503 Service Temporarily Unavailable
< Server: nginx
< Date: Sat, 24 Sep 2016 09:16:30 GMT
< Content-Type: text/html
< Content-Length: 206
< Connection: keep-alive
< 
<html>
<head><title>503 Service Temporarily Unavailable</title></head>
<body bgcolor="white">
<center><h1>503 Service Temporarily Unavailable</h1></center>
<hr><center>nginx</center>
</body>
</html>
* Connection #0 to host b.hatena.ne.jp left intact
~~~~

失敗しました。
ともかく`Ruby`から始まるとダメなようです。

### 大文字小文字を区別するか

大文字と小文字のバリエーションはどうでしょう。
小文字の`ruby`や大文字の`RUBY`をUser-Agentに指定してみます。

~~~~txt
curl --verbose --user-agent 'ruby' http://b.hatena.ne.jp/entry/jsonlite/?url=http%3A%2F%2Fwww.xmisao.com%2F
*   Trying 59.106.194.16...
* Connected to b.hatena.ne.jp (59.106.194.16) port 80 (#0)
> GET /entry/jsonlite/?url=http%3A%2F%2Fwww.xmisao.com%2F HTTP/1.1
> Host: b.hatena.ne.jp
> User-Agent: ruby
> Accept: */*
> 
< HTTP/1.1 200 OK
< Server: nginx
< Date: Sat, 24 Sep 2016 09:17:20 GMT
< Content-Type: application/json; charset=utf-8
< Content-Length: 376
< Connection: keep-alive
< Set-Cookie: b=$1$vNkC2JYD$Co87nKnGnqETWA9qmm9Yy0; expires=Fri, 19-Sep-2036 09:17:20 GMT; domain=hatena.ne.jp; path=/
< Cache-Control: max-age=1800
< Expires: Sat, 24 Sep 2016 09:41:38 GMT
< X-Content-Type-Options: nosniff
< X-Framework: Ridge/0.11
< X-Ridge-Dispatch: Hatena::Bookmark::Engine::Entry::Jsonlite#default
< X-Runtime: 9ms
< X-View-Runtime: 0ms
< X-Cache: HIT from squid.hatena.ne.jp
< X-Cache-Lookup: HIT from squid.hatena.ne.jp:8080
< Via: 1.1 bookmark2squid10.hatena.ne.jp:8080 (squid/2.7.STABLE6)
< X-Roles: [sd]
< 
* Connection #0 to host b.hatena.ne.jp left intact
{"count":1,"bookmarks":[{"timestamp":"2014/01/28 14:00:14","comment":"","user":"cald","tags":["!personal"]}],"url":"http://www.xmisao.com/","eid":179605530,"title":"\u307a\u3051\u307f\u3055\u304a -- xmisao","screenshot":"http://screenshot.hatena.ne.jp/images/200x150/9/7/4/2/9/b620a4d4f24411fa1d7e19210a4a25dba24.jpg","entry_url":"http://b.hatena.ne.jp/entry/www.xmisao.com/"}
~~~~

~~~~txt
$ curl --verbose --user-agent 'RUBY' http://b.hatena.ne.jp/entry/jsonlite/?url=http%3A%2F%2Fwww.xmisao.com%2F
*   Trying 59.106.194.17...
* Connected to b.hatena.ne.jp (59.106.194.17) port 80 (#0)
> GET /entry/jsonlite/?url=http%3A%2F%2Fwww.xmisao.com%2F HTTP/1.1
> Host: b.hatena.ne.jp
> User-Agent: RUBY
> Accept: */*
> 
< HTTP/1.1 200 OK
< Server: nginx
< Date: Sat, 24 Sep 2016 09:26:02 GMT
< Content-Type: application/json; charset=utf-8
< Content-Length: 376
< Connection: keep-alive
< Set-Cookie: b=$1$PYOYR6EY$B7AdwIQa5p6xsIVaN1UyD0; expires=Fri, 19-Sep-2036 09:26:02 GMT; domain=hatena.ne.jp; path=/
< Cache-Control: max-age=1800
< Expires: Sat, 24 Sep 2016 09:41:38 GMT
< X-Content-Type-Options: nosniff
< X-Framework: Ridge/0.11
< X-Ridge-Dispatch: Hatena::Bookmark::Engine::Entry::Jsonlite#default
< X-Runtime: 9ms
< X-View-Runtime: 0ms
< X-Cache: HIT from squid.hatena.ne.jp
< X-Cache-Lookup: HIT from squid.hatena.ne.jp:8080
< Via: 1.1 bookmark2squid10.hatena.ne.jp:8080 (squid/2.7.STABLE6)
< X-Roles: [sd]
< 
* Connection #0 to host b.hatena.ne.jp left intact
{"count":1,"bookmarks":[{"timestamp":"2014/01/28 14:00:14","comment":"","user":"cald","tags":["!personal"]}],"url":"http://www.xmisao.com/","eid":179605530,"title":"\u307a\u3051\u307f\u3055\u304a -- xmisao","screenshot":"http://screenshot.hatena.ne.jp/images/200x150/9/7/4/2/9/b620a4d4f24411fa1d7e19210a4a25dba24.jpg","entry_url":"http://b.hatena.ne.jp/entry/www.xmisao.com/"}
~~~~

成功しました。
大文字と小文字の区別があり、やはり`Ruby`だけが弾かれているようです。

### 本当にRubyがブラックリストなのか

先頭3文字の`Rub`だとどうでしょう。

~~~~txt
curl --verbose --user-agent 'Rub' http://b.hatena.ne.jp/entry/jsonlite/?url=http%3A%2F%2Fwww.xmisao.com%2F
*   Trying 59.106.194.16...
* Connected to b.hatena.ne.jp (59.106.194.16) port 80 (#0)
> GET /entry/jsonlite/?url=http%3A%2F%2Fwww.xmisao.com%2F HTTP/1.1
> Host: b.hatena.ne.jp
> User-Agent: Rub
> Accept: */*
> 
< HTTP/1.1 200 OK
< Server: nginx
< Date: Sat, 24 Sep 2016 09:18:17 GMT
< Content-Type: application/json; charset=utf-8
< Content-Length: 376
< Connection: keep-alive
< Set-Cookie: b=$1$mv1V9A7X$/ANkbiveBGedQcNHraCuB/; expires=Fri, 19-Sep-2036 09:18:17 GMT; domain=hatena.ne.jp; path=/
< Cache-Control: max-age=1800
< Expires: Sat, 24 Sep 2016 09:41:38 GMT
< X-Content-Type-Options: nosniff
< X-Framework: Ridge/0.11
< X-Ridge-Dispatch: Hatena::Bookmark::Engine::Entry::Jsonlite#default
< X-Runtime: 9ms
< X-View-Runtime: 0ms
< X-Cache: HIT from squid.hatena.ne.jp
< X-Cache-Lookup: HIT from squid.hatena.ne.jp:8080
< Via: 1.1 bookmark2squid10.hatena.ne.jp:8080 (squid/2.7.STABLE6)
< X-Roles: [sd]
< 
* Connection #0 to host b.hatena.ne.jp left intact
{"count":1,"bookmarks":[{"timestamp":"2014/01/28 14:00:14","comment":"","user":"cald","tags":["!personal"]}],"url":"http://www.xmisao.com/","eid":179605530,"title":"\u307a\u3051\u307f\u3055\u304a -- xmisao","screenshot":"http://screenshot.hatena.ne.jp/images/200x150/9/7/4/2/9/b620a4d4f24411fa1d7e19210a4a25dba24.jpg","entry_url":"http://b.hatena.ne.jp/entry/www.xmisao.com/"}
~~~~

成功しました。
`Ruby`という文字列だけがブラックリストに入っているような挙動です。

### 前方一致なのか部分一致か

`Ruby`がブラックリストだとして、前方一致なのか部分一致なのかが気になってきます。

はてなに想いを伝えるため`I love Ruby`ではどうでしょうか。

~~~~txt
curl --verbose --user-agent 'I love Ruby' http://b.hatena.ne.jp/entry/jsonlite/?url=http%3A%2F%2Fwww.xmisao.com%2F
*   Trying 59.106.194.16...
* Connected to b.hatena.ne.jp (59.106.194.16) port 80 (#0)
> GET /entry/jsonlite/?url=http%3A%2F%2Fwww.xmisao.com%2F HTTP/1.1
> Host: b.hatena.ne.jp
> User-Agent: I love Ruby
> Accept: */*
> 
< HTTP/1.1 200 OK
< Server: nginx
< Date: Sat, 24 Sep 2016 09:19:39 GMT
< Content-Type: application/json; charset=utf-8
< Content-Length: 376
< Connection: keep-alive
< Set-Cookie: b=$1$lzELDScH$OYLKvbUBCzb.KL847Lltm.; expires=Fri, 19-Sep-2036 09:19:39 GMT; domain=hatena.ne.jp; path=/
< Cache-Control: max-age=1800
< Expires: Sat, 24 Sep 2016 09:41:38 GMT
< X-Content-Type-Options: nosniff
< X-Framework: Ridge/0.11
< X-Ridge-Dispatch: Hatena::Bookmark::Engine::Entry::Jsonlite#default
< X-Runtime: 9ms
< X-View-Runtime: 0ms
< X-Cache: HIT from squid.hatena.ne.jp
< X-Cache-Lookup: HIT from squid.hatena.ne.jp:8080
< Via: 1.1 bookmark2squid10.hatena.ne.jp:8080 (squid/2.7.STABLE6)
< X-Roles: [sd]
< 
* Connection #0 to host b.hatena.ne.jp left intact
{"count":1,"bookmarks":[{"timestamp":"2014/01/28 14:00:14","comment":"","user":"cald","tags":["!personal"]}],"url":"http://www.xmisao.com/","eid":179605530,"title":"\u307a\u3051\u307f\u3055\u304a -- xmisao","screenshot":"http://screenshot.hatena.ne.jp/images/200x150/9/7/4/2/9/b620a4d4f24411fa1d7e19210a4a25dba24.jpg","entry_url":"http://b.hatena.ne.jp/entry/www.xmisao.com/"}
~~~~

成功です。
部分一致ではなく、前方一致で弾いているようです。

# まとめ

これまでにわかったことをまとめます。

|User-Agent   |結果     |
|:-           |:-       |
|なし         |失敗(503)|
|`Ruby/2.3.0` |失敗(503)|
|`curl/7.47.0`|成功(200)|
|`Ruby`       |失敗(503)|
|`Perl`       |成功(200)|
|`Python`     |成功(200)|
|`Rubyist`    |失敗(503)|
|`ruby`       |成功(200)|
|`RUBY`       |成功(200)|
|`Rub`        |成功(200)|
|`I love Ruby`|成功(200)|
{: .table .table-striped}

これ以上深入りするのはやめますが、この結果を眺める限り、はてなブックマークエントリー情報取得APIが`503`を返す条件は、以下のOR条件であるように思われます。

* User-Agentが指定されていない
* User-Agentが`Ruby`という文字列に前方一致する

はてなはRubyに何か恨みでもあるのでしょうか。

はてなブックマークエントリー情報取得APIにアクセスする時には、Webページをスクレイピングする時と同じように、一般的なUser-Agentを偽装しておいた方が良いのかも知れません。
今回は`Ruby`だけしか確認できていませんが、他のありがちなUser-Agentも、ブラックリストに入っている可能性もあります。

なお、同じはてなのAPIでも[はてなスターカウントAPI](http://developer.hatena.ne.jp/ja/documents/star/apis/count)では、User-Agentのチェック自体がないようなので、はてなのAPIが全般的に同じ挙動というわけでもないようです。
