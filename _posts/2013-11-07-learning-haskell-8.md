---
layout: blog
title: もしRubyistがHaskellを学んだら(8) ガード式による関数定義
tag: learning_haskell
---

# もしRubyistがHaskellを学んだら(8) ガード式による関数定義

今日はHaskellでガード式を使った関数を定義してみることにした。ガード式を使って絶対値を求める関数を定義し、入力した値の絶対値を表示するプログラムを書く。Rubyで書き下すと以下を目標にする。

~~~~
def abs v
	if v >= 0
		v
	else
		v * -1
	end
end

v = gets.to_i
puts v
~~~~

Haskellではガード式を使って関数を定義することができる。ガード式はifの強化版のようなものだ。ガード式は`|`で並べて書く。以下は`n`が0以上なら`n`を、そうでなければ`-n`を返す関数だ。

~~~~
myabs n | n >= 0 = n
        | otherwise = -n
~~~~

入力値を受け取って数値に変換し、`myabs`で絶対値を求めて表示する一連のプログラムは以下のとおりだ。ガード式以外はこれまでの勉強の積み重ねでスムーズに書くことができた。

~~~~
myabs n | n >= 0 = n
        | otherwise = -n

main = do
	s <- getLine
	let v = read s :: Int
	print (myabs v)
~~~~
