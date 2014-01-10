---
layout: blog
title: もしRubyistがHaskellを学んだら(3) 関数の定義
tag: learning_haskell
---

# もしRubyistがHaskellを学んだら(3) 関数の定義

今日はHaskellで関数を定義して使ってみることにする。

関数は以下のように定義する。`=`の左側に関数名に続けて引数を、右側には関数の内容を書く。この`func`という名前の関数は、aとbを加算して返す。

~~~~
func a b = a + b
~~~~

`main`では`func`を呼び出し、昨日覚えたように数値を`show`で文字列に変換して、`putStrLn`で表示してやる。通して書くと以下のとおり。

~~~~
func a b = a + b
main = putLnStr(show(func 1 2))
~~~~

もっとエレガントな方法があるような気がするが、気にしないでおく。

ところで、何も考えずに`func`を呼び出すだけの`main`を書くと、以下のようなエラーが表示される。このエラーはHaskellを勉強し始めてから、何度も目にした。

~~~~
func.hs:2:8:
    No instance for (Num (IO t0))
      arising from a use of `func'
    Possible fix: add an instance declaration for (Num (IO t0))
    In the expression: func 1 2
    In an equation for `main': main = func 1 2
~~~~

これは`main`の返り値が`IO ()`だから発生する。Haskellで`IO ()`とは値を返さないという意味なのだそうだ。`func`は計算結果を返すので、`IO ()`には当てはまらない。そのためエラーになる。

関数は型を明示して定義することができる。型の明示は`::`と`->`を使って、以下のように行う。これは`func`が、Intを第1引数、第2引数にとり、Intを返すことを示す。

~~~~
func :: Int -> Int -> Int
~~~~

`main`の型も明示して、型を厳密にしてプログラムを書きなおしてみる。これでコンパイルも通るし、実行すると3が表示される。

~~~~
func :: Int -> Int -> Int
main :: IO ()
func a b = a + b
main = putStrLn(show(func 1 2))
~~~~
