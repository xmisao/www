---
layout: blog
title: Rubyでサブクラスの一覧を取得する方法
tag: ruby
---

# Rubyでサブクラスの一覧を取得する方法

## ActiveSupportを使った方法

ActiveSupportを使っていれば`Class`が拡張されて`Class.subclasses`メソッドが使えるようになっている。このメソッドはクラスのサブクラスの配列を返すものだ。例えばIntegerのサブクラスを得るには、以下のようにする。

~~~~
require 'active_support/core_ext/class/subclasses'

p Integer.subclasses #=> [Fixnum, Bignum]
~~~~

## ActiveSupportを読む

これだけではつまらないので、ActiveSupportのソースコードを読んで、どのようにサブクラスを見つけているのか調べてみよう。定義は`subclasses.rb`である。

~~~~
require 'active_support/core_ext/module/anonymous'
require 'active_support/core_ext/module/reachable'

class Class
  begin
    ObjectSpace.each_object(Class.new) {}

    def descendants # :nodoc:
      descendants = []
      ObjectSpace.each_object(singleton_class) do |k|
        descendants.unshift k unless k == self
      end
      descendants
    end
  rescue StandardError # JRuby
    def descendants # :nodoc:
      descendants = []
      ObjectSpace.each_object(Class) do |k|
        descendants.unshift k if k < self
      end
      descendants.uniq!
      descendants
    end
  end

  # Returns an array with the direct children of +self+.
  #
  #   Integer.subclasses # => [Fixnum, Bignum]
  #
  #   class Foo; end
  #   class Bar < Foo; end
  #   class Baz < Bar; end
  #
  #   Foo.subclasses # => [Bar]
  def subclasses
    subclasses, chain = [], descendants
    chain.each do |k|
      subclasses << k unless chain.any? { |c| c > k }
    end
    subclasses
  end
end
~~~~

通常の実装とJRuby用の実装があり少々わかりにくいが、`descendants`が実装の肝である。抜粋してみる。

~~~~
    def descendants # :nodoc:
      descendants = []
      ObjectSpace.each_object(singleton_class) do |k|
        descendants.unshift k unless k == self
      end
      descendants
    end
~~~~

`singleton_class`メソッドでクラスを取得し、`ObjectSpace.each_object`に渡している。`ObjectSpace.each_object`は、与えられたクラスに対して以下の動作をする。

> 指定された klass と Object#kind_of? の関係にある全ての オブジェクトに対して繰り返します。引数が省略された時には全てのオブ ジェクトに対して繰り返します。 繰り返した数を返します。 

ようはkind_of?の関係、クラスを継承しているクラスが子孫代々すべて取得できるわけだ。`unless`修飾子は親クラス自身をリストに含めないためにつけられている。

続いて`descendants`の呼び出し元の`subclasses`メソッドを見てみる。こちらは特に難しいことはしておらず、クラスの配列から親クラスが配列中に含まれていないクラス、つまりサブクラスだけを抽出している。親がリストに含まれている孫クラスはすべて除外されて、親がリストに含まれていない子クラスだけが残るわけだ。

~~~~
  def subclasses
    subclasses, chain = [], descendants
    chain.each do |k|
      subclasses << k unless chain.any? { |c| c > k }
    end
    subclasses
  end
~~~~

## 自分でサブクラスを取得してみる

以上で、サブクラスを取得する仕組みがわかった。
やっていることは簡単なのだが、ActiveSupportの`subclasses`の実装は、`descendants`をJRuby対応させたことで妙に複雑になってしまっているように見える。
JRubyを考慮しなければ、`subclasses`の実装は以下で良いような気がする。直接`ObjectSpace.each_object`を呼び出し、`self`を親に持たないクラスを除外する。

~~~~
class Class
	def subclasses
		subclasses = []
		ObjectSpace.each_object(singleton_class) do |k|
			subclasses << k if k.superclass == self
		end
		subclasses
	end
end

p Integer.subclasses #=> [Bignum, Fixnum]
~~~~
