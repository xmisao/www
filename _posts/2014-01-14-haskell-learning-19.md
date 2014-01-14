---
layout: blog
title: もしRubyistがHaskellを学んだら(19) ラムダ式と畳み込み
tag: learning_haskell
---

# もしRubyistがHaskellを学んだら(19) ラムダ式と畳み込み

とうとう出てきましたよラムダ式。関数型言語では良く目にして、初学者の心を折るC言語でいうポインタのようなものである。

ラムダ式とはいわゆる無名関数で、その名の通り名前のない関数を作ることができる。例えば、与えられた引数をそのまま返すラムダ式は`(\x -> x)`で、以下のように書ける。GHCiでさくっと実行してみよう。

~~~~
Prelude> (\x -> x) 1
1
~~~~

では2引数を取り、それを加算して返すラムダ式はどうだろうか。これは`(\x y -> x + y)`で、やはりGHCiで実行させると期待どおりに動作する。

~~~~
Prelude> (\x y -> x + y) 1 2
3
~~~~

ここまではつまらないが、リストを畳み込む`foldl`や`foldr`と組み合わせると、一気にラムダ式が強力なものに思えてくる。`foldl`の型は以下のとおり。

~~~~
Prelude> :t foldl
foldl :: (a -> b -> a) -> a -> [b] -> a
~~~~

2引数をとる関数と、アキュムレータ(初期値のようなもの)、リストを受け取りアキュムレータと同じ型の値を返す。`foldl`はリストを走査して、関数を適用してアキュムレータを更新しつつ、最後にアキュムレータを返す動作をする。

先ほどのつまらないラムダ式を`foldl`に与えて、リストの要素を合計する`sum'`を定義してみることにする。`foldl`で畳み込みを行うので、明示的に再帰を使っていないのがポイントだ。

- sum'.hs

~~~~
sum` :: (Num a) [a] -> a
sum' xs = foldl (\x y -> x + y) 0 [xs]
~~~~

GHCiからロードして実行させてみる。

~~~~
Prelude> :l sum'.hs
[1 of 1] Compiling Main             ( sum'.hs, interpreted )
Ok, modules loaded: Main.
*Main> sum' [1, 2, 3]
6
~~~~

他に畳み込みに使える関数としては、リストを右から評価する`foldr`、リストの先頭の値をアキュムレータとする`foldr1`と`foldr1`、アキュムレータの中間状態をリスト化する`scanl`と`scanr`などがある。

ラムダ関数と畳み込みについては"すごいHaskellたのしく学ぼう!"の5.4と5.5が詳しい。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4274068854/xmisao-22/ref=nosim/" name="amazletlink" target="_blank"><img src="http://ecx.images-amazon.com/images/I/51P6NdS4IGL._SL160_.jpg" alt="すごいHaskellたのしく学ぼう!" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4274068854/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">すごいHaskellたのしく学ぼう!</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 14.01.09</div></div><div class="amazlet-detail">Miran Lipovača <br />オーム社 <br />売り上げランキング: 126,678<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4274068854/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>
