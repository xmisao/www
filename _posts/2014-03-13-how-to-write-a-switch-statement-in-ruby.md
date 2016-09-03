---
layout: blog
title: Rubyでswitch文はどう書くの?
tag: ruby
---



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

`case`文を`if`文で書き下すと、以下2つのコードはほぼ等価である。

~~~~
case 式0
when 式1, 式2
  stmt1
when 式3, 式4
  stmt2
else
  stmt3
end
~~~~

~~~~
_tmp = 式0
if 式1 === _tmp or 式2 === _tmp
  stmt1
elsif 式3 === _tmp or 式4 === _tmp
  stmt2
else
  stmt3
end
~~~~

上でさらっと書いたが、`when`には複数の条件を書くことができる。
以下の例では`a`が`1`または`2`と一致する時に、最初の`when`節が実行される。

~~~~
case a
when 1, 2
  puts "a is 1 or 2"
when 3
  puts "a is 3"
else
  puts "a is others"
end
~~~~

さらにあまり見かけないが`when`節では`*`による配列展開も利用できる。
以下は上記のコードと同じ意味である。

~~~~
case a
when *[1, 2]
  puts "a is 1 or 2"
when 3
  puts "a is 3"
else
  puts "a is others"
end
~~~~

参考

- [How can I write a switch statement in Ruby?](http://stackoverflow.com/questions/948135/how-can-i-write-a-switch-statement-in-ruby)
