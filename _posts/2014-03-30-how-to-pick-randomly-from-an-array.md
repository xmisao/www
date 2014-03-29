---
layout: blog
title: Rubyで配列からランダムに1つ要素を取得する
tag: ruby
---

# Rubyで配列からランダムに1つ要素を取得する

Ruby 1.9では`Array#sample`を使うと配列からランダムに1つ要素を取得することができる。

~~~~
["foo", "bar", "buz"].sample #=> "bar"
~~~~

Ruby 1.8では`rand`を使って自力で要素を1つ選択するようにするしかない。

~~~~
a = ["foo", "bar", "buz"]
a[rand(a.length)] #=> "foo"
~~~~

参考

- [How do I pick randomly from an array?](http://stackoverflow.com/questions/3482149/how-do-i-pick-randomly-from-an-array)
