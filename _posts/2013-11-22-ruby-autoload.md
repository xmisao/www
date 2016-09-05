---
layout: blog
title: Rubyでrequireのコストが無視できない場合はautoloadが使える
tag: ruby
---



[昨日](http://www.xmisao.com/2013/11/21/ruby-require-relative.html)に引き続きRubyのreuiqreに関する話題である。

`require`は実行された時に参照先を即座に読み込んでしまう。そのため`require`する対象が非常に大規模な場合、`require`にかかる時間やリソースが問題になる場合がある。そのような場合は`autoload`が助けになるかも知れない。

`autoload`はクラスやモジュールが実際に参照されるまで参照先の読み込みを行わない。頻繁に起動を繰り返すようなプログラムで、ごく稀にしか参照先を実際に実行しない場合などで、時間とリソースを節約することができる。

`autoload`の効果を確かめるために、少しプログラムを書いてみることにする。例えば以下のようなディレクトリ構造があるとしよう。

- hoge.rb
- lib
  - piyo.rb

ここで`piyo.rb`は以下の内容として、ロードされると同時にメッセージを出力するようにする。

~~~~
class Piyo
	puts "Piyo was loaded."
end
~~~~

`hoge.rb`の内容は以下とする。
もし1が入力された場合は`Piyo`を参照し、それ以外であれば何もせずに終了する。

~~~~
autoload :Piyo, "lib/piyo"

if gets.to_i == 1
	Piyo
else
	# 何もしない
end
~~~~

これを実行してみると以下のようになる。
確かに`Piyo`が参照された時だけ、`Piyo`が実際にロードされることがわかる。

~~~~
$ ruby hoge.rb
1
Piyo was loaded.
~~~~

~~~~
$ ruby hoge.rb
0
~~~~
