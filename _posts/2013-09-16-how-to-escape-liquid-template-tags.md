---
layout: blog
title: liquidテンプレートタグをエスケープする方法
tag: jekyll
---



jekyllで文章を書いていると、jekyllやliquidの使用方法を説明するために、liquidのタグをエスケープしたい場合がある。

正攻法もあるが、これは一筋縄で行かない。簡単にエスケープするにはrawタグを使って、`{{ "{% raw " }}%}`と`{{ "{% endraw " }}%}`で囲むと良いらしい。

これはこれで、rawタグの中のrawタグを如何にエスケープするかという問題もあるが…。

参考:  
[How to escape liquid template tags?](http://stackoverflow.com/questions/3426182/how-to-escape-liquid-template-tags)
