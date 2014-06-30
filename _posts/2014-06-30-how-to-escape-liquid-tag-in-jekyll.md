---
layout: blog
title: jekyllでLiquidタグをエスケープする方法
tag: jekyll
---

# jekyllでLiquidタグをエスケープする方法

jekyllでLiquidタグをエスケープするにはrawタグを使用する。
以下のコードでは％を全角にしているので注意。エスケープのエスケープを考えると頭が痛くなる…。

~~~~
{％ raw ％}
この中身がエスケープされる
{％ endraw ％}
~~~~

- 参考
  - [How to escape liquid template tags?](http://stackoverflow.com/questions/3426182/how-to-escape-liquid-template-tags)
