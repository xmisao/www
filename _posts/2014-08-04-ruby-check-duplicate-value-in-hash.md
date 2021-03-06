---
layout: blog
title: Rubyでハッシュの中に重複した値があるか調べる
tag: ruby
---



Twitterで見かけて目からウロコだったので紹介する。

以下のようなハッシュがある時に、ハッシュの値に重複した値があるかを調べたいとする。

~~~~ruby
h = {a:1, b:2, c:3, d:1}
~~~~

重複した値があるかは以下のように調べられる。
`Hash#invert`でキーと値を逆にしたハッシュを生成する。
キーと値を逆にしたハッシュは、重複した値がある場合にサイズが少なくなる。
これを元のハッシュのサイズと比較することで、重複した値があるかを判定できる。

~~~~ruby
if h.size == h.invert.size
  puts "重複した値なし"
else
  puts "重複した値あり"
end
~~~~

`Hash#values`で値の配列を作って、`Array#uniq`してサイズを比較しても、同じ結果が得られる。
ただ`Hash#invert`の方がメソッドの呼び出しが少ないのでスマートだろう。

- 参考
  - [https://twitter.com/chezou/status/494047989061529600](https://twitter.com/chezou/status/494047989061529600)
