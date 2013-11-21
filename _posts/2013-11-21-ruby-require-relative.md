---
layout: blog
title: Rubyで相対パスのファイルをreuqire
tag: ruby
---

# Rubyで相対パスのファイルをreuqire

以下のようなディレクトリ構造でソースファイルが配置されているとする。
ここで`hoge.rb`から`lib/piyo.rb`をrequireする場合を考える。

- hoge.rb
- lib
  - piyo.rb

Rubyで相対パスのファイルをrequireする場合、以下のイディオムが良く用いられる。

~~~~
require File.expand_path('../lib/hoge.rb', __FILE__)
~~~~

`File.expand_path()`は、第2引数のパスを起点に、第1引数のパスを、フルパスに展開するメソッドだ。

`__FILE__`にはそのファイルのパスが入っているが、これは絶対パスとは限らない。

そこで、`File.expand_path()`の第2引数にこれを指定し、第1引数にそのファイルからの相対パスを書くことで、目的のファイルの絶対パスが得られる。

なおRuby 1.9以降であれば、`require_relative`を使えば、相対パスで目的のファイルを簡単にrequireすることができるようになった。

~~~~
reuqire_relative 'lib/piyo.rb'
~~~~
