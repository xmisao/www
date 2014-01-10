---
layout: blog
title: もしRubyistがHaskellを学んだら(1) Hello, World!
tag: learning_haskell
---

# もしRubyistがHaskellを学んだら(1) Hello, World!

## はじめに

思い立ったが吉日、Haskellを勉強することにした。
私のベースとなる言語はRubyなので、この連載はRubyistがHaskellを勉強したらどうなるのか? という観点で、日記形式で書いていく。

Haskellとは関数型言語である。
言わずと知れた、という程有名ではない。
だが、Haskellを学ぶことで、きっと新たなパラダイムを身につけることができる。
そういう希望を胸に、私はHaskellの世界に身を投じる。

## コンパイラのインストール

さて、Haskellを使うにあたって、まずコンパイラをインストールする。
はじめて知ったのだが、Haskellには主要な実装が複数存在するようだ。
その中で最も有名だというGHCを使うことにした。
debianでは以下でインストールできる。

~~~~
apt-get install ghc
~~~~

## Haskellの資料

これでコンパイラは手に入ったが、使い方がわからない。
資料かチュートリアルを探さなければならない。
少し検索したところ、GHCのマニュアルの日本語訳が見つかった。
日本語としてはこれが最大級かつ最も正確なようだ。
GHCのマニュアルを足がかりに、Haskellをはじめてみよう。

- [http://www.kotha.net/ghcguide_ja/latest/](http://www.kotha.net/ghcguide_ja/latest/)

## Hello, World!

最初に書くのはやはりHello, World!だろう。
Haskellのコードの拡張子は`.hs`だという事を知った。
`hello.hs`として以下の内容を書く。

~~~~
main = putStrLn "Hello, World!"
~~~~

Haskellにはmain関数のようなものが必要だとわかった。
`=`を使ってこの関数のようなものを定義できるらしい。
また`putStrLn`がRubyで言うところの`puts`であるようだ。
引数は括弧を使わずに渡せる。
文字列リテラルはRubyと同じく`"`を使うようだ。

コンパイルは`ghc`か`haskell-compiler`コマンドで行う。

~~~~
ghc hello.hs
~~~~

これで`hello`コマンドが生成される。
実行してみよう。

~~~~
./hello
~~~~

~~~~
Hello, World!
~~~~

こんにちはHaskell!
