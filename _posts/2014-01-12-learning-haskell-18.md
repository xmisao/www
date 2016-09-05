---
layout: blog
title: もしRubyistがHaskellを学んだら(18) FizzBuzz問題
tag: learning_haskell
---



Haskellの書き方も何となくわかってきたので、ここで基本に立ち返り、いわゆるFizzBuzz問題をHaskellで実装してみることにする。

FizzBuzz問題の詳細は[Wikipedia](http://ja.wikipedia.org/wiki/Fizz_Buzz)でも見てもらうことにする。要旨を説明すると、FizzBuzz問題は数値を順に表示するが、その際に3の倍数はFizz、5の倍数はBuzz、3の倍数かつ5の倍数はFizz Buzzに置き換えて表示するという問題だ。

FizzBuzz問題をRubyで実装すると以下のコードとなる。`fizzbuzz`は整数を取り、それを"Fizz"か"Buzz"か"Fizz Buzz"か数値に変換する。`fizzbuzz_map`はArrayで渡された数値列に`fizzbuzz`を適用した結果のArrayを返す。

~~~~
def fizzbuzz(x)
	if x % 15 == 0
		"Fizz Buzz"
	elsif x % 3 == 0
		"Fizz"
	elsif x % 5 == 0
		"Buzz"
	else
		x.to_s
	end
end

def fizzbuzz_map(xs)
	xs.map{|x|
		fizzbuzz x	
	}
end

p fizzbuzz_map [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
# => ["1", "2", "Fizz", "4", "Buzz", "Fizz", "7", "8", "Fizz", "Buzz", "11", "Fizz", "13", "14", "Fizz Buzz"]
~~~~

これをHaskellで実装してみることにする。Haskellで分岐を実現する方法は`if then else`やパターンマッチなどいくつか方法があるが、今回はガード式で`fizzbuzz`を実装することにする。`fizzbuzz_map`はリストの整数に順に`fizzbuzz`を適用するものとし、リストから順に値を取り出すのにリスト内包表記のジェネレータを利用する。便宜的にこの内容を`fizzbuzz.hs`に保存してあるものとする。

~~~~
fizzbuzz :: Int -> String
fizzbuzz x 
		| x `mod` 15 == 0 = "Fizz Buzz"
		| x `mod` 3 == 0 = "Fizz"
		| x `mod` 5 == 0 = "Buzz"
		| otherwise = show x

fizzbuzz_map :: [Int] -> [String]
fizzbuzz_map xs = [fizzbuzz x | x <- xs]
~~~~

これをGHCiからロードして、実行させてみよう。Haskellでは`fizzbuzz_map`に渡すリストは範囲指定により簡潔に記述できる。

~~~~
Prelude> :l fizzbuzz.hs
[1 of 1] Compiling Main             ( fizzbuzz.hs, interpreted )
Ok, modules loaded: Main.
*Main> fizzbuzz_map [1..15]
["1","2","Fizz","4","Buzz","Fizz","7","8","Fizz","Buzz","11","Fizz","13","14","Fizz Buzz"]
~~~~

なお敢えて`fizzbuzz`と`fizzbuzz_map`を別の定義にしているが、`fizzbuzz`が`fizzbuzz_map`だけからしか呼び出されない局所関数でも良いなら、`where`を使って以下の書き方もできる。

~~~~
fizzbuzz_map :: [Int] -> [String]
fizzbuzz_map xs = [fizzbuzz x | x <- xs]
	where fizzbuzz x 
			| x `mod` 15 == 0 = "Fizz Buzz"
			| x `mod` 3 == 0 = "Fizz"
			| x `mod` 5 == 0 = "Buzz"
			| otherwise = show x
~~~~

FizzBuzzの実装とは関係ないが、Haskellの入門には"すごいHaskellたのしく学ぼう!"がおすすめだ。これを読み進めるとみるみるHaskellでコードを書けるようになる。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4274068854/xmisao-22/ref=nosim/" name="amazletlink" target="_blank"><img src="http://ecx.images-amazon.com/images/I/51P6NdS4IGL._SL160_.jpg" alt="すごいHaskellたのしく学ぼう!" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4274068854/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">すごいHaskellたのしく学ぼう!</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 14.01.09</div></div><div class="amazlet-detail">Miran Lipovača <br />オーム社 <br />売り上げランキング: 126,678<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4274068854/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>
