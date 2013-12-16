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
ブロックを実行した結果、実行速度が*y = a + bx*の形で線形に推移すればテストが成功となる。

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
		assert_performance_linear do |n| 
			@loop.do_loop(n)  
		end 
	end 
end
~~~~

`test_loop.rb`の実行結果は以下のようになる。(注:マシンの性能により結果は異なるかも知れない)
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

なお`minitest/benchmark`には`assert_performance_linear`の他にも様々なパターンの計算量をテストできるメソッドが用意されている。

|メソッド|意味|
|:-|:-|
|assert_performance|実行時間を表示するのみ|
|assert_performance_constant|実行時間が常に一定かをテストする|
|assert_performance_exponential|実行時間が*y = ae^(bx)*の形で指数的に増加するかをテストする|
|assert_performance_logarithmic|実行時間が*y = a + b*ln(x)*の形で対数的に増加するかをテストする|
|assert_performance_linear|実行時間が*y = a + bx*の形で線形に増加するかをテストする|
|assert_performance_power|実行時間が*y = ax^b*の形でべき乗で増加するかをテストする|
