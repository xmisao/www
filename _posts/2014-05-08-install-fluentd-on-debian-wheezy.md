---
layout: blog
title: debian wheezyにfluentdをインストール
tag: ['fluentd', 'linux']
---



fluentdにはubuntu向けのdebパッケージが提供されているが、debianは公式にサポートされていない。
これをdebian wheezyにインストールするには、[何かと苦労がある](http://odoruinu.net/blog/2014/03/28/installing-fluentd-td-agent-on-debian-wheezy/)ようである。
そこで今回はfluentdをgemからインストールすることにする。

# インストール

fluentdはそのまんま`gem install fluentd`でインストールできる。

~~~~
gem install fluentd --no-ri --no-rdoc
~~~~

# 設定ファイルの出力

続いて`fluentd --setup`でfluentdの設定ファイルを出力する。
ここは悩みどころなのだが他のデーモンと揃えるなら`/etc/fluentd`以下に設置するのが良いと思う。

~~~~
mkdir /etc/fluentd
fluentd --setup /etc/fluentd
~~~~

# 起動

`fluentd`コマンドでfluentdを起動する。
`-c`オプションで先ほど出力した設定ファイルを指定する。
`-vv`は詳細な出力をするオプションである。
以下のコマンドは必要に応じてバックグラウンドで実行させよう。

~~~~
fluentd -c /opt/fluentd/fluent.conf -vv
~~~~

テストでは気にしなくて良いが、実際にはfluentdへの権限は適切に与えたいところだ。
様々なログを読む都合上、root権限で動かしたくなったりもするが…。

# テスト

fluentdが正常に動作しているかテストしてみよう。
`fluent-cat`を使えばfluentdに任意のログを送信することができる。
以下のコマンドを実行してみて、`fluentd`を実行しているターミナルに出力があれば成功だ。

~~~~
echo '{"json":"message"}' | fluent-cat debug.test
~~~~

参考

- [Installing Fluentd Using Ruby Gem](http://docs.fluentd.org/articles/install-by-gem)
