---
layout: blog
title: Rubyのバージョンとripperの関係
tag: ruby
---

# Rubyのバージョンとripperの関係

ripperの基本的な使い方は[Rubyの標準添付ライブラリripperでRubyのソースをパースする](http://www.xmisao.com/2014/05/12/ruby-ripper.html)で紹介した。
きょうはRubyのバージョンとripperの関係について少し書いておく。

実はripperはRubyのバージョンアップに伴って、きちんと新バージョンで追加された文法にも対応しているようなのだ。

例えばRuby 1.9のripperで、Ruby 2.0で導入されたキーワード引数を使ったソースのS式を取得してみると、うまくパースすることができない。

~~~~
require 'ripper'
require 'pp'

src = <<SRC
def foo(a:1, b:2, c:3)
end
SRC

pp Ripper.sexp(src)
~~~~

__Ruby 1.9のripperによるパース結果__

~~~~
[:program, [:@int, "1", [1, 10]]]
~~~~

これと全く同じコードをRuby 2.0のripperで動かしてみると、先ほどはパースできていなかったキーワード引数が、きちんとパースできていることが確認できる。

__Ruby 2.0のripperによるパース結果__

~~~~
[:program,
 [[:def,
   [:@ident, "foo", [1, 4]],
   [:paren,
    [:params,
     nil,
     nil,
     nil,
     nil,
     [[[:@label, "a:", [1, 8]], [:@int, "1", [1, 10]]],
      [[:@label, "b:", [1, 13]], [:@int, "2", [1, 15]]],
      [[:@label, "c:", [1, 18]], [:@int, "3", [1, 20]]]],
     nil,
     nil]],
   [:bodystmt, [[:void_stmt]], nil, nil, nil]]]]
~~~~

同様に、Ruby 2.1で導入された`3.14r`のような有理数の数値リテラルは、Ruby 2.0のripperではfloatの値とパースされてしまうが、Ruby 2.1のripperでは有理数としてパースできるようになっている。

~~~~
require 'ripper'
require 'pp'

src = <<SRC
pi = 3.14r
SRC

pp Ripper.sexp(src)
~~~~

__Ruby 2.0のripperによるパース結果__

~~~~
[:program,
 [[:assign, [:var_field, [:@ident, "pi", [1, 0]]], [:@float, "3.14", [1, 5]]]]]
~~~~

__Ruby 2.1のripperによるパース結果__

~~~~
[:program,
 [[:assign,
   [:var_field, [:@ident, "pi", [1, 0]]],
   [:@rational, "3.14r", [1, 5]]]]]
~~~~

ripperすごい!(何度目だっ) Ruby 2.0のripperはRuby 2.0のコードを、Ruby 2.1のripperはRuby 2.1のコードを、きちんとパースすることができている。ますますripperが好きになってきたぞ。
