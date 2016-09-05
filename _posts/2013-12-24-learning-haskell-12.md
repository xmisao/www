---
layout: blog
title: もしRubyistがHaskellを学んだら(12) リストを逆順にする
tag: learning_haskell
---



しばらく間が空いてしまったが、Haskellの勉強を続ける。
今日はリストを逆順にする処理を再帰で考える。

リストを逆順にする処理`reverse`は以下のように考えられる。

1. リストを逆順にする操作は、まずリストを受け取る。
2. 受け取ったリストの長さが0なら空のリストを返す。(空のリストの逆順は空である)
3. 受け取ったリストを先頭の要素と先頭以降に分離する。
4. 先頭以降を`reverse`で逆順にして、末尾に先頭の要素を連結する。

以上の再帰的な処理で実装できる。Rubyで実装すると以下のイメージ。

~~~~
def reverse(list)
	if list.length > 0
		x = list[0]
		xs = list[1..-1]
		reverse(xs) << x
	else
		[]
	end
end

p reverse([1, 2, 3])
~~~~

~~~~
[3, 2, 1]
~~~~


これをHaskellで実装する。
ライブラリ関数`reverse`と重複するので、関数名は`myreverse`としている。
リスト長による分岐はパターンマッチによる関数定義で行う。

~~~~
myreverse :: [a] -> [a]
myreverse [] = [] -- 空のリストの逆順は空
myreverse (x:xs) = (myreverse xs) ++ [x] -- 先頭以降の逆順に先頭の要素を連結する

main = print $ (myreverse [1, 2, 3])
~~~~

~~~~
[3,2,1]
~~~~

これでリストを逆順にする関数をHaskellで実装することができた。
Haskellを使うにはループを再帰にする発想の転換が必要だ。
ヒビショウジン。
