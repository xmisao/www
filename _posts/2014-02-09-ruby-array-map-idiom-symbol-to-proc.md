---
layout: blog
title: Rubyの[1, 2, 3].map(&:to_s)的なイディオムとSymbol#to_procについて
tag: ruby
---

# Rubyの[1, 2, 3].map(&:to_s)的なイディオムとSymbol#to_procについて

ちょっと凝ったRubyのソースコードで良く目にする`[1, 2, 3].map(&:to_s)`のようなイディオムについて書いておきたい。まず以下はすべて同じ結果となる。

~~~~
[1, 2, 3].map(&:to_s) #=> ["1", "2", "3"]
[1, 2, 3].map(&:to_s.to_proc) #=> ["1", "2", "3"]
[1, 2, 3].map{|n| n.to_s} #=> ["1", "2", "3"]
~~~~

このイディオムは`Symbol`が`to_proc`メソッドを持っているから実行可能になっている。(※標準で使えるのはRuby 1.8.7以降、それ以前はActiveSupportで定義されていた)
というのもブロック付きメソッドを呼び出す際に`to_proc`メソッドを持つオブジェクトは`&`修飾して引数に渡せる決まりだからである。このことはリファレンスに書かれている。

- [ブロック付きメソッド呼び出し](http://docs.ruby-lang.org/ja/1.9.3/doc/spec=2fcall.html#block)

> to_proc メソッドを持つオブジェクトならば、'&' 修飾した引数として渡すことができます。デフォルトで Proc、Method オブジェ クトは共に to_proc メソッドを持ちます。to_proc はメソッド呼び出し時に実行され、Proc オブジェクトを返すことが期待されます。 

そして`Symbol#to_proc`の実装は以下のようになっているらしい。これを見ると冒頭のイディオムも理解しやすいのではないだろうか。`Symbol#to_proc`は何かのオブジェクトを引数にとって、何かのオブジェクトに対してシンボルと同名のメソッドを呼び出す`Proc`オブジェクトを返すのだ。

~~~~
class Symbol
  def to_proc
    Proc.new do |obj, *args|
      obj.send self, *args
    end
  end
end
~~~~

つまりブロック付きメソッド呼び出しの`()`内の`&:to_s`は`&:to_s.to_proc`と同じであり、この`Proc`オブジェクトの処理内容は`{|obj, &args| obj.send :to_s, *args}`であるかのように振る舞うのである。これで、このイディオムが`[1, 2, 3].map{|n| n.to_s}`と同じ結果になることが理解できる。

- [What does map(&:name) mean in Ruby?](http://stackoverflow.com/questions/1217088/what-does-mapname-mean-in-ruby)
