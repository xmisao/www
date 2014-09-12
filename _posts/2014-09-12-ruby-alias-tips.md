---
layout: blog
title: Rubyのaliasは元のメソッドを再定義しても残る
tag: ruby
---

# Rubyのaliasは元のメソッドを再定義しても残る

Rubyでは`alias`を使ってメソッドに別名を付けることができる。
`alias`の面白い点は、別名を付けたメソッドは`alias`を評価した時点のメソッド定義を引き継ぐことだ。

> 別名を付けられたメソッドは、その時点でのメソッド定義を引き継 ぎ、元のメソッドが再定義されても、再定義前の古いメソッドと同 じ働きをします。あるメソッドの動作を変え、再定義するメソッド で元のメソッドの結果を利用したいときなどに利用されます。

- [alias](http://docs.ruby-lang.org/ja/1.9.3/doc/spec=2fdef.html#alias)

以下のコードで確かめてみよう。

まず`old method`を出力する`method`メソッドを定義する。
続いてそれに`alias`で`old_method`という別名をつける。
最後に`method`メソッドが`new method`と出力するように再定義する。
この状態で`method`メソッドと`old_method`メソッドを呼び出す。

~~~~ ruby
def method
  puts 'old method'
end

alias old_method method

def method
  puts 'new method'
end

method
old_method
~~~~

出力結果は以下のようになる。
`method`メソッドは`new method`を出力し、`method`を再定義しても、`old_method`は`old method`と出力し続ける。
`alias`を評価した時点の`method`メソッドの定義が、`old_method`メソッドに引き継がれているためだ。

~~~~
new method
old method
~~~~

この挙動からRubyの`alias`の実態は、別名を付けるというより、メソッドのコピーであることがわかる。
