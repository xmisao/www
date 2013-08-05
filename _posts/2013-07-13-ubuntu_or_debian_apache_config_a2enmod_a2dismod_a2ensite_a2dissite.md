---
layout: default
title: UbuntuやDebianのApacheの設定について
tag: ['linux', 'server']
---

# UbuntuやDebianのApacheの設定について

Debian系OSのApache2の設定ファイルの書き方は独特で、モジュールやバーチャルホストはそれぞれ1つの設定ファイルに分けて記述し、httpd.confからそれらを読み込む方針を採っている。設定を読み解くには/etc/apache2にある以下4つのディレクトリが鍵になる。

- mods-available -- 利用可能なモジュールの設定ファイル(hoge.conf)とロード用設定(hoge.load)の実体が格納される
- mods-enabled -- 有効にしたモジュールの設定ファイルが格納されるが、これらはmods-avilable中のファイルへのシンボリックリンクである
- sites-available -- 利用可能なバーチャルホストの設定ファイルの実体が格納される
- sites-enabled -- 有効にしたバーチャルホストの設定ファイルが格納されるが、これらはsites-avilable中のファイルへのシンボリックリンクである

apache2は設定ディレクトリ下にあるapache2.confを最初に読み込み、apache2.confからhttpd.conf、更にmods-enabledとsites-enabled下にある設定ファイルをincludeする。mods-availableとsites-availableは無視する。

要するに〜availableに設定ファイルは書いておくが、〜enabledにシンボリックリンクを作るか作らないかで、モジュールやバーチャルホストの有効・無効を簡単に切り替えられる構造になっている。

この切り替えはlnやrmで自力でシンボリックリンクを操作して行なっても良いが、a2から始まる管理用のスクリプト(a2dismod, asdissite, a2enmod, a2ensite)が用意されており、有効化・無効化がコマンド1発で簡単に行えるようになっている。

例えば、imagemapモジュールの無効化。

    a2dismod imagemap

imagemapモジュールの有効化。

		a2enmod imagemap

defaultバーチャルホストの無効化。

    a2dissite default

defaultバーチャルホストの有効化。

    a2ensite default

慣れればdebianでのモジュール、バーチャルホスト管理はとても便利だ。
