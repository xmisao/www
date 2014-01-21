---
layout: blog
title: X Windows Systemでバックライトの輝度を設定する方法(Debian)
tag: ['linux', 'debian']
---

# X Windows Systemでバックライトの輝度を設定する方法(Debian)

ノートPCを使っていて、コマンドラインからバックライトの輝度を設定したい場合は`xbacklight`コマンドが利用できる。
このコマンドはDebianではそのまんま`xbacklight`パッケージに含まれているのでaptでインストールする。

~~~~
apt-get install xbacklight
~~~~

使い方は`xbacklight --help`で表示できる通りだ。
`-display`でディスプレイの選択、輝度は絶対指定か現時点からの相対指定ができる。

~~~~
usage: xbacklight [options]
  where options are:
  -display <display> or -d <display>
  -help
  -set <percentage> or = <percentage>
  -inc <percentage> or + <percentage>
  -dec <percentage> or - <percentage>
  -get
  -time <fade time in milliseconds>
  -steps <number of steps in fade>
~~~~

最も基本的な使い方は`xbacklight -set`だ。
これで輝度を設定することができる。
設定できる範囲は0から100のパーセンテージである。
例えば輝度を60パーセントに設定するには以下のようにする。

~~~~
xbacklight -set 60
~~~~

Gnome Power Managerなどデスクトップ環境のツールにも同様の機能があるはずだが、そういったツールに頼らない人向けのコマンドといえる。覚えておく価値はある。
