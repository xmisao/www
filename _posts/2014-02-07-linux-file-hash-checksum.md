---
layout: blog
title: Linuxでファイルのチェックサムを表示するには
tag: linux
---

# Linuxでファイルのチェックサムを表示するには

主なLinuxディストリビューションではファイルの各種ハッシュ値を計算するユーティリティが用意されている。

MD5のハッシュ値を計算するには`md5sum`コマンドを使う。

~~~~
md5sum FILE
~~~~

SHA-1のハッシュ値を計算するには`sha1sum`コマンドを使う。

~~~~
sha1sum FILE
~~~~

これらのコマンドは`-c`オプションを使うとハッシュ値でファイルのコンペアを行うこともできる。

~~~~
md5sum FILE > FILE.md5
md5sum -c FILE.md5
~~~~

~~~~
sha1sum FILE > FILE.sha1
sha1sum -c FILE.sha1
~~~~

手元のdebianで確認したところ、他にも以下のハッシュ計算用のユーティリティが存在した。

- `shasum`
- `sha224sum`
- `sha256sum`
- `sha384sum`
- `sha512sum`

ちなみに`openssl`コマンドもハッシュ値を計算する機能を持っている。例えばMD5とSHA-1のハッシュ値を計算するには以下のようにする。

~~~~
openssl md5 FILE
openssl sha1 FILE
~~~~

`openssl`でハッシュを計算するサブコマンドには以下がある。こちらはMD2やRMD-160などのマイナーなハッシュ値も計算可能だ。

- md2
- md5
- mdc2
- rmd160
- sha
- sha1
- sha224
- sha256
- sha384
- sha512
