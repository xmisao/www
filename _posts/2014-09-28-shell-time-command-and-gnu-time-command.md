---
layout: blog
title: timeコマンドにはシェルの組み込みコマンドとGNU版の2種類ある
tag: linux
---

# timeコマンドにはシェルの組み込みコマンドとGNU版の2種類ある

Linuxでコマンドの処理時間などを計測する`time`コマンド。
実はシェルの機能とGNU版の2種類があることを知った。

単に`time`とタイプして実行すると、bashではシェルの組み込みコマンドが優先される。
このためGNU版の`time`コマンドを使ったことがある人は少ないのではないか。

GNU版の`time`はDebianなら`time`パッケージに含まれている。
以下でインストールできる。(私の環境ではインストールさえされていなかった!)

~~~~
apt-get install time
~~~~

インストール先は`/usr/bin/time`なので明示的パスを指定して実行する。
bashの組み込みコマンドとの違いは以下のとおり。

~~~~
$ time sleep 1

real    0m1.002s
user    0m0.000s
sys     0m0.000s
~~~~

~~~~
$ /usr/bin/time sleep 1
0.00user 0.00system 0:01.00elapsed 0%CPU (0avgtext+0avgdata 640maxresident)k
0inputs+0outputs (0major+205minor)pagefaults 0swaps
~~~~

このとおりGNU版の方が出力される項目が多い。
メモリ使用量に加えてI/O回数やページフォールト回数が表示される。

GNU版の`time`コマンドは出力フォーマットを`-f`オプションで指定できる。
デフォルトのフォーマットは以下となっている。

~~~~
%Uuser %Ssystem %Eelapsed %PCPU (%Xtext+%Ddata %Mmax)k
%Iinputs+%Ooutputs (%Fmajor+%Rminor)pagefaults %Wswaps
~~~~

つまりGNU版のtimeコマンドを使えば、このようにして、あるコマンドの最大メモリ使用量を計測することもできるわけだ。
便利。

~~~~
$ time -f "%M" sleep 1
664
~~~~

ただしmanには以下の注意書きがあるため、すべての環境で全項目が正しく計測できるわけではない模様。

> 全てのリソースが UNIX の全てのバージョンで計測されているわけではないので、 いくつかの値が 0 と報告される可能性がある。 現在の出力項目のほとんどは 4.2BSD や 4.3BSD で取得可能なデータに 基づいて選択されている。

- 参考
  - [Man page of time](http://linuxjm.sourceforge.jp/html/LDP_man-pages/man1/time.1.html)
