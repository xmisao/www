---
layout: blog
title: もしRubyistがHaskellを学んだら(16) 型推論と型注釈
tag: learning_haskell
---



Haskellは型推論を備えた言語であり、静的型付けでありながら型を明記しなくても、型を推測してコンパイルすることができる。この点は動的型付けでダックタイピングなRubyとは対極である。

しかし、静的型付けという性質上、型が推測できない場合は明示的に型を指定してやる必要があり、それをするのが型注釈という機能である。今回はHaskellの型推論と型注釈の使い方について整理してみる。

`Read`型は文字列を受け取り`Read`のインスタンスの型の値を返すインタフェースを実装している。それが`read`関数である。GHCiで`read`関数の型を確認してみると、以下のとおりになっている。

~~~~
Prelude> :t read
read :: Read a => String -> a
~~~~

GHCiで試しに`read`を使って以下のコードを実行させてみると、確かに型が推論されて文字列が数値に解釈され、計算結果が表示される。

~~~~
Prelude> read "5" + 3
8
~~~~

これが実行できるのは`read`の結果を`Int`型の`3`と加算することから、Haskellが気を利かせて`read`の返り値が`Int`型だと型推論を行ったためである。

では意地悪をして、`read`関数を単独で実行してみるとどうだろうか。想像通りこれはエラーとなる。`read`は`Read a => String -> a`なので、型変数`a`の型が不明だとコンパイルできないのだ。

~~~~
Prelude> read "5"

<interactive>:3:1:
    Ambiguous type variable `a0' in the constraint:
      (Read a0) arising from a use of `read'
    Probable fix: add a type signature that fixes these type variable(s)
    In the expression: read "5"
    In an equation for `it': it = read "5"
~~~~

このような場合に、Haskellに型を教えてやる方法が型注釈だ。型注釈は`::`に続けて型を書いてやることで、式の型を明示的にHaskellに伝える。先ほどの`read "5"`に型注釈をつけて実行させてみよう。

~~~~
Prelude> read "5" :: Int
5
~~~~

これで狙い通り文字列`"5"`を`Int`型の数値`5`に変換することができた。Rubyであれば`"5".to_i`などとする文字列と数値の変換が、Haskellでは型クラスと型推論、型注釈という別のパラダイムによって実現できたわけだ。

Haskellの型クラスと型推論については"すごいHaskellたのしく学ぼう!"の2章で解説されている。この本は本当に読みやすく、おすすめ。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4274068854/xmisao-22/ref=nosim/" name="amazletlink" target="_blank"><img src="http://ecx.images-amazon.com/images/I/51P6NdS4IGL._SL160_.jpg" alt="すごいHaskellたのしく学ぼう!" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4274068854/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">すごいHaskellたのしく学ぼう!</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 14.01.09</div></div><div class="amazlet-detail">Miran Lipovača <br />オーム社 <br />売り上げランキング: 126,678<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4274068854/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>
