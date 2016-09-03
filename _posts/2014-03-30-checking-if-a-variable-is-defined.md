---
layout: blog
title: Rubyで変数が定義されているか確認する
tag: ruby
---



Rubyで変数が定義されているか確認するには`defined?`を使用する。
`defined?`は変数が定義されていなければ`nil`を返す。

~~~~
a = true
b = nil

defined? a #=> "local-variable"
defined? b #=> "local-variable"
defined? c #=> nil
~~~~
