---
layout: blog
title: Rubyでメモリ使用量を測定する(UNIX風OS限定)
tag: ['programming', 'ruby']
---



Rubyのメモリ使用量を実行しているスクリプト自身で測定する方法を調べていたところ、次の方法が目に止まったのでメモしておく。返却値はキロバイト単位。

    `ps -o rss= -p #{Process.pid}`.to_i

psコマンドを実行するので環境はLinuxなどUNIX風OSに限定され、細かい測定もできないが、ざっくりメモリ使用量が知りたい場合はRubyのバージョンに依らず動作するため便利だ。

[Rubyプログラム内で自身のメモリ使用率を計測できる方法はありますか?](http://qa.atmarkit.co.jp/q/2183)
