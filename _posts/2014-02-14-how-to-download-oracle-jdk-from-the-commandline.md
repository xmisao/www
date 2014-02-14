---
layout: blog
title: Oracle JDKをコマンドラインからダウンロードする方法
tag: ['linux', 'java']
---

# Oracle JDKをコマンドラインからダウンロードする方法

ブラウザをインストールしていないマシンでOracleのJDKをダウンロードするには、`wget`を使って以下のようにすれば良い。

~~~~
wget --no-cookies --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com" "http://download.oracle.com/otn-pub/java/jdk/7/jdk-7-linux-x64.tar.gz"
~~~~

Javaのように公共性が高いソフトウェアをダウンロードするのに、なぜクッキーが必要なのか理解に苦しむ。本当にOracleはクソだ。

- [How to automate download and instalation of Java JDK on Linux?](http://stackoverflow.com/questions/10268583/how-to-automate-download-and-instalation-of-java-jdk-on-linux)
