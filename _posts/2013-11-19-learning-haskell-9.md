---
layout: blog
title: もしRubyistがHaskellを学んだら(9) パターンマッチによる関数定義
tag: learning_haskell
---

# もしRubyistがHaskellを学んだら(9) パターンマッチによる関数定義

今日はパターンマッチによる関数定義をしてみることにした。実装するのは、TrueとFasleを逆転させる論理否定を行う`lnot`関数だ。

Rubyで書くと以下のイメージである。

~~~~
def lnot
	lnot ? false : true
end
puts false
puts true
~~~~

Haskellでは、これをパターンマッチによる関数定義で実装する。

~~~~
lnot :: Bool -> Bool
lnot False = True
lnot True = False

main = do
	print (lnot False)
	print (lnot True)
~~~~

`lnot`関数は、Boolを受け取りBoolを返す。`lnot False`パターンには`True`を、`lnot True`パターンには`False`を返す。

試しにこのコードを実行した結果は以下のとおりだ。確かに論理否定できていることがわかる。

~~~~
True
False
~~~~
