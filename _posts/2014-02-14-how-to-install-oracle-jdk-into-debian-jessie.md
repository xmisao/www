---
layout: blog
title: Debian jessieにOracleのJDKをインストールする方法
tag: ['linux', 'java']
---

# Debian jessieにOracleのJDKをインストールする方法

## ダウンロード

OracleのページからJDKのtarボールをダウンロードする。(64bitのDebianなら"jdk-7-linux-x64.tar.gz")

- [Java SE Development Kit 7 Downloads](http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html)

なおブラウザが使えない場合は、[Oracle JDKをコマンドラインからダウンロードする方法](http://www.xmisao.com/2014/02/14/how-to-download-oracle-jdk-from-the-commandline.html)に記載の方法でダウンロードできる。

## 準備

`java-package`パッケージをインストールする。このパッケージは、OracleのJDKからdebパッケージを生成するツールである。

~~~~
apt-get install java-package
~~~~

## パッケージ生成

java-packageの`make-jpkg`コマンドを使ってtarボールからdebパッケージを生成する。これにはしばらく時間がかかる。

~~~~
make-jpkg jdk-7-linux-x64.tar.gz
~~~~

## インストール

rootになって、生成されたdebパッケージを`dpkg`でインストールする。

~~~~
dpkg -i oracle-java7-jdk_7_amd64.deb
~~~~

以上でDeiban jessieでOracleのJDKが使用可能になる。

## デフォルトの設定

複数のJavaがインストールされている場合は、デフォルトを設定してやる必要がある。

`update-java-alternatives -l`でインストール済みのJavaを一覧できる。

~~~~
update-java-alternatives -l
~~~~

`update-java-alternatives -s`でデフォルトのJavaを設定する。

~~~~
update-java-alternatives -s jdk-7-oracle-x64
~~~~
