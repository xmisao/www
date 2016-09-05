---
layout: blog
title: Rubyの軽量スレッドFiberを利用する
tag: ruby
---



パーフェクトRubyを読んでいて目に止まったので、Ruby 1.9から導入すあれた軽量スレッド`Fiber`を使ってみよう。

`Thread`と`Fiber`の最大の違いは、コンテキストの切り替えをプログラマが明示的に指定することだ。
`Fiber`を使えば、結果全体を作るのに大きなコストのかかる処理を段階的に実行させて、部分的な結果を随時取り出すような実装が可能になる。

`Fiber`は`Fiber.new`で生成し、ブロックで`Fiber`で実行する処理内容を記述する。`Fiber`の実行は`Fiber#resume`の呼び出しで行う。処理は`Fiber.yield`でいったん停止して、呼び出し元に戻る。停止した`Fiber`の再実行は、同じく`Fiber#resume`で行う。実行できる処理がなくなった状態で`Fiber#resume`を呼び出すと、`FiberError`が発生する。

~~~~
fiber = Fiber.new do
	puts "First"
	Fiber.yield
	puts "Second"
end

fiber.resume # "Fisrt"
fiber.resume # "Second"
fiber.resume # FiberError
~~~~

`Fiber`には引数と戻り値がある。`Fiber#resume`の引数は、ブロック引数として`Fiber`内部の処理に渡される。また`Fiber.yield`の引数は、`Fiber#resume`の戻り値となる。指定した値まで整数を順に返すジェネレータを実装してみると以下のようになる。

~~~~
fiber = Fiber.new do |num|
	num.times do |i|
		Fiber.yield i
	end
end

p fiber.resume 3 # 0
p fiber.resume   # 1
p fiber.resume   # 2
p fiber.resume   # 3
p fiber.resume   # FiberError
~~~~
