---
layout: blog
title: VimのRubyインタフェースのVIM::evaluateの戻り値の謎
tag: ['vim', 'ruby']
---



VimのRubyインタフェースには、式を評価した結果をRubyで取得するための`VIM::evaluate`というモジュール関数がある。
リファレンスを読むと、この関数の挙動は以下のとおりである。

>VIM::evaluate({expr})
>Evaluates {expr} using the vim internal expression evaluator (see |expression|). Returns the expression result as a string. A |List| is turned into a string by joining the items and inserting line breaks.

>VIM::evaluate({expr})
>Vim内部の実行エンジンを使ってスクリプト{expr}を実行評価する(|expression|参照)。実行結果は文字列で返される。|List|は文字列に変換される。各要素が連結され、間に改行が挿入される。

リストは改行区切りの文字列に変換されることになっていて、リファレンスを読む限り使えねーなーという感じである。
Ruby側でいちいち文字列をパースして配列に戻してやらなきゃあかんのか。

しかし、実際には`VIM::evaluate`はvimの配列や辞書をRubyのリストやハッシュに変換してくれるようなのである。
しかも配列や辞書が組み合わさった複雑なデータ構造もそのまま変換可能だ。

試しに、以下を実行させてみると

~~~~
let array = [1, 2, 3]
let hash = {'a': 1, 'b': 2, 'c':3}
let complex = [{'foo': 'bar'}, ['hoge', 'piyo']]
ruby << RUBY
  print VIM::evaluate('array')
  print VIM::evaluate('hash')
  print VIM::evaluate('complex')
RUBY
~~~~

このような結果となる。

~~~~
[1, 2, 3]
{"a"=>1, "b"=>2, "c"=>3}
[{"foo"=>"bar"}, ["hoge", "piyo"]]
~~~~

賢い!

この現象が確認できた`:version`は以下のとおり。
ドキュメントが実装に追いついていないのだろうか。
どのバージョンで変更されたのか、不安である。

~~~~
VIM - Vi IMproved 7.4 (2013 Aug 10, compiled Apr 12 2014 01:13:04)
~~~~
