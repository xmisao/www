---
layout: blog
title: Debian WheezyへのZabbix 2.0のインストール
tag: ['zabbix', 'server']
---



Debian WheezyにZabbix 2.0をインストールしてみることにする。
基本的にマニュアルの[Installation from packages](https://www.zabbix.com/documentation/2.0/manual/installation/install_from_packages)の通りに進める。
ただし多少詰まったとこがあったので、随時コメントを加えている。

# Zabbixパッケージのインストール

Zabbixのインストールはzabbixパッケージのインストールから始まる。
このパッケージはZabbix本体ではなく、Zabbixをaptでダウンロードしてインストールするための準備をするものだ。
サイズも拍子抜けするほどコンパクトだ。
このパッケージをインストールするとZabbixの本体をaptからインストールすることが可能となる。

~~~~
wget http://repo.zabbix.com/zabbix/2.0/debian/pool/main/z/zabbix-release/zabbix-release_2.0-1wheezy_all.deb
dpkg -i zabbix-release_2.0-1wheezy_all.deb
apt-get update
~~~~

# Zabbix本体のインストール

## 本体のインストール

続いてZabbixの本体をインストールする。自動的に最新版が入る。
もし不足しているパッケージ(ApacheやMySQLなど)があれば同時にインストールされる。
このパッケージのインストールの途中で、MySQLの管理者パスワードと、Zabbixが使うユーザパスワードの入力を求められる。

~~~~
apt-get install zabbix-server-mysql zabbix-frontend-php
~~~~

# PHPのタイムゾーン設定

続いてPHPのタイムゾーンを設定する。
`/etc/apache2/conf.d/zabbix`を開き、コメントアウトされている`php_value data.timezone`の行を有効にする。
タイムゾーンは日本ならば`Asia/Tokyo`に変更する。

~~~~
php_value date.timezone Asia/Tokyo
~~~~

## Apacheの再起動

これでZabbixにアクセスする準備ができた。
Apacheを再起動しよう。

~~~~
/etc/init.d/apache2 restart
~~~~

デフォルトではhttp://zabbixhostname/zabbixでZabbixにアクセスできる。
必要に応じてApacheの設定を整えZabbixを運用しよう。

以降はブラウザでの操作となる。

# Zabbixの初期設定

ブラウザで最初に表示されるのは、Zabbixの初期設定画面だ。
順に見ていく。

## 1. Welcome

![Welcome](/assets/2013_10_23_zabbix000.jpg)

Nextボタンを押して次に進む。

## 2. Check of pre-requisites

![Check of pre-requesites](/assets/2013_10_23_zabbix001.jpg)

すべてOKなら問題ない。
Nextボタンを押して次に進む。

## 3. Configure DB connection

![Configure DB connection](/assets/2013_10_23_zabbix002.jpg)

MySQLの管理者パスワードを入力する。
Test Connectionボタンで接続をテストできる。
最後にNextボタンを押して次に進む。

## 4. Zabbix server details

![Zabbix server details](/assets/2013_10_23_zabbix003.jpg)

ホスト名とポートの設定画面だ。
Nextをボタンを押下して次に進む。

## 5. Pre-Installation summary

![Pre-Installation summary](/assets/2013_10_23_zabbix004.jpg)

Zabbixサーバの詳細が表示される画面だ。
Nextを押下して次に進む。

## 6. Install

![Install Fail](/assets/2013_10_23_zabbix005.jpg)

PHPの設定ファイルを配置する画面だ。

ここだけは私の環境では手動で設定が必要だった。
/usr/share/zabbix/conf/zabbix.confファイルの作成に失敗し、エラーが表示されたのだ。このファイルは、デフォルトでは/etc/zabbix/web/zabbix.conf.phpのシンボリックリンクになっていた。

Donwload configuration fileのボタンからzabbix.conf.phpファイルをダウンロードし、/etc/zabbix/web/zabbix.conf.phpに配置した。

この状態でRetryボタンを押すとインストールが終了した。

![Install Ok](/assets/2013_10_23_zabbix006.jpg)

これ以降の操作はオプションとなる。

# Zabbixへのログイン

![Login Screen](/assets/2013_10_23_zabbix007.jpg)

http://zabbixhostname/zabbixにアクセスする。
デフォルトのユーザ名はAdmin、パスワードはzabbixだ。

## Zabbixサーバの監視

![Configure -> Hosts](/assets/2013_10_23_zabbix008.jpg)

Zabbix 1.8.3以降はデフォルトでZabbixサーバはサーバの機能だけが有効になっており、Zabbixサーバを監視する機能は無効になっている。

Zabbixサーバの監視は、Zabbixサーバ上から有効にすることができる。
Configuration -> Hostsを開いて、Zabbix Serverの"Not monitered"をクリックするとZabbixサーバを監視できるようになる。

## フォントの問題が発生しないか確認

なお私の環境ではMonitoring -> Mapsなどの画面で以下のエラーが発生しが。
画像やグラフが正常に表示されなず、以下のようなメッセージが出る。
メッセージから推測すると、フォントが存在しないことが原因のようだ。

~~~~
imagettftext(): Cound not find/open font ...
~~~~

とりあえずttf-dejavuパッケージをインストールしたら動作するようになった。

~~~~
apt-get install ttf-dejavu
~~~~

# Zabbix ServerのホストをZabbix Agentで監視する

先ほどまではZabbixサーバ自体の監視の話だった。
ここの内容はZabbixサーバのホスト監視(CPU使用率など)に関するものだ。

監視にはZabbix Agentが必要になる。
ZabbixサーバをZabbix Agentで監視しよう。
Zabbix Agentのインストールは以下のとおり。

~~~~
apt-get install zabbix-agent
~~~~

これでZabbixサーバが動作しているホストのCPU使用率などが、Zabbixサーバ上で確認できるようになる。Monitoring -> GraphsからCPU loadなどを確認しよう。

![Welcome](/assets/2013_10_23_zabbix009.jpg)

現在のZabbixは必ずしも使いやすいUIとは言えないが、
このエントリに興味を持って読んでもらえるレベルの人なら
Zabbixの基本的な使いかたでつまづくことは少ないだろう。
あとは自由に操作すれば良い。

長くなったが、ようこそZabbixへ!
