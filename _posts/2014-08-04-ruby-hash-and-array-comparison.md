---
layout: blog
title: RubyのArrayとHashは==で中身の比較を行う
tag: ruby
---

# RubyのArrayとHashは==で中身の比較を行う

一般的に、Rubyでオブジェクト同士を`==`で比較すると、オブジェクトIDの比較となる。
`==`を再定義してある場合は例外で、例えば`String`は文字列の内容が比較される。

では`Array`や`Hash`はどうなのか。
実は`Array`や`Hash`を`==`すると中身の比較が行われる。

よって以下のような比較が可能である。
単純なHashとArrayはもちろんのこと、複雑に構成されたオブジェクトもこのとおりだ。

~~~~ruby
p [1, 2, 3] == [1, 2, 3] #=> true
p ({a:1, b:2, c:3} == {a:1, b:2, c:3}) #=> true
p ([{a:1, b:2}, {array:[3, 4, 5]}] == [{a:1, b:2}, {array:[3, 4, 5]}]) #=> true
~~~~

私は何となくオブジェクトIDの比較になりそうな気がして、無意識のうちにこのようなコードを書くのは避けていた。反省。

`Array`と`Hash`の`==`の挙動については、きちんとリファレンスにも書いてある。

**Array**

> 自身と other の各要素をそれぞれ順に == で比較し て、全要素が等しければ true を返します。そうでない場合には false を返します。 

**Hash**

> 自身と other が同じ数のキーを保持し、キーが eql? メソッドで比較して全て等しく、 値が == メソッドで比較して全て等しい場合に真を返します。 

これからは安心して`Array`や`Hash`を`==`で比較してゆきたい。

- 参考
  - [Array](http://docs.ruby-lang.org/ja/1.8.7/method/Array/i/=3d=3d.html)
  - [Hash](http://docs.ruby-lang.org/ja/2.1.0/method/Hash/i/=3d=3d.html)
