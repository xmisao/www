---
layout: blog
title: BestGems Pickup! 第9回 「docile」
tag: bestgems_pickup
---



拙作の[BestGems](http://bestgems.org/)から注目のGemを紹介するエントリー。第9回は「[docile](https://rubygems.org/gems/docile)」を取り上げる。

# 概要

docileはあらゆるRubyのオブジェクトをDSLに変えてしまうGemである。
このGemは特にオブジェクトの初期化をBuilderパターンで行っている場合に便利だ。
この説明だけでは良くわからないかもしれないが、ともかく使用例を見てほしい。便利さは一目瞭然だ。

docileは今日現在、合計ダウンロードランキング574位、デイリーダウンロードランキング116位につけている。
docileは昨年11月から急速にダウンロード数を伸ばしている注目のGemである。

# インストール

    gem install docile

# 使用例

docileを使えば`Array`オブジェクトを操作するDSLを以下のように記述できる。
`with_array`は渡した`Array`オブジェクトをブロック内に記述したDSLで初期化するメソッドだ。

~~~~
def with_array(arr=[], &block)
  Docile.dsl_eval(arr, &block)
end

with_array([]) do
  push 1
  push 2
  pop
  push 3
end
# => [1, 3]
~~~~

より複雑な例として、Builderパターンを活用する例を考えよう。
Builderパターンとの組み合わせにより、docileは更に強力になるからだ。
ピザを表す`Pizza`クラスのインスタンスを初期化する以下の`PizzaBuilder`があったとする。

~~~~
Pizza = Struct.new(:cheese, :pepperoni, :bacon, :sauce)

class PizzaBuilder
  def cheese(v=true); @cheese = v; end
  def pepperoni(v=true); @pepperoni = v; end
  def bacon(v=true); @bacon = v; end
  def sauce(v=nil); @sauce = v; end
  def build
    Pizza.new(!!@cheese, !!@pepperoni, !!@bacon, @sauce)
  end
end
~~~~

通常`PizzaBuilder`は以下のような使い方をする。

~~~~
PizzaBuilder.new.cheese.pepperoni.sauce(:extra).build
#=> #<Pizza:0x00001009dc398 @cheese=true, @pepperoni=true, @bacon=false, @sauce=:extra>
~~~~

これをdocileを使ってラッピングし、`Pizza`を初期化するDSLを作ってみよう。
`pizza`はピザ初期化用のDSL呼び出しメソッドである。
`PizzaBuilder`を直接使ったメソッドチェインによる書き方より随分と可読性が向上していることがわかる。

~~~~
def pizza(&block)
  Docile.dsl_eval(PizzaBuilder.new, &block).build
end

@sauce_level = :extra

pizza do
  cheese
  pepperoni
  sauce @sauce_level
end
# => #<Pizza:0x00001009dc398 @cheese=true, @pepperoni=true, @bacon=false, @sauce=:extra>
~~~~

# 解説

docileはDSLを実行するため`dsl_eval`と`dsl_eval_immutable`の2つのメソッドを提供する。
この2つのメソッドはDSLで実行する内容が「命令型」であるか、「関数型」であるかにより使い分ける。
また`dsl_eval`はDSLに渡されたオブジェクトを変更するため、`.freeze`されたオブジェクトや数値オブジェクトなど対象がインミュータブルな場合は`dsl_eval_immutable`しか利用できない。

命令型のDSLを実行する`dsl_eval`の特徴は以下のとおり。

1. 各コマンドはDSLに渡されたオブジェクトの状態を変更する
2. 各コマンドのメソッド呼び出しの返却値は無視される
3. 実行したDSLの返却値はDSLに渡されたオブジェクトである

`dsl_eval`呼び出しの例は以下のようなものだ。
`String`オブジェクトをDSLで操作するために、破壊的なメソッドを呼び出している事に注目しよう。

~~~~
Docile.dsl_eval("Hello, world!") do
  reverse!
  upcase!
end
#=> "!DLROW ,OLLEH"
~~~~

これに対して関数型のDSLを実行する`dsl_eval_immutable`の特徴は以下のとおり。

1. DSLに渡されたオブジェクトの状態は変更されない
2. 各コマンドのメソッド呼び出しの返却値が次のコマンドのレシーバとなる
3. 実行したDSLの返却値は最後のコマンドの実行結果である

`dsl_eval_immutable`の呼び出し例を以下に2つ掲載する。
いずれの例もコマンドで呼び出すメソッドが非破壊的で、返却値が次のコマンドのレシーバになる事に注目しよう。

~~~~
Docile.dsl_eval_immutable("I'm immutable!".freeze) do
  reverse
  upcase
end
#=> "!ELBATUMMI M'I"
~~~~

~~~~
Docile.dsl_eval_immutable(84.5) do
  fdiv(2)
  floor
end
#=> 42
~~~~

その他、双方のメソッドに共通して、docileを使用する上で抑えておきたい特徴として以下がある。

1. メソッドの探索はDSLに渡されたオブジェクトからブロックのコンテキストの順に行う。
2. ローカル変数の探索はDSLに渡されたオブジェクトからブロックのコンテキストの順に行う。
3. インスタンス変数はブロックコンテキスト限定である。
4. DSLの実行はネストさせることができる。

# まとめ

docileがいかにしてRubyのオブジェクトをDSLに変えてしまうか、それがわかっていただけただろうか。
通常、このようなDSLを定義するには、リフレクション用メソッドを駆使する必要があるが、docileはいとも簡単にそれをやってのける。
docileはRubyのソース内でDSLライクな書き方をしたい場合に、手軽にそれを実現させてくれるGemと言えるだろう。
