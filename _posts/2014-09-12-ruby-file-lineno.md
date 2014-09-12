---
layout: blog
title: Rubyで読み込み中のファイルの行数を取得する
tag: ruby
---

# Rubyで読み込み中のファイルの行数を取得する

Rubyではファイル等の読み込み中に`IO#lineno`を参照することで、その`IO`オブジェクトで`gets`を呼び出した回数を取得できる。
これを利用すれば、`gets`でファイルを読み進んでいる時に、現在までに読み込んだ行数を取得したり、簡単にファイルの行数を数えることができる。

~~~~ruby
open('foo.txt'){|f|
  while f.gets
    puts f.lineno
  end
}
~~~~

上記コードの出力は以下のようになる。

~~~~
1
2
3
~~~~

- 参考
  - [IO#lineno](http://docs.ruby-lang.org/ja/1.9.3/class/IO.html#I_LINENO)
