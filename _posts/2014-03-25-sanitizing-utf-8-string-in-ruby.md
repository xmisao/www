---
layout: blog
title: UTF-8として不正な文字を除去する -- invalid byte sequence in UTF-8例外を発生させなくするには
tag: ruby
---



ネットワークから収集したテキストファイルには、時にUTF-8として不正な文字が含まれている場合がある。
そのような不正な文字列に対して正規表現によるマッチなど何か操作を行おうとすると以下のエラーが発生する。

~~~~
ArgumentError: invalid byte sequence in UTF-8
~~~~

このエラーを発生させないようにするには、文字列からUTF-8として不正な文字を除去しなければならない。

Ruby 1.9では、`encode`メソッドに`:invalid => replace`オプションを指定して、UTF-8からUTF-8への変換を行えば、不正な文字を除去することができる。

~~~~
str.encode!('UTF-8', 'UTF-8', :invalid => :replace)
~~~~

この方法でもまだ不正な文字が除去できない場合は、以下のようにUTF-16を経由する方法を試してみると良い。

~~~~
str.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
str.encode!('UTF-8', 'UTF-16')
~~~~

Ruby 1.8では、`encode`メソッドが使用できないため、iconvライブラリを利用して以下のようにする。

~~~~
require 'iconv'
iconv = Iconv.new('UTF-8', 'UTF-8//IGNORE')
str = iconv.iconv(str)
~~~~

参考

- [ruby 1.9: invalid byte sequence in UTF-8](http://stackoverflow.com/questions/2982677/ruby-1-9-invalid-byte-sequence-in-utf-8)
