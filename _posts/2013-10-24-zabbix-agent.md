---
layout: blog
title: Zabbix 2.0で他のホストを監視する
tag: ['zabbix', 'server']
---



[Debian WheezyへのZabbix 2.0のインストール](/2013/10/23/zabbix-instration.htm)では、Zabbixサーバをインストールしサーバのホストを監視する方法を説明した。続いて、他のDebian WheezyホストにZabbix Agentをインストールし、Zabbixの監視対象に追加してみよう。

# 前提

前提としてZabbixサーバホストのポート10051番、Zabbix Agentホストのポート10050番が開いている必要がある。Zabbix サーバとZabbix Agentの間にファイアウォールがある場合は疎通させる設定が必要になる。

![Network Requirements]({{ site.url }}/assets/2013_10_24_network_requirements.png)

# ホストへのZabbix Agentのインストール

Zabbix Agentのインストールの手順は、Zabbix サーバの場合とほとんど変わらない。ZabbixのサイトからZabbixパッケージをダウンロードし、aptからZabbixがインストールできるようにする。

~~~~
wget http://repo.zabbix.com/zabbix/2.0/debian/pool/main/z/zabbix-release/zabbix-release_2.0-1wheezy_all.deb
dpkg -i zabbix-release_2.0-1wheezy_all.deb
apt-get update
~~~~

続いて、Zabbixサーバのインストールでは、zabbix-server-mysqlとzabbix-frontend-phpをインストールした。Zabbix Agentの場合は代わりにzabbix-agentのみをインストールする。

~~~~
apt-get install zabbix-agent
~~~~

# Zabbix Agentの設定変更

Zabbix Agentには、Zabbix サーバのホストを設定ファイルで教えてやる必要がある。/etc/zabbix/zabbix_agentd.confの、Server=の行にZabbix サーバのIPアドレスを入力する。

~~~~
Server=1.2.3.4
~~~~

設定を保存し、Zabbix Agentのサービスを再起動しよう。

~~~~
/etc/init.d/zabbix-agent restart
~~~~

# Zabbix サーバから監視対象を追加する

Zabbixにログインする。
以下はGUIの操作になるので、スクリーンショットを交えながら説明してゆく。

![Config -> Hosts]({{ site.url }}/assets/2013_10_24_zabbix000.jpg)

まずConfiguration -> Hostsと進む。右上にあるCreate hostボタンを押下し監視対象のホストを追加する画面にを開く。

![Config -> Hosts]({{ site.url }}/assets/2013_10_24_zabbix001.jpg)

ホストの追加画面では以下の項目を入力する。

- Host name -- ホスト名
- Visible name -- ホストの表示名
- New host group -- ホストが所属するグループ(新しいホストグループを作る場合)
- IP address -- AgentホストのIPアドレス

![Create host]({{ site.url }}/assets/2013_10_24_zabbix001.jpg)

ついでにテンプレートの設定をしておこう。このZabbix AgentをLinux サーバのテンプレートで監視できるようにする。Templatesタグを開く。Template OS Linuxにチェックを入れて、Selectボタンを押下する。

![Templates]({{ site.url }}/assets/2013_10_24_zabbix002.jpg)

![Templates]({{ site.url }}/assets/2013_10_24_zabbix003.jpg)

再びHostタブを戻り、Saveボタンを押下しよう。これでZabbix Agentを監視し、Linux サーバのテンプレートで監視する設定が終了する。

# おわりに

以上の手順で、Zabbix サーバでZabbix Agentのホストを監視することができるようになった。さっそくトレンドデータが取得できていることをMonitoringから確認してみよう。
