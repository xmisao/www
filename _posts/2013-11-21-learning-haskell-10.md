---
layout: blog
title: もしRubyistがHaskellを学んだら(10) リスト内包表記
tag: learning_haskell
---

# もしRubyistがHaskellを学んだら(10) リスト内包表記

今日はリスト内包表記の生成器とガードを使う。
ある数を指定すると、ある数の約数のリストを返す関数を書く。
Rubyで書くと以下のイメージのコードをHaskellで実装してみよう。

~~~~
n = 15
factors = []
(1..n).each{|x|
	factors << x if n % x == 0
}
puts factors
~~~~

とりあえず`factors`関数は、整数を受け取り整数のリストを返す。よって型は以下のとおり。

~~~~
factors :: Int -> [int]
~~~~

まずは生成器を使って1からnまでのリストを作るようにする。

~~~~
factors n = [x | x <- [1..n]]
~~~~

これに更にガードをつけて、nがxで割り切れる数値のみのリストを作るようにする。これで約数のリストができる。

~~~~
factors n = [x | x <- [1..n], n `mod` x == 0]
~~~~

`factors`関数の呼び出しと、表示まで通して書くと以下のとおり。
これを実行すると15の約数が表示される。

~~~~
factors :: Int -> [Int]
factors n = [x | x <- [1..n], n `mod` x == 0]

main = do
	print $ factors 15
~~~~

~~~~
[1,3,5,15]
~~~~
