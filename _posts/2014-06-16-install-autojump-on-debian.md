---
layout: blog
title: debian wheezyにautojumpをインストール
tag: shell
---

# debian wheezyにautojumpをインストール

[autojump](https://github.com/joelthelion/autojump)は学習する`cd`を標榜するコマンドだ。

`cd`で移動したディレクトリの履歴を記録し、履歴にマッチするディレクトリに`autojump`コマンド(短縮形`j`)でジャンプすることができる。

debianではパッケージが提供されているのでaptでインストールできるが、シェルに設定が必要である。

~~~~
apt-get install autojump
~~~~

ドキュメントは`/usr/share/doc/autojump/README.Debian`にあるので一読して欲しい。

READMEによるとbashやzshであればシェルの設定ファイルに以下を追加すれば良い。

~~~~
. /usr/share/autojump/autojump.sh
~~~~

あとはシェルを再起動すれば良い。
