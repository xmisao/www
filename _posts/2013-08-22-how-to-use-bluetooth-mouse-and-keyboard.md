---
layout: default
title: DebianでBluetoothマウスやキーボードを使う
tag: linux
---

# DebianでBluetoothマウスやキーボードを使う

LinuxでもBluetoothマウスやキーボードが使いたい。

Debianならまずbluetoothパッケージをインストール。
これでbluetoothサービスが使えるようになる。

    apt-get install bluetooth

デバイスをペアリングできる状態にして、hcitoolコマンドを使ってデバイスを検索する。hcitoolコマンドはユーザ権限で実行して良い。

    hcitool scan

デバイスが見つかると以下のようにアドレスが表示される。

    Scanning ...
            12:34:56:78:90:AB       ThinkPad Compact Bluetooth Keyboard with TrackPoint

rootでhiddコマンドを実行して接続する。
引数にはhcitoolで調べたアドレスを指定する。
エラーが出なければ成功。

    hidd --connect 12:34:56:78:90:AB

接続中のデバイスは以下のように調べられる。
これもユーザ権限で良い。

    hidd --show

    12:34:56:78:90:AB Bluetooth Keyboard [17ef:6048] connected

参考:

* [ja/BluetoothUser - Debian Wiki](https://wiki.debian.org/ja/BluetoothUser)
* [ja/HOWTO/BluetoothMouse](https://wiki.debian.org/ja/HOWTO/BluetoothMouse)
