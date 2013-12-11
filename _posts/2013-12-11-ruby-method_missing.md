---
layout: blog
title: Rubyのmethod_missingの基本的な使い方
tag: ruby
---

# Rubyのmethod_missingの基本的な使い方

Rubyでは、定義されていないメソッドが呼び出された場合、通常は`NoMethodError`が発生する。

Rubyはメソッドが呼び出された際に、メソッドが定義されているか親クラスを順に探索し、もしメソッドが定義されていなければ`method_missing`メソッドを呼び出す。
この`method_missing`をオーバーライドしてやることにより、実際には定義していないメソッドの呼び出しをフックして処理を行うことができる。

一例として、`method_missing`を使ったクラスを定義してみよう。
クラス`Clazz`は何のメソッドの実装も持たないが、`method_missing`メソッドをオーバーライドしている。
これで`Clazz`はあらゆるメソッドに対して、呼び出されたメソッド名と、その引数を標準出力に出力するようになる。

~~~~
class Clazz
	def method_missing(name, *args)
		puts "Method #{name} was called with #{args.map{|a| a.inspect}.join(',')}"
	end
end

clazz = Clazz.new
clazz.hoge('foo', 'bar', 'buz') # => Method hoge was called with "foo","bar","buz"
~~~~

`method_missing`を使ったテクニックは、メタプログラミングで良く利用されており、著名なgemのソースコードでも頻繁に利用されている。柔軟なコードを書くためにもぜひ覚えておきたい。ただ、過剰な使用はコードの可読性を損ねるので、悩ましいところである。

なおRubyの`method_missing`については、パーフェクトRubyの7-2が詳しい。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4774158798/xmisao-22/ref=nosim/" name="amazletlink" target="_blank"><img src="http://ecx.images-amazon.com/images/I/51K0jUf%2BiEL._SL160_.jpg" alt="パーフェクトRuby (PERFECT SERIES 6)" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4774158798/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">パーフェクトRuby (PERFECT SERIES 6)</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 13.12.01</div></div><div class="amazlet-detail">Rubyサポーターズ すがわら まさのり 寺田 玄太郎 三村 益隆 近藤 宇智朗 橋立 友宏 関口 亮一 <br />技術評論社 <br />売り上げランキング: 10,788<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4774158798/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>
