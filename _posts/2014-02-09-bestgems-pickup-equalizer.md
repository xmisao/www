---
layout: blog
title: BestGems Pickup! 第10回 「equalizer」
tag: bestgems_pickup
---



拙作の[BestGems](http://bestgems.org/)から注目のGemを紹介するエントリー。第10回は「[equalizer](https://rubygems.org/gems/equalizer)」を取り上げる。

# 概要

equalizerはクラスの同値性を簡単に比較できるようにする小さなモジュールだ。

equalizerは今日現在、合計ダウンロードランキング963位、デイリーダウンロードランキング292位につけている。まだメジャーとは言えないが、人気上昇中のGemと言える。

# インストール

    gem install equalizer

# 使用例

equalizerを使えば自分で定義したクラスに同値性を比較する機能を簡単に追加することができる。以下は座標をあらわす`GeoLocation`クラスに同値性を比較する処理をequalizerで追加する例である。

~~~~
require 'equalizer'

class GeoLocation
  # これで@latitudeと@longitudeが共に等しければオブジェクトが同値と見なされる
  include Equalizer.new(:latitude, :longitude)

  attr_reader :latitude, :longitude

  def initialize(latitude, longitude)
    @latitude, @longitude = latitude, longitude
  end
end

point_a = GeoLocation.new(1, 2)
point_b = GeoLocation.new(1, 2)
point_c = GeoLocation.new(2, 2)

# inspectの内容もわかりやすく変更される
p point_a.inspect    # => "#<GeoLocation latitude=1 longitude=2>"

# 同値のオブジェクトを各メソッドで比較した場合
p point_a == point_b           # => true
p point_a.hash == point_b.hash # => true
p point_a.eql?(point_b)        # => true
p point_a.equal?(point_b)      # => false

# 同値でないオブジェクトを各メソッドで比較した場合
p point_a == point_c           # => false
p point_a.hash == point_c.hash # => false
p point_a.eql?(point_c)        # => false
p point_a.equal?(point_c)      # => false
~~~~

この例からわかるように使い方は簡単である。単に同値性を実装したいクラスで、`Equalizer.new`で生成したモジュールを`include`してやれば良い。`Equalizer.new`には同値性を比較する際に、比較対象とするインスタンス変数のシンボルを渡す。

これだけでオブジェクトの同値性を正しく判断できるようになり、さらに`inspect`の出力も標準より見やすく変更される。`inspect`の結果からは、見苦しいオブジェクトIDはなくなり、同値性の比較で比較対象になるインスタンス変数だけが含まれるようになる。

# 解説

equalizerは以下のメソッドを定義することで、オブジェクトの同値性の比較を可能にする。`cmp?`はequalizerの内部処理に使われるprivateメソッドであり、ユーザが意識する必要はない。

- `cmp?`
- `hash`
- `inspect`
- `eql?`
- `==`

`hash`、`eql?`、`==`はいずれも同値性を比較するために実装しなければならないメソッドだ。equalizerはこれらのメソッドを、指定したインスタンス変数の値が共に等しければ同値であると見なすように定義する。

equalizerは`equal?`を定義しないことに注意しよう。`equal?`はオブジェクトが同一かどうかを判定するメソッドであり、同値であるかを判定するメソッドではない。使用例で`equal?`が`false`になることを明示しているのはこのためだ。

Rubyでのメタプログラミングに慣れていない人は、`Equalizer.new`したモジュールを`include`するという使い方が新鮮に感じるかも知れない。実は`Equalizer`は`Module`を継承したサブクラスとなっており、`Equalizer.new`で同値性を比較するメソッドを定義する新たなモジュールが生成されるという仕組みである。

`Equalizer`の実装は120行余りとシンプルだが、Rubyのメタプログラミングの要素がふんだんに盛り込まれており、メタプログラミングの活用例として、コードリーディングするのもおすすめだ。

# まとめ

Rubyでオブジェクトの同値性が正しく評価されるようにしてやるには、いくつかのメソッドを注意深く実装してやる必要がある。得てして同値性の比較を自分で実装したい場合は何か複雑なことをしていることも多く、果たして同値性の比較が`Hash`など他のクラスの中で正しく機能するのか、不安に思うこともあるだろう。

equalizerはこれを代行してくれるGemである。equalizerで実装できる同値性の比較は、インスタンス変数の比較というシンプルなものだが、多くの場合はこの実装で問題はないだろう。equalizerのシンプルな実装を見ていると、なぜこの機能が標準で用意されていないのか不思議にさえ思えてくる。

同値性の評価をequalizerを使って実装することで、実装のより本質的な部分に注力できる。equalizerは初心者から上級者までRubyistにとって役立つgemと言えるだろう。
