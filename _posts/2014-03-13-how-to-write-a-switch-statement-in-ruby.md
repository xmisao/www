---
layout: blog
title: Rubyでswitch文はどう書くの?
tag: ruby
---

# Rubyでswitch文はどう書くの?

Stackoverflowより。

他の言語でいういわゆるswitch文は、Rubyでは`case`文である。

~~~~
case a
when 1..5
  puts "It's between 1 and 5"
when 6
  puts "It's 6"
when String
  puts "You passed a string"
else
  puts "You gave me #{a} -- I have no idea what to do with that."
end
~~~~

`case`は1つの式に対する一致判定による分岐を行う制御構造だ。

Rubyはまず`case`に渡された式を評価し、その結果を順次`when`の式と比較してゆき、一致した`when`節を実行する。
どの`when`節にも一致しなければ、`else`節が実行される。

この際に比較には`===`演算子が使用されることがポイントだ。
つまり上記の例では`1..5 === a`、`6 === a`、`String === a`が評価され、これが真になった`when`節が実行される。

参考

- [How can I write a switch statement in Ruby?](http://stackoverflow.com/questions/948135/how-can-i-write-a-switch-statement-in-ruby)
