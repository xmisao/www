---
layout: blog
title: RubyでTumblrにアクセスする
tag: ruby
---

# RubyでTumblrにアクセスする

RubyでTumblrにアクセスするライブラリにはいくつかあるが、どれもあまり使われていない状況だ。その中で`tumblr_client`というGemがメジャーで、Tumblrによる解説でも使われている。このエントリでは`tumblr_client`を使って、Tumblrへの投稿と、ダッシュボードの取得をしてみることにする。

## 初期化

トークン等、Tumblrにアクセスするために必要な要素は、事前に取得してあるものとする。それらの要素は`Tumblr.config`で以下のように設定する。

~~~~
Tumblr.configure do |config|
	config.consumer_key = "ABC..."
	config.consumer_secret = "DEF..."
	config.oauth_token = "GHI..."
	config.oauth_token_secret = "JKL..."
end
~~~~

設定を終えた上で`Tumblr::Client`を生成しよう。Tumblrへのアクセスはすべてこのオブジェクトを通じて行う。

~~~~
Tumblr::Client.new()
~~~~

## ダッシュボードの取得

Tumblrにアクセスしてする目に入るダッシュボードを取得してみよう。
ダッシュボードへのアクセスは、`dashboard()`を使って行う。
APIの結果はJSONなので、このメソッドの返却値は、JSONのパース結果がHashとArrayで構成されている。`posts`以下にポストのリストが入っている。
以下のコードでダッシュボードのポストが丸々取得できるはずだ。

~~~~
client = Tumblr::Client.new
pp client.dashboard["posts"]
~~~~

Tumblrのポストにはテキストや画像などいくつか種類がある。
取得後に振り分けても良いが、例えばテキストだけ欲しい場合は、`dashboard()`の引数でポストのタイプを指定して取得することもできる。

~~~~
client = Tumblr::Client.new
pp client.dashboard(:type => 'text')["posts"]
~~~~

## Tumblrへの投稿

Tumblrに投稿するには`text()`をはじめ、ポストの種類ごとに用意された各種メソッドを利用する。最も簡単なテキストポストをしてみることにしよう。`text()`に渡す引数は、投稿対象のブログと、投稿内容だ。以下では'hogehoge.tumblr.com'というブログに、タイトルが'hoge'で、本文が'piyo'の投稿をする。

~~~~
client = Tumblr::Client.new
client.text("hogehoge.tumblr.com", {:title => 'hoge', :body => 'piyo'})
~~~~

実行した後は自分のダッシュボードを確認してみよう。自分の投稿したポストが表示されているはずだ。
