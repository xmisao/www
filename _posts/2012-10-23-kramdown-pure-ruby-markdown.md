---
layout: default
title: ピュアRubyのMarkdownパーサkramdownを利用する
---

# ピュアRubyのMarkdownパーサkramdownを利用する

kramdownはネイティブライブラリを利用しないのでお手軽。

    gem install kramdown

Markdown形式の文字列は以下の1行でHTMLに変換できる。
mdが変換対象の文字列とする。

    require 'kramdown'
    Kramdown::Document.new(md).to_html
