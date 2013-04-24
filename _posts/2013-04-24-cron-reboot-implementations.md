---
layout: default
title: CronでOS起動時に処理を実行する@rebootの実装による差異
---

# CronでOS起動時に処理を実行する@rebootの実装による差異

crontabで@rebootを指定すると、cronの起動時にジョブを実行することができる。

@rebootを使うとcron起動時つまるところOS起動時に、root権限なしに任意の処理を実行する設定ができる。@rebootには、Windowsでいうところのスタートアップのような手軽さがあり、重宝する。

しかし、ここで気になるのは、これはcronの機能なので、OS起動とは無関係にcronが再起動されたらどうなるのか?という点だ。**結論から言うと、OSが採用しているcronの実装により異なる。**

93年のVixie Cron 3.1のソースコードを見ると、OS起動の延長とcronの再起動を区別する実装にはなっていない。cronの起動時にもれなく@rebootの処理が実行される。

調べた限り、cronを取り込むにあたって、FreeBSD、Debian、CentOSの3つのOSでは異なるアプローチを採っている。

FreeBSDはVixie Cronをそのまま採用している。Debianでは独自に@reboot時に、OS起動の延長かcronの再起動か区別するパッチを当てている。CentOSではVixie Cronではなく、Cronieという別の実装のcronを使っており、再起動を区別する。

OS          | cronの再起動時の@reboot実行有無 | cronの実装          |
---------------------------------------------------------------------
FreeBSD 9.1 | 実行される                      | Vixie Cron          | 
Debian 7.0  | 実行されない(OS起動時のみ)      | Vixie Cron + パッチ | 
CentOS 6.4  | 実行されない(OS起動時のみ)      | Cronie              | 

cronの実装によって挙動が異なるため、同じcrontabを書いても、自分の環境で@rebootが意図どおり動作するか、注意が必要になる。

同じ視点で検証されている方が居たのでリンクします。

[cronie / vixie-cron の @reboot は、どのように実装されているか?](http://blog.kenichimaehashi.com/?article=13604950680)
