---
layout: blog
title: Twitter Bootstrapでセンタリングする方法
tag: ['css', 'web']
---



Twitter Bootstrap 2.3.0以降で要素をセンタリングするにはtext-centerクラスを指定すればセンタリングできる。

    <div class="text-center">Centered</div>

それ以前のバージョンでは、rowクラスかspan12クラスを用いて最大幅にした上で、スタイルでtext-align: centerを指定するしかない模様。

    <div class="row" style="text-align: center">Centered</div>

[How do you get centered content using Twitter bootstrap?](http://stackoverflow.com/questions/9184141/how-do-you-get-centered-content-using-twitter-bootstrap)
