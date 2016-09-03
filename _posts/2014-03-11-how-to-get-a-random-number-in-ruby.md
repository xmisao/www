---
layout: blog
title: Rubyでランダムな数値を得る方法
tag: ruby
---



基本的には`rand`メソッドで事足りる。

`rand`メソッドに整数値を与えると、0からその整数値未満の整数を返す。
例えばサイコロを振るように、1から6のランダムな数値を得るには以下のようにする。

~~~~
rand(6) + 1
~~~~

Ruby 1.9.3以降では、`rand`メソッドは範囲オブジェクトを取ることもできる。
この場合は与えた範囲オブジェクト内の整数をランダムで返す。

~~~~
rand(1..6)
~~~~

`rand`メソッドの他には、乱数ジェネレータ`Random`クラスのインスタンスを生成して`Random#random`を使う方法もある。

~~~~
random = Random.new
random.rand(1..6)
~~~~

ただし乱数ジェネレータの初期時の乱数のシードの選択は、乱数の生成アルゴリズムより不均一なことに注意。
均一な乱数を得たいなら、乱数ジェネレータのインスタンスを使いまわした方が良い。

~~~~
# 悪い例
Random.new.rand(1..6)
Random.new.rand(1..6)
Random.new.rand(1..6)

# 良い例
random = Random.new
random.rand(1..6)
random.rand(1..6)
random.rand(1..6)
~~~~

乱数生成のシードは、乱数ジェネレータの初期化時に指定できる。
これは同じ乱数列を得たい場合に使用できる。

~~~~
random1 = Random.new(1)
p random1.rand #=> 0.417022004702574
p random1.rand #=> 0.7203244934421581
p random1.rand #=> 0.00011437481734488664

random2 = Random.new(1)
p random2.rand #=> 0.417022004702574
p random2.rand #=> 0.7203244934421581
p random2.rand #=> 0.00011437481734488664
~~~~

ちょっとした変化球もある。
数値自体ではなく、UUIDのようなランダムな16進数文字列を得たい場合、SecureRandomモジュールが利用できる。

~~~~
require 'securerandom'
SecureRandom.hex(16) #=> "7dbf76da3da939f1a672512a35681aef"
~~~~

参考

- [How to get a random number in Ruby?](http://stackoverflow.com/questions/198460/how-to-get-a-random-number-in-ruby/2773866#2773866)
