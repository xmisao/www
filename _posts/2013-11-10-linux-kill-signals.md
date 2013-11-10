---
layout: blog
title: Linuxのシグナルまとめ
tag: linux
---

# Linuxのシグナルまとめ

Linuxのシグナルについて調べたのでまとめる。
最初にシグナルの一覧を示し、重要なものは抜粋して説明する。

参考: [http://linuxjm.sourceforge.jp/html/LDP_man-pages/man7/signal.7.html](http://linuxjm.sourceforge.jp/html/LDP_man-pages/man7/signal.7.html)

## シグナルの一覧

killコマンドで送信できるシグナルの一覧は`-l`オプションで見ることができる。

~~~~
kill -l
~~~~

### x86 Linuxのシグナル一覧

一部のシグナルの意味は、CPUのアーキテクチャによって異なる。
以下の表ではx86のシグナル一覧を示す。コメント蘭はmanからの引用である。

|ID|シグナル|コメント|
|-:|:-|:-|
|1 | SIGHUP | 制御端末(controlling terminal)のハングアップ検出、または制御しているプロセスの死|
|2 | SIGINT | キーボードからの割り込み (Interrupt)|
|3 | SIGQUIT | キーボードによる中止 (Quit)| 
|4| SIGILL | 不正な命令|
|5| SIGTRAP | トレース/ブレークポイント トラップ, IOT トラップ。SIGABRT と同義|
|6| SIGABRT |	abort(3) からの中断 (Abort) シグナル|
|7| SIGBUS | バスエラー (不正なメモリアクセス)|
|8| SIGFPE  | 浮動小数点例外| 
|9| SIGKILL | Kill シグナル|  
|10| SIGUSR1 | ユーザ定義シグナル 1|
|11| SIGSEGV | 不正なメモリ参照| 
|12| SIGUSR2 | ユーザ定義シグナル 2|
|13| SIGPIPE | パイプ破壊:読み手の無いパイプへの書き出し|
|14| SIGALRM | alarm(2) からのタイマーシグナル|
|15| SIGTERM | 終了 (termination) シグナル|
|16| SIGSTKFLT 数値演算プロセッサにおけるスタックフォルト (未使用)|
|17| SIGCHLD | 子プロセスの一時停止 (stop) または終了|
|18| SIGCONT | 一時停止 (stop) からの再開|
|19| SIGSTOP | プロセスの一時停止 (stop)|
|20| SIGTSTP | 端末より入力された一時停止 (stop)|
|21| SIGTTIN | バックグランドプロセスの端末入力|
|22| SIGTTOU | バックグランドプロセスの端末出力|
|23| SIGURG | ソケットの緊急事態 (urgent condition) (4.2BSD)|
|24| SIGXCPU | CPU時間制限超過 (4.2BSD)|
|25| SIGXFSZ | ファイルサイズ制限の超過 (4.2BSD)|
|26| SIGVTALRM | 仮想アラームクロック (4.2BSD)|
|27| SIGPROF | profiling タイマの時間切れ|
|28| SIGWINCH  | ウィンドウ リサイズ シグナル (4.3BSD, Sun)|
|29| SIGIO | 入出力が可能になった (4.2BSD)| 
|30| SIGPWR | 電源喪失 (Power failure) (System V)|
|31| SIGSYS | ルーチンへの引き数が不正 (SVr4)|
{: .table .table-striped}

### Linuxのリアルタイムシグナル一覧

シグナルID 33から64まではリアルタイムシグナルと呼ばれている。
事前に定義された意味はなく、アプリケーションで定義した用途に使用できる。
ただし33はglibcの内部で使用されており、使えない。

|ID| シグナル |
|-:|:-|
|34| SIGRTMIN |
|35| SIGRTMIN+1 |  
|36| SIGRTMIN+2 |
|37| SIGRTMIN+3 |
|38| SIGRTMIN+4 | 
|39| SIGRTMIN+5 |
|40| SIGRTMIN+6 |
|41| SIGRTMIN+7 |
|42| SIGRTMIN+8 |
|43| SIGRTMIN+9 |
|44| SIGRTMIN+10 |
|45| SIGRTMIN+11 |
|46| SIGRTMIN+12 |
|47| SIGRTMIN+13 |
|48| SIGRTMIN+14 |
|49| SIGRTMIN+15 |
|50| SIGRTMAX-14 |
|51| SIGRTMAX-13 |
|52| SIGRTMAX-12 |
|53| SIGRTMAX-11 |
|54| SIGRTMAX-10 |
|55| SIGRTMAX-9 |
|56| SIGRTMAX-8 | 
|57| SIGRTMAX-7 |
|58| SIGRTMAX-6 |
|59| SIGRTMAX-5 |
|60| SIGRTMAX-4 |
|61| SIGRTMAX-3 |
|62| SIGRTMAX-2 |
|63| SIGRTMAX-1 |
|64| SIGRTMAX |
{: .table .table-striped}

## 主なシグナルの解説

manの解説は直感的にはわかりにくいので、
特に利用頻度が高いシグナルをピックアップして説明する。

### SIGHUP

プログラムを再起動するシグナルだ。
設定ファイルの再読み込みをさせる場合に使う事が多い。
以下のように送信する。

~~~~
kill -HUP 1234
~~~~

### SIGINT

プログラムを終了させるシグナルだ。
シェルからCtlr + Cで送信できるシグナルでもある。

~~~~
kill -INT 1234
~~~~

### SIGQUIT

これもプログラムを終了させるシグナルだ。
シェルからCtlr + /で送信できるシグナルでもある。

### SIGTERM

プロセスを正常に終了させるシグナルだ。
killコマンドで送信するデフォルトシグナルである。
これが効かない場合はSIGKILLを使う。

~~~~
kill 1234
~~~~

### SIGKILL

プロセスを強制的に殺すためのシグナルである。
SIGINTやSIGTERMが効かない場合でも、殺すことができる。

~~~~
kill -KILL 1234
~~~~

または

~~~~
kill -9 1234
~~~~

### SIGUSR1

ユーザ定義のシグナルで、プログラムによって意味が異なる。
ぱっと思いつくものでは`dd`で途中経過を表示させる用途に使われている。

~~~~
kill -USR1 1234
~~~~
