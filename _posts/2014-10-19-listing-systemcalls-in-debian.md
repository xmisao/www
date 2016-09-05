---
layout: blog
title: Debianでシステムコールの番号と名前を調べる
tag: debian
---



Auditデーモンが記録するシステムコールは、`ausyscall`コマンドで名前と番号のマッピングを取ることができる。

AuditデーモンはDebianなら以下でインストールできる。

~~~~
apt-get install auditd
~~~~

# システムコールの一覧を調べる

`--dump`オプションを使用することで、システムコールの名前と番号の一覧を表示できる。

~~~~
ausyscall --dump
~~~~

~~~~
Using x86_64 syscall table:
0       read
1       write
2       open
...
314     sched_setattr
315     sched_getattr
316     renameat2
~~~~

# システムコールの番号から名前を調べる

例えば2番のシステムコールの名前を知りたければ、単に引数に`2`を渡す。
この環境では2番のシステムコールは`open`だとわかる。

~~~~
ausyscall 2
~~~~

~~~~
open
~~~~

# システムコールの名前から番号を調べる

逆に`open`のシステムコール番号が知りたい場合も、単に引数に`open`を渡すだけで良い。
検索は部分一致で行われ`open`を含むシステムコールが全て表示される。

~~~~
ausyscall open
~~~~

~~~~
open               2
mq_open            240
openat             257
perf_event_open    298
open_by_handle_at  304
~~~~

`--exact`オプションを使用すると、引数に完全一致するシステムコール番号が表示される。

~~~~
ausyscall open --exact
~~~~

~~~~
2
~~~~

# アーキテクチャを指定する

システムコールはアーキテクチャにより異なる。このため`ausyscall`にはアーキテクチャを指定することができる。(省略すると実行中のイメージからアーキテクチャを推測する)

基本的にアーキテクチャ名の指定は`uname -m`の結果に従えば良い。以下は`x86_64`のシステムコール一覧を表示する例である。

~~~~
ausyscall x86_64 --dump
~~~~
