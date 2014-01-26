---
layout: blog
title: PowerTOPを使ってLinuxマシンを省電力化する
tag: ['linux', 'debian', 'thinkpad']
---

# PowerTOPを使ってLinuxマシンを省電力化する

PowerTOPはIntelが提供するLinux向けのツールで、プロセスやハードウェアが消費している電力を一覧し、必要に応じて様々な省電力設定を行うことができる。

ノートPCにLinuxをインストールしてはみたが、どうもWindowsと比較してバッテリーの持ちが悪い…そんな時にはPowerTOPを使えば省電力化を行う手がかりが得られるかも知れない。

PowerTOPはDebianでは`powertop`パッケージでインストールできる。なお現時点のDebian JessieではPowerTOPのバージョンは2.5であった。

~~~~
apt-get install powertop
~~~~

PowerTOPはカーネルやハードウェアに設定を行うので起動にはroot権限が必要だ。PowerTOPで特に重要なのは、起動直後に表示される`Overview`画面と、省電力設定を行う`Tunable`画面である。これらの画面はtabキーで切り替え可能だ。

![PowerTOP Overview]({{ site.url }}/assets/2014_01_21_powertop_1.png)

Overview画面の一番上に表示されている"The battery reports a discharge rate of ..."の部分が現在の消費電力である。PowerTOPによる省電力設定では、この数値をできる限り下げる事が目的になる。Overview画面には電力消費が多い順にハードウェアやプロセスが表示されており、何が電力を浪費しているのかが把握できるようになっている。

![PowerTOP Tunable]({{ site.url }}/assets/2014_01_21_powertop_2.png)

Tunable画面を見てみよう。この画面にはPowerTOPで省電力設定が可能な項目が一覧されている。省電力設定が可能だが現在は設定がされていない項目は`Bad`、省電力設定がされている項目は`Good`と表示されている。カーソルキーで設定する項目を選択して、Enterキーを押下すると省電力設定が行える。

![PowerTOP Tunable Setting]({{ site.url }}/assets/2014_01_21_powertop_3.png)

この際にPowerTOPが変更した設定は画面上部に表示される。この`VM writeback timeout`の省電力設定を有効化した例では、少々見づらいがPowerTOPが`echo '1500' > '/proc/sys/vm/dirty_writeback_centisecs'`を実行したことがわかる。

`Bad`の項目を1つ1つ`Good`にしてやっても良いが、もし`Bad`の項目をすべて`Good`にしたいのなら、`powertop --auto-tune`を実行することで全項目の省電力設定を有効化することができる。このコマンドを実行して再びPowerTOPの`Tunable`画面を表示させてみると確かに全ての項目が`Good`になっていることが確認できる。

~~~~
powertop --auto-tune
~~~~

![PowerTOP Tunable After Auto Tune]({{ site.url }}/assets/2014_01_21_powertop_4.png)

なおPowerTOPで行える設定は一時的なもので、リブートすると設定が元に戻ってしまう。
設定を恒久的にするには、例えばDebianなら`/etc/rc.local`などに省電力設定を書いてやる必要がある。
私はすべての省電力設定を有効にしたかったので、`/etc/rc.local`で`powertop --auto-tune`を実行してやることにした。
設定後の`/etc/rc.local`は以下の内容である。

~~~~
powertop --auto-tune

exit 0
~~~~

一般的に省電力設定には何かしらトレードオフが伴うものだ。
もし何らかの理由で選択的に省電力設定を行う必要があるのなら、PowerTOP上で設定を変更した際に表示されるコマンドをメモっておき、有効にしたい項目を1つずつ`/etc/rc.local`に書き写してやらねばならない。
ここは少し手間がかかるところだ。

![PowerTOP Overview After Auto Tune]({{ site.url }}/assets/2014_01_21_powertop_5.png)

さて、これは`Tunable`で全ての項目を`Good`にした後の`Overview`画面だ。
再び"The battery reports a discharge rate of ..."の行に注目し、冒頭のスクリーンショットと見比べてほしい。
私のThinkPad X240 FHDモデルでは、`Tunable`からすべての項目を`Good`に切り替えることで、もともと9W程度だった消費電力を4W程度まで実に5W近くも削減することができた。

実際PowerTOPによる設定を行ったところ、3セルフロントバッテリー + 3セルリアバッテリーの構成で、バッテリーの持ち時間も実測で4時間から8時間へ倍以上伸びた。適切に設定してやればLinuxでも十分にノートPCの省電力な運用が可能だと再認識させられる結果となった。
