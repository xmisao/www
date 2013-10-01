---
layout: blog
title: GNU screenでマウスホイールでスクロールする方法
tag: linux
---

# GNU screenでマウスホイールでスクロールする方法

何気なく検索したら答えが見つかり拍子抜けしたのでメモ。
`~/.screenrc`に以下の1行を追加する。

~~~~
termcapinfo xterm* ti@:te@
~~~~

これでscreenでマウスのホイールで、上下にスクロールができるようになる。

参考:

[Using the scrollwheel in GNU screen](http://stackoverflow.com/questions/359109/using-the-scrollwheel-in-gnu-screen)

