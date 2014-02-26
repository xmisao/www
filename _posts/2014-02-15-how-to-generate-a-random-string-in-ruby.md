---
layout: blog
title: Rubyでランダムな文字列を生成する方法
tag: ruby
---

# Rubyでランダムな文字列を生成する方法

Stack Overflowを眺めていたら目に止まったのでメモする。

## ランダムな文字列を生成する

例えば8文字のランダムな文字を得たいなら以下のように書ける。
範囲オブジェクトに対して`map`メソッドを使うのがポイントだ。

~~~~
(0...8).map{ (65 + rand(26)).chr }.join #=> "ATNDEYYX"
~~~~

処理を分解して見てみよう。

まず`(0...8)`で0から7の8要素の範囲オブジェクトを生成する。

範囲オブジェクトは`Enumerable`なので`map`が使える。

`map`には要素とは無関係に1文字の大文字アルファベットを返すブロック`{ (65 + rand(26)).chr }`を渡す。

`map`はリストを返すので、それを`join`で連結してランダムな文字列を得る。

## ランダムな文字を得る方法を改善する

上記の方法のうち、1文字の大文字アルファベットを返すブロック`{ (65 + rand(26)).chr }`は可読性が高いとは言えない。なにせ`65.chr`が`A`だとは一見してわからない。

そこでこのブロックを以下のように書き換える。

~~~~
(0...8).map{ ('A'..'Z').to_a[rand(26)] }.join #=> "EUSUWIZK"
~~~~

数値による計算の代わりに、ブロック内で`('A'..'Z')`で`A`から`Z`までの文字の範囲オブジェクトを作成する。

それを`to_a`で変換して`['A', .., 'Z']`のリストを得て、そのリスト中からランダムに1文字を選ぶことで文字を得る。

これでだいぶ可読性が高まった。

## 更に複雑な文字列を生成するためにリストを用意する

上記の方法では1文字を得るブロック内でリストを生成していた。予めリストを用意しておけば、好きな文字でランダムな文字列を作ることができる。

例えば`a`から`z`と`A`から`Z`の全アルファベットと、さらに`0`から`9`の数字を含むリストを用意しておけば、これらの文字からランダムな文字列が得られる。

~~~~
o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map { |i| i.to_a }.flatten
string = (0...8).map { o[rand(o.length)] }.join #=> "jZl7NvFb"
~~~~

## SecureRandomを利用する

これまでは自力でランダムな文字列を生成していたが、標準ライブラリのSecureRandomを利用すればランダムな16進数文字列やbase64文字列やバイナリ列を生成できる。

~~~~
require 'securerandom'
p SecureRandom.hex(8) #=> "e11663225ffdb50c"
p SecureRandom.base64(8) #=> "cIvj9lXP/1M="
p SecureRandom.random_bytes(8) #=> "\xF95\xFF\xCE\x96Ik\xC6" 
~~~~

SecureRandomのメソッドに与える引数はいずれもバイト数だということに注意しよう。

`hex`の結果はバイト数の2倍の長さの文字列に、`base64`の結果はバイト数の約1.3倍の長さの文字列に、`random_bytes`の結果はバイト数のバイナリ列になる。

- [How best to generate a random string in Ruby](http://stackoverflow.com/questions/88311/how-best-to-generate-a-random-string-in-ruby)