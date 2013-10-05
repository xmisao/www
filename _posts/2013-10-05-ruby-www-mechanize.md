---
layout: blog
title: 楽々スクレイピング! Ruby Mechanizeの使い方
tag: ruby
---

# 楽々スクレイピング! Ruby Mechanizeの使い方

[Mechanize](http://mechanize.rubyforge.org/)はスクレイピングを補助するRubyライブラリだ。
MechanizeはCookieのやり取りをはじめ、Webサイトとのインタラクションを自動化してくれる。
`Net::HTTP`や`open-uri`では面倒なWebサイトへのアクセスを、Mechanizeを使えば簡単にRubyで記述することができる。
以下では拙作の[http://bestgems.org/](http://bestgems.org/)を対象として、Mechanize 2.7.0の基本的な使い方を説明する。

## 初期化とWebページの取得

MechanizeでWebページを取得するのは簡単だ。
`Mechanize`クラスを`new()`し、`get()`を呼びだせばWebページを取得できる。
Webページは`Mechanize::Page`オブジェクトになっている。

~~~~
require 'mechanize'

agent = Mechanize.new
page = agent.get('http://bestgems.org/')
p page
~~~~

Webページのソースコードを直接読みたい場合(これはMechanizeを使っているとさほど多くないと思うが)は、`body`にアクセスすれば良い。

~~~~
require 'mechanize'

agent = Mechanize.new
page = agent.get('http://bestgems.org/')
p page.body
~~~~

## リンク

Webページを取得した時点で、Mechanizeはページのリンクを抽出している。
`links`を使えばページ中の全リンクのリストが取得できる。

~~~~
require 'mechanize'

agent = Mechanize.new
page = agent.get('http://bestgems.org/')
p page.links
~~~~

リンクは`Mechanize::Page::Link`オブジェクトで、その`click()`を呼びだせばリンク先のページを取得することができる。
以下の例ではbestgems.orgの先頭のリンクを辿った先のページを取得する。

~~~~
require 'mechanize'

agent = Mechanize.new
page = agent.get('http://bestgems.org/')
p page.links[0].click
~~~~

なおリンクの文字列やリンク先そのものに関心があるなら、それぞれ`text`と`href`で取得できるようになっている。

~~~~
require 'mechanize'

agent = Mechanize.new
page = agent.get('http://bestgems.org/')
link = page.links[0]
p link.text
p link.href
~~~~

## フォーム

Mechanizeの強力な機能の1つが、フォームを扱えることだ。
リンクの時と同様に、ページのフォームのリストを`forms`で取得できる。

~~~~
require 'mechanize'

agent = Mechanize.new
page = agent.get('http://bestgems.org/')
p page.forms
~~~~

フォームは`Mechanize::Page::Form`オブジェクトだ。
このオブジェクトを通じて、フォームに任意の値を入力して、サブミットした先のページを取得させることができる。
フォームの各要素へのアクセスは、代入の形で行う。
この例ではqという名前の入力項目に、`q=`で値を設定し、bestgems.orgでx2chを検索した結果のページを取得している。

~~~~
require 'mechanize'

agent = Mechanize.new
page = agent.get('http://bestgems.org/')
form = page.forms[0]
form.q = 'x2ch'
p agent.submit(form)
~~~~

## スクレイピング

目的のページにたどり着く事ができたら、次にすることはページ中の要素を検索し内容を読み取ることだ。Mechanizeではページの`search()`メソッドがそれを助けてくれる。`search()`はXPathの文字列を引数に取り、検索した結果を返すメソッドだ。

以下の例では、bestgems.orgのトップページから、logoクラスのh1タグを検索している。検索結果は[Nokogiri](http://nokogiri.org/)のオブジェクトになっており、Nokogiriに慣れていれば、そこから更に別の内容を取り出すことも可能だ。

~~~~
require 'mechanize'

agent = Mechanize.new
page = agent.get('http://bestgems.org/')
p page.search('h1.logo')
~~~~

## おわりに

以上がMechanizeの基本的な使い方で、これだけ知っているだけでもかなりの事ができる。
Mechanizeのドキュメントの[Guide](http://mechanize.rubyforge.org/GUIDE_rdoc.html)と[Examples](http://mechanize.rubyforge.org/EXAMPLES_rdoc.html)には、より多くの使い方が例示されているので、詳しくはそちらを参照して欲しい。
このエントリがMechanizeによる快適なスクレイピングの導入となればうれしい。
