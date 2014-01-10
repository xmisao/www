---
layout: blog
title: もしRubyistがHaskellを学んだら(11) シーザー暗号
tag: learning_haskell
---

# もしRubyistがHaskellを学んだら(11) シーザー暗号

今日はシーザー暗号を実装する。
シーザー暗号はアルファベットをある数だけずらした別のアルファベットに書き換える暗号だ。
Rubyで実装すると以下のイメージのプログラムを、Haskellで実装してみることにする。

~~~~
def chr2int(c)
	c.ord - 'a'.ord
end

def int2chr(i)
	(i + 'a'.ord).chr
end

def caesar(str, x)
	result = ""
	str.each_char{|c|
		result << int2chr((chr2int(c) + x) % 26)
	}
	result
end

puts caesar("abc", 3)
~~~~

Haskellで文字から数値への変換は`ord`を、逆に数値から文字への変換は`chr`関数で行う。これらの関数を使用できるようにするため、まず`Data.Char`をインポートしておく。

~~~~
import Data.Char
~~~~

Haskellにおいて文字列は文字のリストである。リストなので、リスト内包表記を使って、文字列から別のリストや文字列を作ることができる。ひとまず文字列を数値のリストに変換して表示してみることにする。

~~~~
import Data.Char
main = print $ [ord c | c <- "abc"]
~~~~

~~~~
[97,98,99]
~~~~

文字'a'から'z'を、0から25の数値に変換する`chr2int`関数を定義する。
また逆に0から25の数値を、`a`から`z`に変換する`int2chr`関数も定義する。

~~~~
chr2int :: Char -> Int
chr2int c = ord c - ord 'a'

int2chr :: Int -> Char
int2chr i = chr (i + ord 'a')
~~~~

続いて文字列と整数を受け取り、文字列を整数の分だけずらして、シーザー暗号化する`caesar`関数を定義する。

~~~~
caesar :: String -> Int -> String
caesar s x = [int2chr ((chr2int c) + x) | c <- s]
~~~~

通して書くと以下のとおりだ。
ようやくHaskellでプログラムらしいプログラムを書けた気がする。

~~~~
import Data.Char

chr2int :: Char -> Int
chr2int c = ord c - ord 'a'

int2chr :: Int -> Char
int2chr i = chr (i + ord 'a')

caesar :: String -> Int -> String
caesar s x = [int2chr ((chr2int c) + x) | c <- s]

main = print $ (caesar "abc" 3)
~~~~

~~~~
"def"
~~~~
