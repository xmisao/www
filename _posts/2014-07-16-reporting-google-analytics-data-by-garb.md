---
layout: blog
title: garbを使ってRubyでGoogle Analyticsのデータを取得する
tag: ruby
---

# garbを使ってRubyでGoogle Analyticsのデータを取得する

## garbについて

[garb](https://github.com/Sija/garb)はGoogle Analytics APIのRubyラッパだ。
garbを使えばGoogle AnalyticsにRubyでアクセスしてデータを取得することができる。
Google Analyticsのデータに対して独自の集計などを行いたい場合に便利だろう。

なお公式ページに書かれているとおりgarbより活発に開発されている同様のGemに[legato](https://github.com/tpitale/legato)がある。
これからGoogle AnalyticsにRubyでアクセスしたい場合はこちらを使っても良いだろう。
ただREADMEに書かれている内容からすると、さほど機能的には変わらないように見える。
今回は日本語でも情報が豊富なgarbを使う。

## garbの日本語情報

garbについては日本語でもREADMEレベルの情報がいくつかあるのを見つけた。
以下にリンクを列挙するので、基本的な使い方についてはそちらを参照。

- [Google Analyticsデータ取得Gem「Garb」の使い方 ](http://tsuchikazu.net/googel_analytics_gar/)
- [rubyのGoogleアナリティクスAPI用ラッパーライブラリ「garb」が面白い](http://web-analytics-or-die.org/2011/12/garb/)
- [Google AnalyticsのデータをRubyで取得 ](http://mn-memo.com/archives/894)
- [Google Analyticsデータ取得gemライブラリ「Garb」](http://d.hatena.ne.jp/deeeki/20110626/google_analytics_garb)
- [Ruby で Google Analytics から直近1時間のページビューランキングを取得する方法](http://tilfin.hatenablog.com/entry/20120905/1346807962)

## サンプルコード

以下はgarbを使ってGoogle Analyticsからあるプロファイルのページ毎のページビューを取得する例である。

~~~~ruby
require 'garb'
require 'date'
require 'pp'

Garb::Session.login(username, password)
profile = Garb::Management::Profile.all.detect {|p| p.web_property_id == 'UA-XXXXXXX-X'}
class Pageviews
  extend Garb::Model

  metrics :pageviews
  dimensions :page_path
end
pp profile.pageviews(:start_date => Date.new(2014, 6, 1), :end_date => Date.new(2014, 6, 30))
~~~~

## レポートクラス

garbの使い方でポイントとなるのはレポートクラスの定義だ。
上記の例では`Pageviews`クラスの定義がそれである。

レポートクラスで指定するのは取得するデータのディメンションと指標(メトリック)である。
指定できるディメンションと指標は[Google AnalyticsのAPIドキュメント](https://developers.google.com/analytics/devguides/reporting/core/dimsmets)で調べることができる。
ディメンションと指標はシンボルで指定するため、キャメルケースをスネークケースにして、また大文字はすべて小文字にして、実際の名前を読み替えてやる必要がある。

ディメンションと指標はどちらもGoogle Analyticsの概念なので、前提知識がないと少々使いこなすのが難しい。
本エントリではページビューを題材に、どのようなレポートクラスを定義すれば、どのようなデータが取得できるのかを、具体的に見ていくことにする。

## サイト全体のページビューを取得する

最もシンプルな例を見てみよう。
レポートクラスで指標は必須だが、ディメンションは無くても構わない。
以下はサイト全体のページビューを取得する例である。

~~~~ruby
class Pageviews
  extend Garb::Model

  metrics :pageviews
end
~~~~

戻り値の例は以下のようになる。
サイト全体のページビューが1レコードだけ返却される。

~~~~
#<Garb::ResultSet:0x00000001d39b58
 @results=[#<OpenStruct pageviews="31648">],
 @sampled=false,
 @total_results=1>
~~~~

## ページ毎のページビューを取得する

続いてディメンションを指定してみよう。
ディメンションとしてページのURLである`:page_path`を指定する。
するとページのURL毎にページビューを取得できるようになる。

~~~~ruby
class Pageviews
  extend Garb::Model

  metrics :pageviews
  dimensions :page_path
end
~~~~

戻り値はURLの分だけレコードが返される。
以下の例では402レコードとなった。

~~~~
#<Garb::ResultSet:0x00000001aeb6f8
 @results=
  [#<OpenStruct page_path="/", pageviews="52">,
   #<OpenStruct page_path="/2012/10/23/amazons3-with-wwwizer.html", pageviews="3">,
   #<OpenStruct page_path="/2012/10/23/git-config-user-email.html", pageviews="1">],
 @sampled=false,
 @total_results=402>
~~~~

## ページ毎にページビューとセッション数を取得する

指標を追加して取得するデータを増やしてみよう。
ページビューだけではなく、セッション数も取得する。
`metrics`に複数のシンボルを与えてやるだけで良い。

~~~~ruby
class Pageviews
  extend Garb::Model

  metrics :pageviews, :sessions
  dimensions :page_path
end
~~~~

上記の戻り値に加えて各レコードにセッション数が含まれていることがわかる。

~~~~
#<Garb::ResultSet:0x00000001b88b10
 @results=
  [#<OpenStruct page_path="/", pageviews="52", sessions="40">,
   #<OpenStruct page_path="/2012/10/23/amazons3-with-wwwizer.html", pageviews="3", sessions="3">,
   #<OpenStruct page_path="/2012/10/23/git-config-user-email.html", pageviews="1", sessions="1">],
 @sampled=false,
 @total_results=402>
~~~~

## ページ毎に日付毎にページビューとセッション数を取得する

更にディメンションを追加するとどうなるだろうか。
ディメンションが増えるとディメンションの値の組み合わせでレコード数が増える。

~~~~ruby
class Pageviews
  extend Garb::Model

  metrics :pageviews, :sessions
  dimensions :page_path, :date
end
~~~~

戻り値には更に日付が含まれるようになった。
レコード数はURLと日付の組み合わせで4836件まで増えた。

#<Garb::ResultSet:0x000000024a5838
 @results=
  [#<OpenStruct page_path="/", date="20140601", pageviews="2", sessions="1">,
   #<OpenStruct page_path="/", date="20140602", pageviews="2", sessions="1">,
   #<OpenStruct page_path="/", date="20140603", pageviews="1", sessions="0">],
 @sampled=false,
 @total_results=4836>
~~~~

## まとめ

本エントリではRubyでGoogle Analyticsのデータを取得するGemであるgarbを紹介した。
またgarbではレポートクラスの定義により取得するデータを指定することを説明し、
ディメンションと指標の組み合わせと取得できるデータについて具体例を述べた。

プログラムが書ける人であればGoogle Analyticsのデータを自在に分析することができるだろう。
私もちょっとgarbでプログラムを書いて好みの集計をさせている。
garbのお陰で今まで以上にGoogle Analyticsが便利なものとなった。
