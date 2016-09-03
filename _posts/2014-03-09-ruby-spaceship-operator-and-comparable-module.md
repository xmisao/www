---
layout: blog
title: Rubyの<=>演算子とComparableモジュールの関係
tag: ruby
---



Rubyにおける`<=>`演算子は、基本的な比較演算子で、以下のことが期待されている。

self `<=>` otherは

- self が other より大きいなら正の整数
- self と other が等しいなら 0
- self が other より小さいなら負の整数
- self と other が比較できない場合は nil

試しにいくつか結果を見てみよう。
確かに`Integer`同士の`<=>`演算子による比較は、期待どおりの結果を返している。
また比較ができない`Integer`と`String`の比較は`nil`を返すこともわかる。

~~~~
1 <=> 0 #=> 1
1 <=> 1 #=> 0
0 <=> 1 #=> -1
0 <=> "" #=> nil
~~~~

`<=>`演算子は`sort`メソッドのブロック内で利用できる。
以下は整数のリストをソートする、とてもつまらない例だ。

~~~~
[3, 2, 1].sort{|v0, v1|
  v0 <=> v1
}
#=> [1, 2, 3]
~~~~

正しく`<=>`演算子が定義されていれば、`<=>`演算子を使って、他の比較演算子を導くことができる。
その実装が`Comparable`モジュールだ。
`Comparable`モジュールは以下のメソッドを`<=>`演算子を使って実装する。

- `<`
- `<=`
- `==`
- `>`
- `>=`
- `between?`

試しに値を1つ保持する`Value`クラスに`<=>`演算子を定義して、`Comparable`モジュールをincludeしてみる。
すると確かに各種の比較演算子が使えるようになることがわかる。

~~~~
class Value
  include Comparable
  attr_accessor :value

  def initialize(value)
    @value = value
  end

  def <=>(other)
    @value - other.value
  end
end

v1 = Value.new(1)
v2 = Value.new(2)
v3 = Value.new(3)

p v1 < v2 #=> true
p v1 <= v2 #=> true
p v1 == v2 #=> false
p v1 > v2 #=> false
p v1 >= v2 #=> false
p v2.between?(v1, v3) #=> true
~~~~

参考

- [What is the Ruby <=> (spaceship) operator?](http://stackoverflow.com/questions/827649/what-is-the-ruby-spaceship-operator)
- [module Comparable](http://docs.ruby-lang.org/ja/1.8.7/class/Comparable.html)
