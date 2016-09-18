---
layout: blog
title: もしRubyistがHaskellを学んだら(17) letとwhere
tag: learning_haskell
---



再びHaskellでの実装を念頭に置いてRubyで実装したプログラムをHaskellで書き下すスタイルで勉強してみる。今回は円柱の体積の計算を通じて、Haskelの`let`と`where`について見ていく。

いささか無理のある例ではあるが、半径と高さがわかっているたくさんの円柱の体積を求める必要があるとする。Rubyで実装すると以下のプログラムが1つの答えになる。

~~~~
def cylinderVolumes(cylinders)
	def volume(radius, height)
		pi = 3.14
		radius ** 2  * pi * height
	end

	cylinders.map{|cylinder|
		r = cylinder[0]
		h = cylinder[1]
		volume(r, h)
	}
end

p cylinderVolumes [[1.0, 1.0], [2.5, 1.0], [2.5, 2.5]]
~~~~

Rubyにはタプルは存在しないので、2要素のリストを便宜的に円柱の半径と高さを保持した要素としよう。この要素のリストが体積を求めたい円柱の一覧である。

これをHaskellで実装する。Haskellでは局所関数や変数の定義に`let`や`where`を用いる。今回は双方のパターンで実装することにする。

いずれの例も、円周率を示す局所変数`pi`と、円柱の体積を計算する局所関数`volume`を定義する。Haskellにはタプルが存在するので、円柱の半径と幅はタプルに格納し、計算を行う`cylinderVolumes`関数はそのリストを受け取るようにする。

~~~~
cylinderVolumes :: [(Double, Double)] -> [Double]
cylinderVolumes xs = [volume r h | (r, h) <- xs, let pi = 3.14 ; volume radius height = radius ^ 2 * pi * height]
~~~~

~~~~
cylinderVolumes :: [(Double, Double)] -> [Double]
cylinderVolumes xs = [volume r h | (r, h) <- xs]
	where pi = 3.14
	      volume radius height = radius ^ 2 * pi * height
~~~~

あとは`main`から`cylinderVolumes`を呼び出してやれば、円柱の体積を求めることができる。GHCiからこれらのプログラムをロードして実行させてみよう。

~~~~
*Main> cylinderVolume [(1.0, 1.0), (1.0, 2.5), (2.5, 2.5)]
[3.14,7.8500000000000005,49.0625]
~~~~

さて、今回のテーマは`let`と`where`だが、その違いはHaskell初心者にはなかなかに難しい。ポイントとしては以下のようである。

- `let`は式であり、`where`は式ではない
- `where`のスコープは局所的でなく関数定義のガードを跨いで使うことができる

"すごいHaskellたのしく学ぼう!"の3章には以下の記載がある。むむむむむ。結局は適材適所で使い分け?(逃げた)

> はじめのうちは、`let`は束縛を先に書いて式を後に書くけど`where`はその逆という違いしかないように思えるかも知れません。	
> 本当の違いは、`let`式はその名のとおり「式」で、`where`節はそうじゃない、というところです。
> (中略)
> つまり、let式は次のようにコード中のほとんどどんな場所でも使えるということです。
> ghci > 4 * (let a = 9 in a + 1) + 2
> 42
> (中略)
> また、関数の前ではなく後ろで部品を定義するのが好きだから`where`を使うという人もいます。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4274068854/xmisao-22/ref=nosim/" name="amazletlink" target="_blank"><img src="https://images-fe.ssl-images-amazon.com/images/I/51P6NdS4IGL._SL160_.jpg" alt="すごいHaskellたのしく学ぼう!" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4274068854/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">すごいHaskellたのしく学ぼう!</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 14.01.09</div></div><div class="amazlet-detail">Miran Lipovača <br />オーム社 <br />売り上げランキング: 126,678<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4274068854/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>
