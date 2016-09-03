---
layout: blog
title: ProxyCommandによるsshの多段接続について
tag: ssh
---



![ssh proxy connection]({{ site.url }}/assets/2013_10_08_ssh_proxy_command.png)

sshを使っていると、図のようにsshの接続先のホストから更に別のホストにsshコマンドを実行して接続する事があるかも知れない。接続先でまたsshコマンドを叩くのは骨が折れるが、sshにはこのような使い方をサポートしてくれる機能がある。それがProxyCommandだ。

ProxyCommandが指定されると、sshはまずProxyComamndを実行して、入出力を手元のホストのsshコネクションに直結させる。つまりProxyCommandで踏み台となるホストを経由して目的のホストに接続することができれば、sshコマンド1発で目的のホストとの多段接続を行うことができるのだ。

ProxyCommndを使った多段接続には、これまでnetcatいわゆる`nc`が使われてきた。しかし、最近のsshは`-W`オプションをサポートしており、`nc`を併用することなく、多段接続を実現することができるようになっている。以下では`nc`を使う方法と、`ssh -W`を使う方法の2通りの使い方を紹介する。

# ncを使う方法

図中の*client*の`~/.ssh/config`に以下の設定をする。
serverエントリは*server*に接続するための設定、server-anotherserverエントリは*server*を踏み台に*anotehrserver*に接続するための設定だ。
another-serverエントリのProxyCommandには、*server*に接続して`nc`を実行させ*anotherhost*と接続させる設定をする。なお.`~/.ssh/config`中で`%h`はHostNameを、`%p`はPortを表すプレースホルダだ。

~~~~
Host server
	HostName 1.2.3.4

Host server-anotherserver
	HostName 5.6.7.8
	Port 22
	ProxyCommand ssh server nc %h %p
~~~~

*server*を踏み台にして、*anotehrserver*に接続するには*client*で以下のコマンドを実行すれば良い。

~~~~
ssh server-anotherserver
~~~~

# ssh -Wを使う方法

同じく図中のclientの`~/.ssh/config`に以下の設定をする。
serverエントリは`nc`を使う方法と同様だ。
変更点はserver-anotherserverエントリのProxyCommandで、`ssh -W %h:%p server`で*server*に接続したあと*anotehrhost*に接続するように設定する。

~~~~
Host server
	HostName 1.2.3.4

Host server-anotherserver
	HostName 5.6.7.8
	Port 22
	ProxyCommand ssh -W %h:%p server
~~~~

*anoterhserver*への接続方法は`nc`の場合と変わらない。

# ncとssh -Wどちらを使うべきか?

ここで疑問が沸くのが、一体`nc`と`ssh -W`どちらを使えば良いのかという点だ。踏み台となるホストに`nc`をインストールする必要がない分、後者の`ssh -W`を使った方が良さそうに見える。

ただ`nc`を併用する方法は歴史があるので、これまで動かしてきた設定をわざわざ変更するほどのメリットがあるとは思えない。個人的には既存の設定を使う場合は`nc`をそのまま、新しい設定を書く場合は`ssh -W`を使って設定を書いてお茶を濁している。
