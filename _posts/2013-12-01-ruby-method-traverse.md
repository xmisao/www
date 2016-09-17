---
layout: blog
title: 継承とincludeおよび特異クラスによるRubyのメソッド探索順序
tag: ruby
---



![Ruby Method Traverse](/assets/2013_12_01_ruby_method_traverse.png)

継承とincludeおよび特異クラスが組み合わさった場合のRubyのメソッド探索順序は図中の番号のとおりだ。

`Clazz`はユーザが定義した親クラス、`InheritClazz`は`Clazz`を継承したクラス、`InheritClazz`は`Module1`と`Module2`をincludeする。
このクラス図ではincludeの結果、実際には現れない中間クラス`(InheritClazz1)`と`(InheritClazz2)`が生成されることにしている。
さらにこの`InheritClazz`に特異メソッド`method`を定義した結果生成される特異クラスを`SingletonInheritClazz`とする。

文章で説明するとややこしくなってしまうが、ポイントを説明するとRubyでは以下1.から4.の順番でメソッドが探索され実行される。

1. オブジェクトが特異クラスのインスタンスなら特異クラスで定義されたメソッドが呼ばれる
2. クラスで定義したメソッドはincludeしたメソッドをオーバーライドする
3. includeは後ろでインクルードしたModuleが前のModuleのメソッドをオーバーライドする
4. 以上の条件に合致するメソッドがなければ継承元を再帰的に探索したメソッドが合致する

以下のコードと実行結果を見るとわかりやすい。
以下のコードでは、同名のメソッドが探索される順に`puts`で番号を出力した後、`super`で上位のメソッドを呼び出している。結果として標準出力には1から5が順に出力される。

~~~~
# 親クラス
class Clazz
	def method
		puts '5'
	end
end

# モジュール1
module Module1
	def method
		puts '4'
		super
	end
end

# モジュール2
module Module2
	def method
		puts '3'
		super
	end
end

# InheritClazzはClazzを継承しModule1とModule2をインクルードする
class InheritClazz < Clazz
	include Module1
	include Module2
	def method
		puts '2'
	super
	end
end

# InheritClazzのインスタンス生成
object = InheritClazz.new

# 特異メソッド定義
def object.method
	puts '1'
	super
end

object.method
~~~~

~~~~
1
2
3
4
5
~~~~

メソッドの探索順序については、パーフェクトRubyの6-4が詳しい。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4774158798/xmisao-22/ref=nosim/" name="amazletlink" target="_blank"><img src="https://images-fe.ssl-images-amazon.com/images/I/51K0jUf%2BiEL._SL160_.jpg" alt="パーフェクトRuby (PERFECT SERIES 6)" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4774158798/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">パーフェクトRuby (PERFECT SERIES 6)</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 13.12.01</div></div><div class="amazlet-detail">Rubyサポーターズ すがわら まさのり 寺田 玄太郎 三村 益隆 近藤 宇智朗 橋立 友宏 関口 亮一 <br />技術評論社 <br />売り上げランキング: 10,788<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4774158798/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>
