---
layout: blog
title: jekyllのMarkdownパーサをmarukuからkramdownに変更する
tag: jekyll
---



jekyllはMarkdownパーサを切り替える機能がある。特に指定しなければmarukuが使われる。

これまでmarukuを使っていたが、marukuは日本語の扱いにバグがあるようで、例えば日本語で始まるリストは正しく変換することができないようだった。

    - ほげ
    - ぴよ
    - ふが

これがこのように変換されてしまう。

    <ul><li>ほげ -ぴよ -ふが</li></ul>

kramdownではこのような問題は発生しない。まずkramdownをインストールする。

    gem install kramdown

jekyllの_config.ymlに以下の1行追加する。

    markdonw: kramdown

これでjekyllはmarukuの代わりにkramdownを使うようになり、快適にブログが書けるようになった。
