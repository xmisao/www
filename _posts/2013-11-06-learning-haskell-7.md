---
layout: blog
title: もしRubyistがHaskellを学んだら(7)
tag: learning_haskell
---

# もしRubyistがHaskellを学んだら(7)

今日はリストの合計を求める関数を書くことにする。Rubyで書くと以下のようなイメージ。

~~~~
def sum(list)
	s = 0
	list.each{|v|
		s += v
	}
	s
end

puts sum [1, 2, 3]
~~~~

Rubyではイテレータeachを使って合計を求めるが、Haskellでは再帰を使って合計を計算する。

リストの合計を計算する関数を、ここでは`mysum`としよう。

リストの合計なので、この関数は数値のリストを受け取り、数値を返す。ただし、この関数は2パターンの値の返し方がある。リストが空の場合と、リストが空でない場合だ。

リストが空であれば0を返す。リストが空でなければ、リストの先頭の値と、リストの残りを`mysum`した値を加算して返す。後者が`mysum`の再帰呼び出しだ。これをHaskellで書き下すと以下のようになる。

~~~~
mysum [] = 0
mysum (x : xs) = x + mysum(xs)
~~~~

これにリストを渡して、結果を出力する`main`を書く。プログラムの全容と実行結果は以下のとおりだ。

~~~~
mysum [] = 0
mysum (x : xs) = x + mysum(xs)

main = print $ mysum [1, 2, 3]
~~~~

~~~~
6
~~~~

話題とは外れるが、最近は`print`で以下のようなエラーが出た時に、`$`を書くとコンパイルが通るようになることがわかった。これもIOモナド絡みのようだ。これでうまく行く理由は、明日以降調べる…。

~~~~
mysum.hs:4:8:
    The function `print' is applied to two arguments,
    but its type `a0 -> IO ()' has only one
    In the expression: print mysum [1, 2, 3]
    In an equation for `main': main = print mysum [1, 2, 3]
~~~~
