---
layout: default
title: JekyllでRSSフィードを出力する
---

# JekyllでRSSフィードを出力する

Jekyllには_postsディレクトリ以下のファイルをさながらブログのように扱う仕組みがあるが、RSSフィードまでは生成してくれない。もちろん、RSSのテンプレートを書けば良いのだが、以下のテンプレートを見つけたので利用してみた。

[Jekyll RSS Feed Templates](https://github.com/snaptortoise/jekyll-rss-feeds)

使い方は簡単だ。feed.xmlがそのものずばりフィードのテンプレートになっているので、これをJekyllのルートディレクトリにコピーする。加えて_config.ymlに以下の内容を書いておけば良い。この値はフィード内で使われる。

    name: Your Blog's Name
    description: A description for your blog
    url: http://your-blog-url.example.com

これでjekyllコマンドを走らせれば、_postsの最新10件がフィードとして出力されるようになる。あとは各ページのテンプレートに以下のようなlinkタグを追加してやれば良い。

    <link rel="alternate" type="application/atom+xml" title="Your Blog's Name" href="{{ root }}/feed.xml" />
