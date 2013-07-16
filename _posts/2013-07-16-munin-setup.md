---
layout: default
title: muninによる複数ホスト監視環境の構築
---

# muninによる複数ホスト監視環境の構築

リソースモニタリングツールであるmuninは、ネットワークを通じて複数のホストを監視し、リソースの使用状況を出力することができる。今回は2台のdebian wheezyホストを監視する環境を構築する。

## 前提

muninは監視対象のホストからリソースの使用状況を収集してグラフ化するmunin本体と、個々のホストの使用状況を収集して転送するmunin-nodeに分かれている。

munin本体は1台のホストだけにインストールすれば良いが、munin-nodeは監視対象すべてのホストにインストールする。

muninは/var/chache/munin以下にリソースの使用状況をまとめたWebページを出力する機能しか持っていない。出力したWebページを別途Apache等のHTTPサーバで参照できるようにすることで、どこからでもリソースの使用状況が参照できるようになる。

以下ではApache + munin + munin-nodeをインストールしたサーバ(host1.example.com, 192.168.1.2)と、munin-nodeのみをインストールしたクライアント(host2.example.com, 192.168.1.3)の合計2台を監視する環境を構築する。

## サーバ

debianではmuninをaptでインストールできる。サーバであり、監視対象でもあるので、muninとmunin-nodeの両方をインストールする。

    apt-get install munin munin-node

muninパッケージをインストールすると、/etc/cron.d/muninが作られ、定期的にmuninを起動して/var/cache/munin以下にWebページが出力されるようになる。

muninで複数台のホストの監視を行うには、設定ファイル/etc/munin/munin.confで監視対象のmunin-nodeホストを教えてやる必要がある。設定ファイルに以下の内容を記述する。なおhost2.example.comが名前解決できるなら、IPアドレスでなくホスト名でも指定できる。

    [host1.example.com]
        address 127.0.0.1
    		use_node_name yes
    
    [host2.example.com]
        address 192.168.1.3
    		use_node_name yes

munin-nodeはデフォルトでローカルホストからの接続を許可する設定になっているので、サーバではmunin-nodeの設定は行わない。

続いて、サーバにはApacheは別途インストールされている前提として、以下の環境構築を行う。設定ファイルの例は/etc/munin/apache.confにあるので、その記述を参考に以下の設定を追加する。

この例では、若干工夫をしてLAN内192.168.1.0/255.255.255.0からのみアクセスできる設定にしている。インターネット越しに利用する場合は、BASIC認証に読み替えると良いだろう。

    Alias /munin /var/cache/munin/www
    <Directory /var/cache/munin/www>
        Order allow,deny
    		Allow from 192.168.1.0/255.255.255.0
        Options None
        <IfModule mod_expires.c>
          ExpiresActive On
          ExpiresDefault M310
        </IfModule>
    </Directory> 

Apacheとmunin-nodeを再起動する。

    /etc/init.d/apache2 restart
		/etc/init.d/munin-node restart

## クライアント(ノード)

監視対象のホストでは、munin-nodeのみをインストールする。

    apt-get install munin-node

munin-nodeは接続元のIPアドレスによってアクセス制御を行なっている。このため、サーバからのアクセスを許可する設定を行う。設定ファイル/etc/munin/munin-node.confに以下の設定を追記する。

    allow ^192\.168\.1\.2$

設定が終わったらmunin-nodeを再起動する。

    /etc/init.d/munin-node restart

## おわりに

以上でサーバで、サーバとクライアントの2台を監視する設定が完了した。

muninは定期的に実行するため、正しくグラフが表示されるまで若干のタイムラグがある。しばらくして、Apache経由でmuninにアクセスし、2ホスト分の情報が表示されていれば成功だ。
