---
layout: blog
title: Linuxで無線LAN
---



何かとうまく動いてくれないLinuxの無線LAN。
コマンドで接続する場合は、WEPとWPAで利用するコマンドが異なる。
Gnome Network Managerなどが動作していると、うまく動作しない模様。

# wep

TODO

# wpa2

設定ファイルは予め作成しておく。
TODO

接続開始はwpa_supplicantを利用する。
各オプションの引数のあとには空白を入力しないで詰める点に注意。

wpa_supplicant -Dwext -iwlan0 -c/path/to/conf
