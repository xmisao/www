---
layout: blog
title: もしRubyistがHaskellを学んだら(13)
tag: learning_haskell
---

# もしRubyistがHaskellを学んだら(13)

今日はリストの挿入ソートについて考える。
Haskellでの実装を念頭に置いて、ループを再帰で考える。
挿入ソートを再帰で実装するには、以下の2つのパートが考えられる。

1. 値とリストを受け取り、リストの適切な場所に値を挿入する(挿入の処理)
2. リストを受け取り、1.に先頭の要素と2.でソート済みのリストを渡す(挿入ソートの処理)

便宜的に1.の処理を`insert`、2.の処理を`isort`と呼ぶことにする。

処理を詳細に考えていく。
`insert`と`isort`は共に再帰的な関数である。

まず1.の挿入の処理。

1. `x`の空リストへの挿入は、`x`のみを含むリストを返す
2. 空でないリストへの挿入では、リストを先頭要素`y`とそれ以降`ys`に分割する
3. `x`がリストの先頭要素`y`以下なら、`x`、`ys`、`y`のリストを返す
4. `x`がリストの先頭要素より大きければ、`y`と再帰的に`ys`に`x`を挿入した結果のリストを連結して返す

続いて2.の挿入ソートの処理。

1. 空のリストの挿入ソート結果は空のリストである
2. 空でないリストの挿入ソート結果は、リストの先頭要素`x`を、それ以降`xs`を再帰的に挿入ソートした結果に挿入したものである

Rubyで実装すると以下のイメージとなる。

~~~~
def insert(x, list)
	if  list.length == 0
		list << x
	else
		y = list[0]
		ys = list[1..-1]
		if x <= y
			[x, y] + ys
		else
			[y] + insert(x, ys)
		end
	end
end

def isort(list)
	if list.length == 0
		[]
	else
		x = list[0]
		xs = list[1..-1]
		insert(x, isort(xs))
	end
end

p isort([2, 4, 3, 5, 1])
~~~~

~~~~
[1, 2, 3, 4, 5]
~~~~

これをHaskellで実装する。
挿入ソートを再帰で実装する考え方は上記で述べたため、ループを再帰にする事はすでにできている。
あとは分岐をガード式に読み替えて、Haskellのコードに落としてゆくだけだ。

~~~~
insert :: Ord a => a -> [a] -> [a]
insert x [] = [x]
insert x (y:ys) | x <= y = x : y : ys
								| otherwise = y : insert x ys

isort :: Ord a => [a] -> [a]
isort [] = []
isort(x:xs) = insert x (isort xs)

main = print $ (isort [2, 4, 3, 5, 1])
~~~~

~~~~
[1,2,3,4,5]
~~~~

以上のように挿入ソートをHaskellで実装することができた。
だんだんHaskellの考え方が身についてきた。
ポイントは、以下の2点である。

1. ループを再帰として考えること
2. 条件分岐をガードとして考えること

ところで闇雲にHaskellを勉強するのはしんどいので、少し前からプログラミングHaskellを購入し、これを元に勉強を進めている。これも簡単な内容とは言いがたいのだが、HaskellのHもわからない人には心強い本である。おすすめ。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4274067815/xmisao-22/ref=nosim/" name="amazletlink" target="_blank"><img src="http://ecx.images-amazon.com/images/I/41pybn9bpCL._SL160_.jpg" alt="プログラミングHaskell" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4274067815/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">プログラミングHaskell</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 13.12.24</div></div><div class="amazlet-detail">Graham Hutton <br />オーム社 <br />売り上げランキング: 49,169<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4274067815/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>
