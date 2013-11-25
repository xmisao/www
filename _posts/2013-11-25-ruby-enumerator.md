---
layout: blog
title: Ruby 1.9のEnumeratorによる繰り返し処理
tag: ruby
---

# Ruby 1.9のEnumeratorによる繰り返し処理

Ruby 1.9以降では`Array#each`をはじめとする繰り返し処理が、Enumeratorクラスを通じて行われるようになった。例えば`[].each`は`Enumerator`を返す。

~~~~
p [].each #<Enumerator: []:each>
~~~~

繰り返しが`Enumerator`で行われるようになったことで、繰り返し処理をより柔軟に記述できるようになった。

Ruby 1.8では`Array`の中身を添字と共に取得する`Array#each_with_index`が提供されていた。しかし`map`や`select`など別のイテレータメソッドで添字に基づいた処理を実装するには、自分で添字を管理する必要があった。

これをRuby 1.9からは`Enumerator`を返す各種イテレータメソッドと、`Enumerator#with_index`の組み合わせで実装できるようになった。例えばアルファベットの配列から偶数番目の要素だけを大文字化するスクリプトは以下のように書ける。

~~~~
p ['a', 'b', 'c'].map.with_index{|elm, index|
	if index % 2 == 0	
		elm.capitalize
	else
		elm	
	end
}
~~~~

繰り返しが`Enumerator`で提供されたことで、外部イテレータも利用できるようになった。外部イテレータは、繰り返しのタイミングを自由にコントロールすることができる。

外部イテレータのメソッドは、`Enumerator#next`だ。このメソッドは実行する度に繰り返しを行い処理を行う。例えば2つの配列を同時に繰り返し、組み合わせて表示する処理は以下のように書ける。

~~~~
name = ['alice', 'bob']
age = [18, 20]

name_enum = name.to_enum
age_enum = age.to_enum

loop do
	puts name_enum.next, age_enum.next
end
~~~~
