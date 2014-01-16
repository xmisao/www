---
layout: blog
title: ThinkPad X240で無線LANカードを使えるようにする(Debian Jessie)
tag: ['linux', 'thinkpad']
---

# ThinkPad X240で無線LANカードを使えるようにする(Debian Jessie)

ThinkPad X240で無線LANカードを使えるようにする設定する機会があったのでメモしておく。X240に限らず基本的にはIntelの無線LANカードはこれで使えるようになるはずである。

`/etc/apt/sources.list`で`contrib`と`non-free`を追加しておく。後述する`firmware-iwlwifi`は`non-free`なので`contrib`は不要だが念の為。

~~~~
deb http://ftp.jp.debian.org/debian/ jessie main contrib non-free
deb-src http://ftp.jp.debian.org/debian/ jessie main contrib non-free

deb http://security.debian.org/ jessie/updates main contrib non-free
deb-src http://security.debian.org/ jessie/updates main contrib non-free

deb http://ftp.jp.debian.org/debian/ jessie-updates main contrib non-free
deb-src http://ftp.jp.debian.org/debian/ jessie-updates main contrib non-free

deb http://ftp.jp.debian.org/debian/ jessie-backports main contrib non-free
deb-src http://ftp.jp.debian.org/debian/ jessie-backports main contrib non-free
~~~~

その後`apt-get update`して、`firmware-iwlwifi`パッケージをインストールする。
これで再起動すれば無線カードが認識され`ifconfig -a`で`wlan0`が見えるはずである。

~~~~
$ apt-get update
$ apt-get install firmware-iwlwifi
$ reboot
~~~~

~~~~
$ ifconfig -a
eth0      Link encap:Ethernet  HWaddr 28:d2:44:4a:ad:cf  
          inet addr:10.0.254.3  Bcast:10.255.255.255  Mask:255.0.0.0
          inet6 addr: fe80::2ad2:44ff:fe4a:adcf/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:74 errors:0 dropped:0 overruns:0 frame:0
          TX packets:59 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:9665 (9.4 KiB)  TX bytes:8861 (8.6 KiB)
          Interrupt:20 Memory:f0600000-f0620000 

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:4 errors:0 dropped:0 overruns:0 frame:0
          TX packets:4 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:240 (240.0 B)  TX bytes:240 (240.0 B)

wlan0     Link encap:Ethernet  HWaddr 7c:7a:91:04:b5:69  
          BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
~~~~
