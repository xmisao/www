---
layout: blog
title: Raspberry PIのRaspbian(Debian)でPPTPによるVPN環境を構築する
tag: linux
---

# Raspberry PIのRaspbian(Debian)でPPTPによるVPN環境を構築する

Raspberry PI用のDebianがRaspbianである。
今回はRaspbian(Wheezy)をインストールしたRaspberry PIにpptpdをインストールしてPPTPサーバ化して外部から接続できるようにする設定をする。
基本的にはDebianでpptpdを設定する手順も同様のはずだ。

前提となるネットワーク環境は以下を想定している。
ルータ下にPPTPサーバ化したRaspberry PIがぶら下がっている構成である。
サーバの設定、ルータの設定、クライアントの設定と3段階に分けて手順を紹介する。

![FeaturedImage]({{ site.url }}/assets/2013_12_30_pptp_network.png)

1. PPTPサーバ側の設定
2. ルータの設定
3. PPTPクライアントの設定

## 1. PPTPサーバ側の設定

### モジュールの有効化

~~~~
modprobe ppp-compress-18
~~~~

### pptpdのインストール

~~~~
apt-get install pptpd
~~~~

### pptpdの設定

`/etc/pptpd.conf`に以下の設定をする。
PPTPサーバのIPアドレス`192.168.0.128`と、PPTPクライアントに割り当てるIPを`192.168.0.129-137`まで10個確保する。
今回は`eth1`のブロードキャストをPPTPクライントにリレーするために`bcrelay eth1`も指定する。

~~~~
localip 192.168.0.128
remoteip 192.168.0.129-137
bcrelay eth1
~~~~

### pptpdオプションの設定

`/etc/ppp/pptpd-options`を設定する。
このファイルではPPTPクライアントが利用するDNSサーバやMTU、MRUを設定する。今回はルータがDNSサーバを兼ねるので以下のようにする。

~~~
ms-dns 192.168.0.1
noipx
mtu 1490
mru 1490
~~~

### 接続用の設定

`/etc/ppp/chap-secrets`を設定する。
このファイルではPPTPサーバに接続するための認証情報を設定する。`USERNAME`と`PASSWORD`は自分で決めた値に読み替える。`[TAB]`はタブである。

~~~~
USERNAME[TAB]*[TAB]PASSWORD[TAB]*
~~~~

### pptpdのサービス再起動

pptpdの設定は以上で完了したので`pptpd`を再起動する。

~~~~
/etc/init.d/pptpd restart
~~~~

### IPフォワーディングの設定

`/etc/sysctl.conf`でIPv4のIPフォワーディングを有効にする設定をする。

~~~~
net.ipv4.ip_forward=1
~~~~

設定を反映するには`sysctl -p`を実行する。

~~~~
sysctl -p
~~~~

### iptablesの設定

iptablesを利用している場合は、ここでiptablesでPPTPを疎通させるように設定を行う。今回はiptablesは全てのポリシーをACCEPTにしている前提なので、ここでは説明しない。

## 2. ルータの設定

利用しているルータでTCPのポート1723とIPの47番(GRE)をPPTPサーバに通過させる設定をする。設定方法はルータにより異なる。

以下では参考までにYAMAHA RTX1000でPPTPサーバを外部に公開するフィルタとNATディスクリプタの定義を抜粋して紹介する。

RTX1000を個人で使っている人には釈迦に説法だと思うが、実際に設定する場合は、PP番号、フィルタ番号、NATディスクリプタの番号は適宜自分の設定に読み替える。

~~~~
ip filter 1000 pass * 192.168.0.128 tcp * 1723
ip filter 1001 pass * 192.168.0.128 gre

nat descriptor masquerade static 1 1 192.168.0.128 tcp 1723
nat descriptor masquerade static 1 2 192.168.0.128 gre

pp select 1
	ip pp secure filter in 1000 1001 # 実際は他のフィルタも同時に適用する
~~~~

## 3. PPTPクライアントの設定

PPTPクライアントは何でも良いが、ここではDebianの設定例を紹介する。

### PPTPクライアントのインストール

まずPPTPクライアントをインストールする。

~~~~
apt-get install pptp-linux
~~~~

### 接続先の設定

接続先の設定は`pptpsetup`コマンドで行う。
このコマンドは`/etc/ppp/peers/`以下に接続先の設定を保存する。
接続名の`VPN`、ホスト名`HOST`、ユーザ名`USERNAME`、`PASSWORD`は適宜読み替える。

~~~~
pptpsetup --create VPN --server HOST --username USERNAME -password PASSWORD --encrypt
~~~~

### 接続先へのルーティング設定

接続先のネットワークへのルーティングを設定してやる。

~~~~
route add -net 192.168.0.0 netmask 255.255.255.0 ppp0
~~~~

これで`192.168.0.1`に対して`ping`が通れば成功である。

~~~~
ping 192.168.0.1
~~~~

~~~~
PING 192.168.0.1 (192.168.0.1) 56(84) bytes of data.
64 bytes from 192.168.0.1: icmp_req=1 ttl=254 time=77.2 ms
...
~~~~

### 接続先の削除

なお設定変更時などいったんPPTPの設定を削除したい場合は、`pppsetup --delete VPN`を使う。

~~~~
pppsetup --delete VPN
~~~~

### 注意事項

中にはIP 47番のGREを内側から疎通させないネットワークも存在する。その場合PPTPクライアントからPPTPサーバへの接続は行えない。ハマりどころで多そうなのは、DocomoのSPモードなどである。

同様に自宅のネットワークでも、ルータがGREを通過させない場合は、GREを外部に向けて通過させる設定が必要になる。参考までにRTX1000の場合は以下である。

~~~~
ip filter 2000 pass * * gre
select pp 1
	ip pp secure filer 2000 # 実際は他のフィルタも同時に適用する
~~~~

## 参考

- [Setting up a PPTP VPN Server on Debian/Ubuntu](http://jesin.tk/setup-pptp-vpn-server-debian-ubuntu/)
