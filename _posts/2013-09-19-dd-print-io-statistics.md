---
layout: blog
title: ddにUSR1シグナルを送ると途中経過を表示できる
tag: linux
---



和訳されたマニュアルには何故か記載が見当たらないのだが、英語のmanを読むとちゃんと書いてある。

`kill -USR1 12345`のように実行中の`dd`のプロセスIDを指定して、USR1シグナルを送ってやると、`dd`は標準エラー出力に途中経過を表示する。

マニュアルから引用すると以下。

~~~~
$ dd if=/dev/zero of=/dev/null& pid=$!
$ kill -USR1 $pid; sleep 1; kill $pid
18335302+0  records  in  18335302+0 records out 9387674624 bytes
(9.4 GB) copied, 34.6279 seconds, 271 MB/s
~~~~

大きめのファイルシステム等を`dd`している際に、どこまで進んでいるか確認したい事があるが、そういった場合に重宝するので覚えておきたい。
