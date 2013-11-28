---
layout: blog
title: Rubyの外部イテレータでブロックつきメソッドを利用する
tag: ruby
---

# Rubyの外部イテレータでブロックつきメソッドを利用する

[Ruby 1.9のEnumeratorによる繰り返し処理](http://www.xmisao.com/2013/11/25/ruby-enumerator.html)では、外部イレテータによる繰り返し処理について説明した。

今回はブロックつきのイテレータを、外部イテレータで書き下して見よう。まず外部イテレータを使わない、以下のプログラムを考える。配列を順にチェックし、`/li/`にマッチする要素だけを残したリストを作るプログラムだ。

~~~~
p ['Alice','Bob','Charlie'].select{|person| /li/ === person}
~~~~

これを外部イテレータで書き下す。`select`を呼び出すが、その際はブロックを与えず、`Enumerator`を得る。

`Enumerator`には次の要素を得る`next`と、ブロックの評価結果を与える`feed`メソッドがある。またイテレータの停止は、`StopIteration`例外により補足でき、`result`メソッドで返り値が得られる。

~~~~
enum = ['Alice','Bob','Charlie'].select
loop do
	begin
		person = enum.next
		enum.feed /li/ === person
	rescue StopIteration => e
		p e.result
		break
	end
end
~~~~
