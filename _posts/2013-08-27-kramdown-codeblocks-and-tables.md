---
layout: default
title: kramdownのコードブロックとテーブル記法について
tag: markdown
---

# kramdownのコードブロックとテーブル記法について

RubyのMarkdownパーサであるkramdownは、シンタックスハイライト付きのコードブロックと、書きやすいテーブルを備えている。このエントリでは、これら2つの記法の使い方を取り上げる。

詳しくは公式のシンタックスリファレンスを参照。

[http://kramdown.rubyforge.org/quickref.html](http://kramdown.rubyforge.org/quickref.html)

## コードブロック

4文字空白を入れると、それがコードブロックになる。

        hoge

    hoge

~の線で囲んだ範囲がコードブロックになる。

~~~~~
~~~
foo
bar
buz
~~~
~~~~~

~~~
foo
bar
buz
~~~

言語を指定するとシンタックスハイライトが可能。

~~~~~
~~~ ruby
def hoge
	'piyo'
end
~~~
~~~~~

~~~ ruby
def hoge
	'piyo'
end
~~~

## テーブル記法

テーブルには|を使う。

~~~
|aaa|bbb|
|ccc|ddd|
|eee|fff|
~~~

|aaa|bbb|
|ccc|ddd|
|eee|fff|

ヘッダをつけたい場合は:と-で以下のような行を挿入する。
それぞれ左揃え、中央揃え、右揃えとなる。

~~~
|Left|Center|Right|
|:-|:-:|-:|
|abc|def|10,000|
~~~

|Left|Center|Right|
|:-|:-:|-:|
|abc|def|10,000|

ちなみにクラスで装飾したい場合は末尾に{}をつけて指定できる。
これは他の記法でも一緒。

例えばTwitter Bootstrapを使っていて、tableクラスとtable-stripedクラスを指定したい場合は以下。

~~~
|aaa|bbb|
|ccc|ddd|
|eee|fff|
{: .table .table-striped}
~~~

|aaa|bbb|
|ccc|ddd|
|eee|fff|
{: .table .table-striped}
