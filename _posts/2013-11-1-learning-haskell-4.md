---
layout: blog
title: もしRubyistがHaskellを学んだら(4)
tag: learning_haskell
---

# もしRubyistがHaskellを学んだら(4)

今日はHaskellで乱数を出力してみようと思う。Haskellの公式サイトのThe global random number generatorの例をそのまま使う。

- [http://hackage.haskell.org/package/random-1.0.0.2/docs/System-Random.html](http://hackage.haskell.org/package/random-1.0.0.2/docs/System-Random.html)

~~~~
import System.Random
rollDice :: IO Int
rollDice = getStdRandom(randomR(1, 6))
~~~~

昨日は関数を定義したが、この`rollDice`の定義は一体何なのだろうか。`IO Int`を返すことの意味が良くわからない。

`Int`を文字列に変換するのは`show`でできることがわかっている。しかし、この関数の返り値は、そのままでは文字列にすることはできないようだ。

ここではじめて2行ある`main`を欠くことになった。`<-`はHaskellで束縛と呼ぶらしく、これで`IO Int`を普通の`Int`にすることができる。

~~~~
import System.Random
rollDice :: IO Int
rollDice = getStdRandom(randomR(1, 6))
main = do
	rand <- rollDice
	putStrLn(show rand)
~~~~

調べてみると、この例は以下のように書けることがわかった。`>>=`とはおまじないだ。しかし、`print`ではない関数を使うことはできない模様。うむむ。

~~~~
import System.Random
rollDice :: IO Int
rollDice = getStdRandom(randomR(1, 6))
main = rollDice >>= print
~~~~

以下のQ & Aを見ると、`>>=`オペレータも束縛であるそうだ。純粋関数やIOモナドというHaskell特有の単語が散らばっており、今の時点で理解するのは難しい。

- [http://stackoverflow.com/questions/4235348/converting-io-int-to-int](http://stackoverflow.com/questions/4235348/converting-io-int-to-int)

いまいちな内容になってしまったが、今日はここまで。
