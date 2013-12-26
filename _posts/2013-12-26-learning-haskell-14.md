---
layout: blog
title: もしRubyistがHaskellを学んだら(14)
tag: learning_haskell
---

# もしRubyistがHaskellを学んだら(14)

先日は挿入ソートについて考えたが、今日はクイックソートについて考える。
今回もHaskellでの実装を念頭に置いて、まずRubyでクイックソートを実装する。

クイックソートの基本的な仕組みは以下のとおりだ。

- リスト中で要素のある数より大きな要素と小さな要素を分ける(便宜的にこれを`qsort`の処理とする)
- 大きな要素に対し、`qsort`を再帰的に適用する
- 小さな要素に対し、`qsort`を再帰的に適用する

今回のRubyの実装では、クイックソートを3パートに分けて実装する。

1. クイックソートの本体処理である`qsort`
2. リストからある数より小さな要素を抜き出したリストを作る`smaller`
3. 同様に大きな要素を抜き出したリストを作る`larger`

以上を踏まえたソースコードは以下のとおり。

~~~~
def qsort(list)
	if list.length > 0
		x = list[0]
		xs = list[1..-1]
		qsort(smaller(x, xs)) + [x] + qsort(larger(x, xs))
	else
		[]
	end
end

def smaller(x, list)
	let = list.select{|a| a <= x}
end

def larger(x, list)
	let = list.select{|b| b > x}
end

p qsort([4, 1, 3, 2, 5])
~~~~

~~~~
[1, 2, 3, 4, 5]
~~~~

これをHaskellで実装する。
関数名や変数名は可能な限りRubyの実装にあわせている。
ポイントは`smaller`と`larger`で使っているリスト内包表記による絞り込みだろう。

~~~~
qsort :: Ord a => [a] -> [a]
qsort [] = []
qsort (x:xs) = (qsort (smaller x xs)) ++ [x] ++ qsort((larger x xs))

smaller :: Ord a => a -> [a] -> [a]
smaller x xs = [a | a <- xs, a <= x]

larger :: Ord a => a -> [a] -> [a]
larger x xs = [b | b <- xs, b > x]

main = do
	print $ (qsort [4, 1, 3, 2, 5])
~~~~

~~~~
[1,2,3,4,5]
~~~~

これでも動作するが、この書き方は少し冗長だ。
`smaller`と`larger`は`qsort`内だけで使用される関数だ。
そこで`where`を使って`qsort`内でこれらの関数を定義してやると、以下のようになる。

~~~~
qsort :: Ord a => [a] -> [a]
qsort[] = []
qsort(x:xs) = qsort smaller ++ [x] ++ qsort larger
	where
		smaller = [a | a <- xs, a <= x]
		larger = [b | b <- xs, b > x]

main = print $ (qsort [4, 1, 3, 2, 5])
~~~~

結果、Haskellではわずか6行でクイックソートを実装することができた。ループを再帰として捉えること、リストの操作をリスト内包表記で行うこと、これらにだんだん慣れてきた。

Haskellでのクイックソートの実装については、プログラミングHaskellの6.4 多重再帰の項を参考にした。説明が丁寧な良書である。


<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4274067815/xmisao-22/ref=nosim/" name="amazletlink" target="_blank"><img src="http://ecx.images-amazon.com/images/I/41pybn9bpCL._SL160_.jpg" alt="プログラミングHaskell" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4274067815/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">プログラミングHaskell</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 13.12.24</div></div><div class="amazlet-detail">Graham Hutton <br />オーム社 <br />売り上げランキング: 49,169<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4274067815/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>
