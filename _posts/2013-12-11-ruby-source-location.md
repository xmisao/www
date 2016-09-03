---
layout: blog
title: Rubyでメソッドの定義場所を取得する方法
tag: ruby
---



gemを使っていたり、扱っているソースが大規模だったりする時に、メソッドの定義場所を調査したい場合がある。
Rubyには`Proc#source_location`で、メソッドの定義場所を取得することができる。
使い方は簡単で、調査対象のメソッドをいったん`Method`オブジェクトに変換し、`source_location`メソッドを呼びだせば良い。

例えば標準添付ライブラリの`open-uri`は`Kernel#open`を再定義することで、URIを直接`open`することを可能にする。
この時に`Kernel#open`の実体がどこで定義されているのか調べてみよう。
以下のコードのとおり、`Kernel#open`は`open-uri`の27行目で再定義されていることが確認できる。

~~~~
require 'open-uri'
method = Kernel.method(:open) # Kernel#openのMethodオブジェクトの取得
p method.source_location # => ["/usr/lib/ruby/1.9.1/open-uri.rb", 27]
~~~~

`source_location`の使い方については、パーフェクトRubyの6-1-1のコラムとして簡単な解説が掲載されている。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4774158798/xmisao-22/ref=nosim/" name="amazletlink" target="_blank"><img src="http://ecx.images-amazon.com/images/I/51K0jUf%2BiEL._SL160_.jpg" alt="パーフェクトRuby (PERFECT SERIES 6)" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4774158798/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">パーフェクトRuby (PERFECT SERIES 6)</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 13.12.01</div></div><div class="amazlet-detail">Rubyサポーターズ すがわら まさのり 寺田 玄太郎 三村 益隆 近藤 宇智朗 橋立 友宏 関口 亮一 <br />技術評論社 <br />売り上げランキング: 10,788<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4774158798/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>
