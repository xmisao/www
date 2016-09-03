---
layout: blog
title: Rubyで配列をある要素数ごとに分割するならArray#each_sliceを使おう
tag: ruby
---



Rubyで配列をある要素数ごとに分割する場合は`Enumerable#each_slice`が利用できる。

~~~~ ruby
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].each_slice(3){|part|
  p part
}
~~~~

~~~~
[1, 2, 3]
[4, 5, 6]
[7, 8, 9]
[10]
~~~~

ブロックを与えない場合は、`Enumerator`が返る。もし配列の配列が必要なら`to_a`してやれば良い。

~~~~ ruby
p [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].each_slice(3).to_a
~~~~

~~~~
[[1, 2, 3], [4, 5, 6], [7, 8, 9], [10]]
~~~~
