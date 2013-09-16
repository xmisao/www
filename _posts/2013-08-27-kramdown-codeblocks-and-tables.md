---
layout: blog
title: kramdownのコードブロックとテーブル記法について
tag: markdown
---

# kramdownのコードブロックとテーブル記法について

技術系の文章をMarkdownで書いていると、コードブロックとテーブルを多用する。このエントリーでは、RubyのMarkdownパーサであるkramdownでこれらの記法の使い方をまとめる。

詳しくは公式のシンタックスリファレンスを参照。

[http://kramdown.rubyforge.org/quickref.html](http://kramdown.rubyforge.org/quickref.html)

## コードとコードブロック

コードはバッククオートで記述できる。

    This is `code`.

This is `code`.

先頭に4文字空白を入れると、それがコードブロックになる。

~~~
    hoge
~~~

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

言語を指定することもできる。
これは末尾で`{: .language-ruby}`するのと同一。

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
|efg|hij|20,000|
~~~

|Left|Center|Right|
|:-|:-:|-:|
|abc|def|10,000|
|efg|hij|20,000|

ちなみにクラスで装飾したい場合は末尾に{}をつけて指定できる。
これは他の記法でも一緒。

例えばTwitter Bootstrapを使っていて、tableクラスとtable-stripedクラスを指定したい場合は以下。

~~~
|Left|Center|Right|
|:-|:-:|-:|
|abc|def|10,000|
|efg|hij|20,000|
{: .table .table-striped}
~~~

|Left|Center|Right|
|:-|:-:|-:|
|abc|def|10,000|
|efg|hij|20,000|
{: .table .table-striped}
