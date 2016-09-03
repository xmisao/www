---
layout: blog
title: Linuxで簡単にストレージのベンチマークを実行する方法(palimpsest)
tag: linux
---



私はLinuxでストレージのベンチマークを実行するには、これまで`bonnie++`を使っていたが、Gnomeに付属のユーティリティ`palimpsest`でグラフィカルにベンチマークが可能ということを知って試してみた。Debianでは`palimpsest`は`gnome-disk-utility`パッケージに含まれている。なお`palimpsest`とは見慣れない単語だが、[羊皮紙の写本](http://ja.wikipedia.org/wiki/%E3%83%91%E3%83%AA%E3%83%B3%E3%83%97%E3%82%BB%E3%82%B9%E3%83%88)のことを言うらしい。

~~~~
apt-get install gnome-disk-utility
~~~~

`palimpsest`で実行できるベンチマークには、読み込みのみを行う*Read-Only Benchmark*と読み書きを行う*Read/Write Benchmark*の2種類がある。*Read-Only Benchmark*はデータが存在するストレージ上でも実行できるが、*Read/Write Benchmark*はストレージが空である必要がある。

ストレージが空というのは、ファイルシステムやパーティションテーブルが存在しない状態のことだ。ストレージをこの状態にするには、`palimpsest`の*Format Drive*から*Dont't partition*を選択してフォーマットすれば良い。当然、全データが削除されるのでデータがあるストレージで実行するのは厳禁だ。

![Format Dont Partition]({{ site.url }}/assets/2014_01_13_palimpsest_1.png)



<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B004HXHIOM/xmisao-22/ref=nosim/" name="amazletlink" target="_blank"><img src="http://ecx.images-amazon.com/images/I/31MdE0nrooL._SL160_.jpg" alt="Transcend  SuperSpeed USB 3.0&Hi-Speed USB 2.0 USBメモリ 700シリーズ 32GB 永久保証 TS32GJF700" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B004HXHIOM/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Transcend  SuperSpeed USB 3.0&Hi-Speed USB 2.0 USBメモリ 700シリーズ 32GB 永久保証 TS32GJF700</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 14.01.13</div></div><div class="amazlet-detail">トランセンド・ジャパン <br />売り上げランキング: 1,789<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B004HXHIOM/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>

USB 3.0対応を謳うUSBメモリを買ったので、`palimpsest`でベンチマークを取ってみた。機種はTransendのTS32GJF700である。実売価格で2000円ほど。スペック上では、Up to Read 70MB/s、Write 18 MB/sとのことだ。果たしてどれほど早いのであろうか。

ベンチマークの結果は以下のとおり。青線がReadで赤線がWriteである。平均読み込み速度は87.1MB/s、平均書き込み速度は10.9MB/sとなった。Readはスペックより早いが、Writeはスペックより遅く半分程度である。前半のWriteのスパイクと、1/3付近からのReadの速度向上が気になるが、概ねスペックどおりの結果となった。

![Format Dont Partition]({{ site.url }}/assets/2014_01_13_palimpsest_2.png)

Readが80MB/sというと、640Mbpsであり、USB 2.0のスペックを超えて、一昔前の内蔵HDDのシーケンシャルリード並の速度である。USB接続のフラッシュメモリでこの速度が出るというのは隔世の感がある。たぶん探せばもっとコスパの良い製品もあるのだろうが、結果だけ見れば十分満足だ。
