---
layout: blog
title: Rubyの標準添付ライブラリripperでRubyのソースをパースする
tag: ruby
---



Rubyには標準添付ライブラリのripperが存在する。
ripperはRubyプログラムのパーサである。

以下のようにRubyプログラムをトークンに分割したりS式のツリーを取得したりすることが可能だ。

~~~~
require 'ripper'
require 'pp'

src = <<RUBY
puts "Hello, World!"
RUBY

pp Ripper.tokenize(src) # トークンに分割する
pp Ripper.lex(src) # 種類と位置情報付きでトークンに分割する
pp Ripper.sexp(src) # S式のツリーを取得する
~~~~

実行結果は以下のとおり。

~~~~
["puts", " ", "\"", "Hello, World!", "\"", "\n"]
[[[1, 0], :on_ident, "puts"],
 [[1, 4], :on_sp, " "],
 [[1, 5], :on_tstring_beg, "\""],
 [[1, 6], :on_tstring_content, "Hello, World!"],
 [[1, 19], :on_tstring_end, "\""],
 [[1, 20], :on_nl, "\n"]]
[:program,
 [[:command,
   [:@ident, "puts", [1, 0]],
   [:args_add_block,
    [[:string_literal,
      [:string_content, [:@tstring_content, "Hello, World!", [1, 6]]]]],
    false]]]]
~~~~

Rubyのプログラム自体をごにょごにょしたい場合に便利そうだ。

- 参考
  - [library ripper](http://doc.okkez.net/1.9.3/view/library/ripper)
