---
layout: blog
title: tumblr_clientでTumblrに画像を投稿する方法
tag: ruby tumblr
---

# tumblr_clientでTumblrに画像を投稿する方法

昨日のエントリ[RubyでTumblrにアクセスする(tumblr_client)](http://www.xmisao.com/2013/10/06/ruby-tumblr-client.html)では、`tumblr_client`の使い方を簡単に説明した。続いて、今日はtumblrに画像を投稿してみよう。

テキストの投稿は`text()`で行ったが、画像の投稿は`photo()`を使う。`photo()`を使う場合は、ローカルのファイルをアップロードする方法と、ネットで公開されている画像を取り込ませる2通りの方法がある。

## ローカルのファイルをアップロードする

まずローカルのファイルをTumblrにアップロードしたい場合だ。この場合、`photo()`のハッシュ引数に、キーに`:data`を、値に画像へのパス指定した要素を渡してやる。例は下記のとおりで、*/path/to/photo.jpg*がアップロードされる。

~~~~
require 'tumblr_client'

Tumblr.configure do |config|
	config.consumer_key = "ABC..."
	config.consumer_secret = "DEF..."
	config.oauth_token = "GHI..."
	config.oauth_token_secret = "JKL..."
end

client = Tumblr::Client.new
client.photo("hogehoge.tumblr.com", {:data => '/path/to/photo.jpg', :caption => "Hello, World!"})
~~~~

## ネットで公開されている画像を取り込ませる

次にネットで公開されている画像をTumblrに取り込みたい場合だ。`photo()`のハッシュ引数に、今度はキーに`:source`を、値に画像へのURLを指定した要素を渡してやる。以下の例では*http://www-2.cs.cmu.edu/~chuck/lennapg/lena_std.tif*がTumblrに取り込まれる。余談だが、この画像はかの有名なレナのものだ。

~~~~
require 'tumblr_client'

Tumblr.configure do |config|
	config.consumer_key = "ABC..."
	config.consumer_secret = "DEF..."
	config.oauth_token = "GHI..."
	config.oauth_token_secret = "JKL..."
end

client = Tumblr::Client.new
client.photo("hogehoge.tumblr.com", {:source => 'http://www-2.cs.cmu.edu/~chuck/lennapg/lena_std.tif', :caption => "433eros"})
~~~~
