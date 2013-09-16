---
layout: blog
title: CronでOS起動時に処理を実行する@rebootの実装による差異
tag: linux
---

# CronでOS起動時に処理を実行する@rebootの実装による差異

crontabで以下のように@rebootを指定すると、cronの起動時にジョブを実行することができる。

    @reboot /path/to/script

つまりOS起動時に任意の処理を実行する設定が、root権限なしにできる。このため@rebootには、Windowsでいうところのスタートアップのような手軽さがあり、重宝する。

しかし、ここで気になるのは、これはcronの機能なので、OS起動とは無関係にcronが再起動されたらどうなるのか?という点だ。**結論から言うと、@rebootの挙動はOSが採用しているcronの実装により異なる。**

93年のVixie Cron 3.1のソースコードを見ると、OS起動の延長とcronの再起動を区別する実装にはなっていない。cronの起動時にもれなく@rebootの処理が実行される。

調べた限り、FreeBSD、Debian、CentOSの3つのOSでは、cronを取り込むにあたって、異なるアプローチを採っている。

FreeBSDはVixie Cronをそのまま採用している。DebianではVixie Cronに独自にパッチを当て、@reboot時に、OS起動の延長かcronの再起動か区別している。CentOSではVixie Cronではなく、Cronieという別の実装のcronを使っており、再起動を区別する。(下表にまとめる)

| OS          | cronの再起動時の@reboot実行有無 | cronの実装          |
|-------------|---------------------------------|---------------------|
| FreeBSD 9.1 | 実行される                      | Vixie Cron          |
| Debian 7.0  | 実行されない(OS起動時のみ)      | Vixie Cron + パッチ |
| CentOS 6.4  | 実行されない(OS起動時のみ)      | Cronie              |
{: .table .table-striped}

cronの実装によって挙動が異なるため、同じcrontabを書いても、自分の環境で@rebootが意図どおり動作するか、注意が必要になる。

同じ視点で検証されている方が居たのでリンクします。

参考:  
[cronie / vixie-cron の @reboot は、どのように実装されているか?](http://blog.kenichimaehashi.com/?article=13604950680)
