---
layout: default
title: BestGems Pickup! 第4回 「Slop」
tag: "bestgems_pickup"
---

# BestGems Pickup! 第4回 「Slop」

拙作の[BestGems](http://bestgems.org/)から注目のGemを紹介するエントリー。第4回は「[Slop](https://github.com/leejarvis/slop)」を取り上げる。

## 概要

Slopはコマンドラインオプションのパーサだ。Rubyスクリプトに渡された引数をハッシュとして受け取ったり、サブコマンドを簡単に実装したりすることができる。

Slopは今日現在、合計ダウンロードランキング111位、デイリーダウンロードランキング73位につけている。

## インストール

    gem install Slop

## 使用例

### 基本的な使い方

文字列を受け取るnameオプションと、v(またはverbose)オプションを持つスクリプトを作ろう。
foo.rbを以下の内容とする。

    require 'slop'
    
    opts = Slop.parse do
    		on 'name=', 'Your name'
    		on 'v', 'verbose', 'Enable verbose mode'
    end
    
    p opts[:name]
    p opts.verbose?
    p opts.v?
    p opts.to_hash

foo.rbを実行するとこのとおり。

    foo.rb --name hoge -v

    "hoge"
    true
    true
    {:name=>"hoge", :verbose=>true}

Slopでパースを行うには、まずSlop.parseまたはSlop.newでSlopを初期化する。
初期化時に渡したブロック内でオプションの定義を行う。
オプションの定義にはonを使う。

onの書式をまとめると以下のとおりだ。
複数のオプション名、説明、ハッシュ形式の追加の引数を指定できる。

    on オプション名1[, オプション名2, ... , オプション名N][, 説明][, ハッシュ]

'name='のような、末尾に=をつけたオプション名のオプションは、文字列になる。
一方、'v'のような、末尾に=をつけないオプション名のオプションは、真偽値になる。

パースしたオプションの値は、ハッシュのように[オプション名]で取り出せる。
真偽値のオプションはメソッド化され、オプション名?メソッドで取り出せる仕組みだ。

### ヘルプの追加

上で作成したfoo.rbに--helpで見られるヘルプを追加しよう。
foo.rbを改造して以下の内容にする。

    require 'slop'
    
    opts = Slop.parse(:help => true) do
        banner "Usage: foo.rb [options]"
    		on 'name=', 'Your name'
    		on 'v', 'verbose', 'Enable verbose mode'
    end

Slopを使えばヘルプを自力で書く必要はない。
Slopの初期化時にhelp => trueを追加する。
またヘルプで表示するメッセージをbannerで定義する。

これでヘルプが実装できた。早速表示してみよう。

    foo.rb --help

すると以下のようなきれいなヘルプが出力される。

    Usage: foo.rb [options]
            --name         Your name
        -v, --verbose      Enable verbose mode
        -h, --help         Display this help message.

なおヘルプはSlopインスタンスのto_sメソッドやhelpメソッドでも取得できる。

    opts.help

### Slopの初期化設定

help以外にも、Slopの初期化は以下のようなオプションを取る。

- strict -- 未定義のオプションが指定されたらInvalidOperationErrorを発生させる。(デフォルトfalse)
- help -- --helpオプションを追加する。(デフォルトfalse)
- banner -- ヘルプのバナーテキストを指定する。(デフォルトnil)
- ignore_case -- 大文字と小文字を区別しない。(デフォルトfalse)
- autocreate -- オートクリエイト機能(後述)を有効にする。(デフォルトfalse)
- arguments -- すべてのオプションを必須にする。(デフォルトfalse)
- optional_arguments -- すべてのオプションを任意にする。(デフォルトfalse)
- multiple_switches -- -abcを-a -b -cのようにパースする。(デフォルトtrue)
- longest_flag -- ?

### オプションの型指定

オプションの定義で型を指定すれば、数値や範囲、リストとして引数を受け取ることができる。
bar.rbを以下の内容とする。

    require 'slop'
    
    opts = Slop.parse() do
    		on 'int=', 'Integer option.', :as => Integer
    		on 'list=', 'List option.', :as => Array
    		on 'range=', 'Range option.', :as => Range
    end
    
    p opts[:int]
    p opts[:list]
    p opts[:range]
    p opts.to_hash

bar.rbを実行すると以下のとおり。
引数が指定した型にパースされている。

    ruby bar.rb -int 123 -list a,b,c -range 1..10

    123
    ["a", "b", "c"]
    1..10
    {:int=>123, :list=>["a", "b", "c"], :range=>1..10}

### オートクリエイト機能

オートクリエイト機能は、onで定義していないオプションもSlopにパースさせる機能だ。

使い方はSlopの初期化時に:autocreate => trueを指定するだけだ。
オプションのチェックや型指定が必要ないなら、これを書いておくだけで十分だろう。

buz.rbを以下の内容とする。

    require 'slop'
    
    opts = Slop.parse(:autocreate => true)
    p opts.to_hash


適当にオプションを渡してbuz..rbを実行してみる。

    ruby buz.rb -a hoge -b piyo -c fuga

以下のとおりハッシュが得られる。

    {:a=>"hoge", :b=>"piyo", :c=>"fuga"}

### サブコマンドの実装

Slopにはサブコマンドを定義する機能があり、gitでいうgit addのようなサブコマンドを簡単に実装できる。

サブコマンドはcommandメソッドで定義する。コマンドラインでサブコマンドが指定されたら、runメソッドに与えたブロックが実行される。

qux.rbを以下の内容とする。

    require 'slop'
    
    opts = Slop.parse() do
    	on 'v' do
    			puts "Version 1.0"
    	end
    
    	command 'subcommand' do
    			on 'name=', 'Your name'
    			on 'v', 'verbose', 'Enable verbose mode'
    			run do |opts, args|
    				puts "You ran 'subcommand' with options #{opts.to_hash} and args: #{args.inspect}"
    			end
    	end
    end

qux.rbを実行してみよう。
-vでバージョン表示、subcommandが実行できる事を確認しよう。

    ruby qux.rb -v

    Version 1.0

    ruby qux.rb subcommand -name hoge piyo

    You ran 'subcommand' with options {:name=>"hoge", :verbose=>nil} and args: ["piyo"]

## 解説

ツールを1つ作るにも、複雑なオプションをパースするのは骨の折れる作業だ。
Slopを使えば、ARGVをこねくり回して、自力でオプションをパースする必要はない。
コマンドラインオプションのパースをSlopに任せてしまえば、本質的な実装に集中できるに違いない。
