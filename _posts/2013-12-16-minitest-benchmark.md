---
layout: blog
title: minitestによるベンチマークテストの記述
tag: ['ruby']
---

# minitestによるベンチマークテストの記述

あるアルゴリズムのパフォーマンスが期待通りの計算量であるか、テストを記述したい事がある。Rubyのテスティングフレームワークである`minitest`には、そのようなベンチマークテストを記述する機能が用意されている。

何か時間のかかる処理をするクラスを考える。
以下はひどい例だが `1000 x n`回のループを回すクラスである。
このクラスのパフォーマンスが本当に線形かをテストしてみよう。

- loop.rb

~~~~
class Loop
	def do_loop(n)
		(1000 * n).times
	end
end
~~~~

ベンチマークテストの記述には`minitest/benchmark`を`require`してやる必要がある。
ベンチマークテストは`bench`をつけたメソッドに記述する。
`assert_performance_linear`は、パフォーマンスが線形かを確認するメソッドだ。
このメソッドはブロックに1, 10, 100, 1000, 10000の値を与えた時の、ブロックの実行速度を確認する。
引数に与えているのは誤差で、この場合はパフォーマンスが`(1 / 0.9) * n`の範囲内で推移すればテストが成功となる。

- test_loop.rb

~~~~
require 'minitest'
require 'minitest/autorun'
require 'minitest/benchmark'
require_relative 'loop.rb'

class Test < Minitest::Benchmark
	def setup
		@loop = Loop.new
	end 

	def bench_my_algorithm
		assert_performance_linear 0.9 do |n| 
			@loop.do_loop(n)  
		end 
	end 
end
~~~~

`test_loop.rb`の実行結果は以下のようになる。
テストは成功しており、確かに`loop.rb`は線形のパフォーマンスを持っていることが確認できた。

~~~~
$ ruby test_loop.rb 
Run options: --seed 29223

# Running:

bench_my_algorithm       0.000087        0.000724        0.007775        0.072802        0.734182
.

Finished in 0.826933s, 1.2093 runs/s, 1.2093 assertions/s.

1 runs, 1 assertions, 0 failures, 0 errors, 0 skips
~~~~
