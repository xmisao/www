---
layout: blog
title: Rubyのandと&&、orと||の違い
tag: ruby
---

# Rubyのandと&&、orと||の違い

Rubyの`and`と`&&`、`or`と`||`は意味は同じだが演算子の優先順位が異なる。
`and`と`&&`の意味は、まず左辺を評価して結果が真なら右辺も評価するという意味。
`or`と`||`の意味は、まず左辺を評価して結果が偽なら右辺も評価するという意味。
`and`と`or`の優先順位はとても低く、`&&`と`||`の優先順位はそれより多少高い。

一例として以下のソースコードを実行してみると良い。

~~~~
foo = :foo
bar = nil

a = foo and bar
p a #=> :foo

a = foo && bar
p a #=> nil
~~~~

`a = foo and bar`の評価結果は`a`に`:foo`が代入される。
これは`a = foo`が先に評価されて、優先順位の低い`and`はその後に評価されるためだ。
括弧を使って書き下すと以下と同様である。

~~~~
(a = foo) and bar
~~~~

一方で`a = foo && bar`の評価結果は`a`に`nil`が代入される。
これは直感どおり`foo && bar`が先に評価されて`nil`となり`a`に代入されるためだ。
括弧を使って書き下すと以下と同様である。

~~~~
a = (foo && bar)
~~~~

このように`and`と`&&`、`or`と`||`は思いもよらぬところで計算結果が異なる可能性もある。
きちんと優先順位を把握した上で、使い分けるようにしたい。

参考

- [演算子式](http://docs.ruby-lang.org/ja/1.9.3/doc/spec=2foperator.html)
- [Difference between “and” and && in Ruby?](http://stackoverflow.com/questions/1426826/difference-between-and-and-in-ruby)
- [Difference between “or” and \|\| in Ruby?](http://stackoverflow.com/questions/2083112/difference-between-or-and-in-ruby)
