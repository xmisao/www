---
layout: blog
title: BestGems Pickup! 第8回 「what_methods」
tag: bestgems_pickup
---



拙作の[BestGems](http://bestgems.org/)から注目のGemを紹介するエントリー。第8回は「[what_methods](https://rubygems.org/gems/what_methods)」を取り上げる。

# 概要

what_methodsは非常にユニークなgemだ。what_methodsが提供する機能はただ1つ、メソッドを逆引きすることである。引数と期待する返り値を与えると、実際にその結果を返すメソッドの一覧を教えてくれる。

what_methodsは今日現在、合計ダウンロードランキング2,887位、デイリーダウンロードランキング4,015位につけている。"best"なgemとは言いがたい順位ではあるが、面白いgemなので紹介する。

# インストール

    gem install what_methods

# 使用例

もしRubyで文字列"abc"に対して、"def"という文字列を得たいとしたら、あなたはどんなコードを書くだろうか? 私は以下のコードをぱっと思いつく。だが、果たしてこれが唯一無二のコードだと言えるだろうか。

~~~~
"abc".sub("abc", "def") # => "def"
~~~~

これをwhat_methodsに聞いてみよう。文字列"abc"に対して、引数"def"を与えてみて、結果が"def"となるメソッドは他にあるのだろうか。以下のコードを実行すれば、その答えがわかる。

~~~~
require 'what_methods'

"abc".what?("def", "abc", "def")
~~~~

~~~~
"abc".[]=("abc", "def") == "def"
"abc".sub("abc", "def") == "def"
"abc".gsub("abc", "def") == "def"
"abc".sub!("abc", "def") == "def"
"abc".gsub!("abc", "def") == "def"
"abc".tr("abc", "def") == "def"
"abc".tr_s("abc", "def") == "def"
"abc".tr!("abc", "def") == "def"
"abc".tr_s!("abc", "def") == "def"
~~~~

何という事だろう! 文字列"abc"に対して、引数"abc"と"def"を与えた時、結果として"def"を返す書き方が、実に9つも存在している。置換を行う代表的なメソッドである`sub`以外にも、その破壊的メソッドの`sub!`、全置換を行う`gsub`と`gsub!`、文字変換を行う`tr`、`tr_s`、`tr!`、`tr_s!`でも同様の変換が可能であるとわかった。

個人的に興味深いのは`[]=`演算子でも置換が行えるとわかったことだ。`String`の`[]`は部分文字列の切り出しなど多彩な機能を持っているが、実はリファレンスを読むと`[]=`の形とすると文字列や正規表現による置換、または文字列の位置を指定した置換が行える。事実、以下のコードは"def"を返す。

~~~~
"abc"["abc"] = "def" # => "def"
~~~~

# 解説

話をwhat_methodsの機能に戻そう。what_methodsが提供する機能はシンプルで、`Object`に対して`what?`メソッドを追加するというものだ。これにより、あらゆるオブジェクトに対して`what?`が使用可能となる。

`what?`メソッドは期待する値とメソッドへの引数を取り、該当するメソッドがあれば結果を標準出力へ出力する。使用方法は使用例で説明したとおりである。なお`what?`はブロック付きメソッドを正しく扱うことはできず、ブロックの内容は無視される。

what_methodsには`what?`より詳細な2つの機能がある。これらは`WhatMethods::MethodFinder`クラスに定義された`find`メソッドと`show`メソッドである。

`find`メソッドはレシーバとなるオブジェクト、期待する結果、レシーバに与える引数、メソッド呼び出し時のブロックを取り、実際に期待する結果を返すメソッドのシンボル一覧を配列で返す。`what?`とは異なり、ブロック付きメソッドを扱うことができるのだ。以下に例を示す。

~~~~
require 'what_methods'

# find( anObject, expectedResult, *args, &block)
p WhatMethods::MethodFinder.find("Hello, World!", "Hello, Ruby!", "World"){|str|
	"Ruby"
}
~~~~

~~~~
[:sub, :gsub, :sub!, :gsub!]
~~~~

`show`は`find`と同時に結果を見やすく標準出力へ出力するメソッドである。実は冒頭で紹介した`Object#what?`は、内部で`WhatMethods::MethodFinder.show`を呼び出しているだけである。以下に使用例と出力結果の例を示す。

~~~~
require 'what_methods'

# show( anObject, expectedResult, *args, &block)
WhatMethods::MethodFinder.show("Hello, World!", "Hello, Ruby!", "World"){|str|
	"Ruby"
}
~~~~

~~~~
"Hello, World!".sub("World") == "Hello, Ruby!"
"Hello, World!".gsub("World") == "Hello, Ruby!"
"Hello, World!".sub!("World") == "Hello, Ruby!"
"Hello, World!".gsub!("World") == "Hello, Ruby!"
~~~~

# まとめ

以上のようにwhat_methodsは引数と期待する結果から、メソッドを簡単に逆引きすることができるgemである。既知のメソッド以外に別の書き方が無いのかirbを使って色々と試してみるのも面白いだろう。また引数に当たりをつけてwhat_methodsを使うことで、どのメソッドを呼び出せば期待する結果が得られるのか、調査する用途にも利用できる。

なおwhat_methodsの実装は100行に満たないコンパクトなgemとなっている。メソッドの探索にはリフレクションを利用しているので、リフレクションのお手本として読んでみるのも面白い。様々な意味でRubyの深さを再実感させてくれるgemである。
