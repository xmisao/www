---
layout: blog
title: Rubyでキーワード引数を利用する(1.9以前、2.0以降)
tag: ruby
---



Ruby 1.9以前のバージョンではキーワード引数はサポートされていない。ただし、実引数を渡す際にブレースを省略できることを利用して、擬似的にキーワード引数を利用できる。デフォルト値はメソッド内で`merge()`などを使って設定する。また、もし適切でないハッシュが渡された場合のエラー処理は自力で実装してやらねばならない。

~~~~
def foobar(hash = {})
	default = {foo: 'a', bar: 'b'}
	hash = default.merge(hash)
	# 処理
end

foobar(foo: 'hoge', bar: 'piyo')
~~~~

Ruby 2.0以降のバージョンではキーワード引数がサポートされる。以下の例のように、仮引数にキーワードが指定できる。キーワード引数には必ずデフォルト値を設定しなければならない。また呼び出し時に、キーワードに存在しない引数が渡されると、`ArgumentError`が発生する。

~~~~
def foobar(foo: 'a', bar: 'b')
	# 処理
end

foobar(foo: 'hoge', bar: 'piyo')
~~~~
