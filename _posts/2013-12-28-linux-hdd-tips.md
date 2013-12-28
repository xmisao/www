---
layout: blog
title: LinuxでHDDの不具合を特定する作業の覚え書き
tag: linux
---

# LinuxでHDDの不具合を特定する覚え書き

PCを使っていると避けられないハードディスクの不調。
Linuxで不具合の原因を特定する手順を忘れがちなのでここにまとめておく。

1. HDDのS.M.A.R.T情報の表示
2. HDDの不良セクタの確認と検出
3. ファイルシステムの修復

## 1. HDDのS.M.A.R.T情報の表示

LinuxでHDDのS.M.A.R.T情報を表示するには`smartctl`コマンドを使う。
`smartctl`コマンドはDebianならsmartmontoolsパッケージに含まれている。
事前にインストールしておこう。

~~~~
apt-get install smartmontools
~~~~

`smartctl -a デバイス`で、デバイスのS.M.A.R.T情報をすべて表示する。
例えば`/dev/sda`のS.M.A.R.T情報を表示するには以下のようにする。
S.M.A.R.T情報の各項目の意味は[Wikipedia](http://ja.wikipedia.org/wiki/Self-Monitoring,_Analysis_and_Reporting_Technology)に良くまとまっている。

~~~~
smartctl -a /dev/sda
~~~~

~~~~
smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.2.0-4-amd64] (local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Caviar Green (Adv. Format)
Device Model:     WDC WD20EARS-00MVWB0
...
~~~~

なおUSB接続しているハードディスクのS.M.A.R.T情報を取得する方法は標準化されていないらしい。このためS.M.A.R.T情報が取得できなかったり、取得できても結果が正しくなかったりするので注意が必要。

## 2. HDDの不良セクタの確認と検出

ファイルシステムを修復することが目的の場合は、この手順を飛ばして_3._へ進んで良い。(後述する`e2fsck -c`が未知の不良セクタの検出を同時に行うため)

HDDに不良セクタの存在が疑われる場合、不良セクタを検出して位置を目視で確認したい事があるかもしれない。そのような場合は`badblocks`コマンドを利用する。

`badblocks`は不良セクタを検出して一覧を作成するコマンドである。`-s`オプションで進捗を表示することができる。`-o`は一覧の出力先を指定するオプションだ。例えば進捗を表示しつつ`/dev/sda1`の領域の不良セクタを検出して`badsectors.txt`に保存するには以下のようにすれば良い。

~~~~
badblocks -s -o badsectors.txt /dev/sda1
~~~~

ext2/3/4のファイルシステムの既知の不良セクタを確認するには`dumpe2fs`コマンドが利用できる。`-b`オプションはファイルシステム中で不良とされているブロックを標準出力に出力する指定だ。このコマンドは既知の不良セクタが無ければエラー出力にメッセージを出力して終了する。

~~~~
dumpe2fs -b /dev/sda1
~~~~

## 3. ファイルシステムの修復

この操作は不用意に行うとファイルを失う可能性があるので、ファイルシステムの完全なバックアップを取っておくことを推奨する。[Refine:壊れたかもしれないハードディスクからのデータサルベージ](http://www.xmisao.com/2013/12/02/hdd-salvage-by-dd.html)に手順を掲載しているので詳しくはそちらを参照。

ext2/3/4のファイルシステムの修復には`e2fsck`コマンドを利用する。
不良セクタを検出してファイルシステムに認識させるには`-c`オプションを使う。
例えば`/dev/sda1`のファイルシステムを修復するには以下のようにする。

~~~~
e2fsck -c /dev/sda1
~~~~

`e2fsck`はファイルシステムの不具合を見つけるとユーザと対話的に修復を試みる。
大量に不良セクタが存在する場合は`-y`オプションも同時に指定すると、すべての質問にyesと回答したのと同じ動作をするので手間が省ける。
