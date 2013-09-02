---
layout: blog
title: BestGems Pickup! 第3回 「tilt」
tag: "bestgems_pickup"
---

# BestGems Pickup! 第3回 「tilt」

拙作の[BestGems](http://bestgems.org/)から注目のGemを紹介するエントリー。第3回は「[tilt](https://github.com/rtomayko/tilt/)」を取り上げる。

## 概要

tiltは各種テンプレートエンジンへの汎用インターフェイスを標榜するライブラリだ。erbやhaml、markdown等のあらゆるテンプレートで、エンジンの実装に依存することなく、同一の操作で整形結果を生成することができる。今日現在、公式サイトでサポートが表明されているテンプレートエンジン数は25にも及ぶ。

tiltは今日現在、合計ダウンロードランキング21位、デイリーダウンロードランキング9位につけている。

## インストール

    gem install tilt

## 使用例

### 例1 Tilt.newによる初期化

簡単な使い方は、使用したいテンプレートエンジンを予めrequireしておく方法だ。
この例ではerbを使うことにする。
Tilt.newでテンプレートを読み込む。renderメソッドで出力結果が得られる。

    require 'tilt'
    template = Tilt.new('foo.erb')
    output = template.render
    p output

foo.erbの内容は以下のとおり。

    Hello, World!

出力結果は以下のとおり。

    "Hello, World!\n"

### 例2 テンプレート用クラスによる初期化

Tiltライブラリが提供するテンプレート用クラスを使えば、明示的にテンプレートエンジンをrequireする必要はない。
またrenderメソッドにブロックを渡せば、その内容をテンプレートに渡すことができる。

    require 'tilt/erb'
    template = Tilt::ERBTemplate.new('bar.erb')
    output = template.render{ 'Joe' }
    p output

bar.erbの内容は以下のとおり。

    Hey <%= yield %>!

出力結果は以下のとおり。

    "Hey Joe!\n"

### 例3 テンプレートへの埋め込み

もう少し複雑な例を出してみよう。
renderメソッドは引数に渡したオブジェクトのコンテキストで、テンプレートに埋め込みを行うことができる。
この例ではclazzインスタンスのインスタンス変数を出力させている。

    class Clazz
    	attr_accessor :x
    
    	def initialize(x, y)
    		@x, @y = x, y
    	end
    end
    
    require 'tilt/erb'
    template = Tilt::ERBTemplate.new('buz.erb')
    
    clazz = Clazz.new(12, 34)
    
    output = template.render(clazz)
    p output

buz.erbの内容は以下のとおり。

    x = <%= x %>
    y = <%= @y %>

    "x = 12\ny = 34\n"

### 例4 erb以外のテンプレートエンジンの利用

erbばかりではつまらないので、Hamlテンプレートを使ってみる。
テンプレートの生成から、レンダリングまでの手順がerbの場合と全く同じ事に注目して欲しい。
なおrenderには、追加で引数を与えて、テンプレートに埋め込む事も可能だ。
この例ではselfのコンテキストのvalが埋め込まれる。

    require 'tilt'
    template = Tilt.new('puz.haml')
    output = template.render(nil, :val => 1234)
    p output

puz.hamlの内容は以下のとおり。

    %li hoge
    %li piyo
    %li fuga
    %li= val

出力結果は以下のとおり。

    "<li>hoge</li>\n<li>piyo</li>\n<li>fuga</li>\n<li>1234</li>\n"

## 解説

tiltを使えば、複数のテンプレートエンジンを使っていても、renderメソッドを呼ぶだけで、その違いを意識することなく扱うことができる。

ぱっと思いつく用途は、ユーザに任意のテンプレートでコンテンツを記述させて、それをHTMLに出力するwikiのようなプログラムだろうか。

tiltを使えば、プログラミングの負担を抑えて、お気に入りのテンプレートを混在させたサイトを自在に作ることができる。ものづくりの幅を広げてくれるライブラリだ。
