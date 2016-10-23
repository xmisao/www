---
layout: blog
title: PowerTOPを使ってLinuxマシンを省電力化する
tag: ['linux', 'debian', 'thinkpad']
last_update: '2016-10-23'
---

### お知らせ

2016年10月23日に記載内容を一部修正しました。

当初は`/etc/rc.local`でPowerTOPをOS起動時に自動実行する設定例を紹介していました。
この設定例を使用すると、お使いの環境によってはOSが正常に起動しなくなると指摘をいただいたため、設定例を削除しました。
ご迷惑をお掛けした方にお詫びいたします。

# はじめに

PowerTOPはIntelが提供するLinux向けのツールで、プロセスやハードウェアが消費している電力を一覧し、必要に応じて様々な省電力設定を行うことができる。

ノートPCにLinuxをインストールしてはみたが、どうもWindowsと比較してバッテリーの持ちが悪い…そんな時にはPowerTOPを使えば省電力化を行う手がかりが得られるかも知れない。

# インストール

PowerTOPはDebianでは`powertop`パッケージでインストールできる。なお現時点のDebian JessieではPowerTOPのバージョンは2.5であった。

~~~~
apt-get install powertop
~~~~

# 使い方

PowerTOPは`powertop`コマンドで起動する。
PowerTOPはカーネルやハードウェアに設定を行うので起動にはroot権限が必要だ。
PowerTOPはCLIアプリケーションで、端末が設定画面になる。

~~~~
powertop
~~~~

PowerTOPで特に重要なのは、起動直後に表示される`Overview`画面と、省電力設定を行う`Tunable`画面である。これらの画面はtabキーで切り替え可能だ。

![PowerTOP Overview](/assets/2014_01_21_powertop_1.png)

Overview画面の一番上に表示されている"The battery reports a discharge rate of ..."の部分が現在の消費電力である。PowerTOPによる省電力設定では、この数値をできる限り下げる事が目的になる。Overview画面には電力消費が多い順にハードウェアやプロセスが表示されており、何が電力を浪費しているのかが把握できるようになっている。

![PowerTOP Tunable](/assets/2014_01_21_powertop_2.png)

Tunable画面を見てみよう。この画面にはPowerTOPで省電力設定が可能な項目が一覧されている。省電力設定が可能だが現在は設定がされていない項目は`Bad`、省電力設定がされている項目は`Good`と表示されている。カーソルキーで設定する項目を選択して、Enterキーを押下すると省電力設定が行える。

![PowerTOP Tunable Setting](/assets/2014_01_21_powertop_3.png)

この際にPowerTOPが変更した設定は画面上部に表示される。この`VM writeback timeout`の省電力設定を有効化した例では、少々見づらいがPowerTOPが`echo '1500' > '/proc/sys/vm/dirty_writeback_centisecs'`を実行したことがわかる。

`Bad`の項目を1つ1つ`Good`にしてやっても良いが、もし`Bad`の項目をすべて`Good`にしたいのなら、`powertop --auto-tune`を実行することで全項目の省電力設定を有効化することができる。このコマンドを実行して再びPowerTOPの`Tunable`画面を表示させてみると確かに全ての項目が`Good`になっていることが確認できる。

~~~~
powertop --auto-tune
~~~~

![PowerTOP Tunable After Auto Tune](/assets/2014_01_21_powertop_4.png)

PowerTOPで行える設定は一時的なもので、リブートすると設定が元に戻ってしまう。
設定を恒久的にするには、別途、再起動時に`poertop auto--tune`が実行されるようにする必要がある。

一般的に省電力設定には何かしらトレードオフが伴うものだ。
もし何らかの理由で選択的に省電力設定を行う必要があるのなら、PowerTOP上で設定を変更した際に表示されるコマンドをメモっておき、有効にしたい項目を1つずつ書き写して、PowerTOPとは別に起動するようにしてやらねばならない。
ここは少し手間がかかるところだ。

# おわりに

![PowerTOP Overview After Auto Tune](/assets/2014_01_21_powertop_5.png)

さて、これは`Tunable`で全ての項目を`Good`にした後の`Overview`画面だ。
再び"The battery reports a discharge rate of ..."の行に注目し、冒頭のスクリーンショットと見比べてほしい。
私のThinkPad X240 FHDモデルでは、`Tunable`からすべての項目を`Good`に切り替えることで、もともと9W程度だった消費電力を4W程度まで実に5W近くも削減することができた。

実際PowerTOPによる設定を行ったところ、3セルフロントバッテリー + 3セルリアバッテリーの構成で、バッテリーの持ち時間も実測で4時間から8時間へ倍以上伸びた。適切に設定してやればLinuxでも十分にノートPCの省電力な運用が可能だと再認識させられる結果となった。
