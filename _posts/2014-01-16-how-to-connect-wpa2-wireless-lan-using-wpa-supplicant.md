---
layout: blog
title: Linuxでwpa_supplicantを使ってWPA2の無線LANに接続する方法
tag: linux
---

# Linuxでwpa_supplicantを使ってWPA2の無線LANに接続する方法

Gnome Network Manager等を使わずに、自力で`wpa_supplicant`コマンドを使って、WPA2の無線LANに接続する方法を紹介する。

検証した環境はDebina Jessie。`wpa_supplicant`コマンドは`wpasupplicant`パッケージに含まれているので、事前にインストールしておく。

~~~~
apt-get install wpasupplicant
~~~~

以下の手順は前提として有線LANの`eth0`と無線LANの`wlan0`のインタフェースがある環境を想定している。

## 1. 有線LANを無効化する

無線LANと有線LANを併用したい場合はこのステップを飛ばして良い。

複数のインタフェースが有効だとルーティングで混乱しがちである。このため無線LANを有効にする前に、有線LANを無効にしておくことをおすすめする。

~~~~
ifconfig eth0 down
~~~~

## 2. 無線LANを無効化する

前の設定が残っていて以降の設定の妨げになる場合があるので、いったん無線LANを無効化する。

~~~~
ifconfig wlan0 down
~~~~

## 3. 無線LANを有効化する

そのまんまである。さきほど無効化した無線LANを有効化する。

~~~~
ifconfig wlan0 up
~~~~

## 4. ネットワークに接続する

wpa_supplicantを実行して、無線LANで目的のネットワークに接続する。接続するネットワークの設定はここでは`/home/user/wpa_supplicant.conf`に書かれているものとする。`wpa_supplicant`コマンドは、オプションと引数の間にスペースが不要なことに注意。

~~~~
wpa_supplicant -Dwext -iwlan0 -c/home/user/wpa_supplicant.conf
~~~~

`/home/user/wpa_supplicant.conf`の設定例は以下の内容である。`ssid=`と`psk=`の行は、自分のSSIDとパスワードに置き換える。

~~~~
ctrl_interface=/var/run/wpa_supplicant
ap_scan=1
network={
    ssid="your-ssid"
    key_mgmt=WPA-PSK
    proto=WPA WPA2
    pairwise=CCMP TKIP
    group=CCMP TKIP WEP104 WEP40
    psk="your-pass"
}
~~~~

## 5. DHCPでIPアドレスを割り当てる

DHCPでIPアドレスを取得する場合は`dhclient`コマンドを使う。静的にIPを割り当てている場合は、このステップは不要だ。

~~~~
dhclient wlan0
~~~~

## 補注

### ネットワークのスキャン

ネットワークをスキャンして一覧するには`iwlist`コマンドを使う。`iwlist`コマンドは`wireless-tools`パッケージに含まれている。

~~~~
iwlist wlan0 scan
~~~~

### 接続できない場合

上記の手順を踏んでも、何故かネットワークに接続できない環境を見たことがある。

理由は不明なのだが、*ステップ2.*と*ステップ3.*の間で、以下の`iwconfig`コマンドを実行し、SSIDとダミーのWEPキーを指定してやるとうまく接続できた。試してみる価値があると思う。

~~~~
iwconfig wlan0 essid "your-ssid"
iwconfig wlan0 key s:your-pass
~~~~
