---
layout: blog
title: Rubyでメソッドの呼び出し元を取得する
tag: ruby
---



Rubyでは`caller`メソッドでバックトレースを取得することができる。
これを利用すればあるメソッドが何処から呼び出されたのか、呼び出し元を取得することが可能だ。

~~~~
def foo
  bar
end

def bar
  puts caller[0][/`([^']*)'/, 1] #=> "foo"
end

foo 
~~~~

なお`caller`の返却値はバックトレースの文字列の配列である。
バックトレースの文字列にはファイル名、行番号、メソッド名が含まれている。
上記コードの正規表現<code>/`([^']*)'/</code>はこの文字列からメソッド名を抜き出すものだ。

ちなみに呼び出し元ではなく、現在のメソッド名を取得するには`Kernel.#__method__`を使う。

~~~~
def hoge
  p __method__ #=> :hoge
end

hoge
~~~~

参考

- [How to get the name of the calling method?](http://stackoverflow.com/questions/5100299/how-to-get-the-name-of-the-calling-method)
