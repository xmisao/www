---
layout: blog
title: jekyllでタグの一覧を出力する / タグが付いたページの一覧を出力する
tag: jekyll
---



# jekyllのタグのデータ構想

jekyllのタグには`site.tags`でアクセスできる。
`site.tags`は以下のようなイメージのハッシュである。

~~~~
{タグA => [ページ1, ページ2, ページ3],
 タグB => [ページ4, ページ5, ページ6],
 タグC => [ページ7, ページ8, ページ9]}
~~~~

# タグの一覧を出力する

これを踏まえて。
サイトの全タグを一覧するLiquidテンプレートは以下のように書ける。

~~~~
{% raw %}{% for tag in site.tags %}
  {{ tag | first }}
{% endfor %}{% endraw %}
~~~~

Liquidでは`for`でハッシュを走査すると配列が得られ`[0]`の要素にキーが、`[1]`の要素に値が格納される。

タグ名はキーなので、`first`で先頭の要素のみ取り出してやることでタグの一覧が得られる。

# タグが付いたページの一覧を出力する

`site.tags`の値は、キーのタグが付けられたページの配列となっている。

以下は`jekyll`タグが付けられたページをタイトルの一覧するLiquidテンプレートの例だ。

~~~~
{% raw %}{% for post in site.tags['jekyll'] %}
  {{ post.title }}
{% endfor %}{% endraw %}
~~~~

- 参考
  - [An easy way to support tags in a jekyll blog](http://stackoverflow.com/questions/1408824/an-easy-way-to-support-tags-in-a-jekyll-blog)
