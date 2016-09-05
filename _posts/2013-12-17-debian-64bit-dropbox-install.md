---
layout: blog
title: 64bit環境のDebian WheezyにDropboxをインストール
tag: linux
---



DropboxはLinuxにも対応している。
今回は64bit版のDebian WheezyにDropboxをインストールして使えるようにしてみる。
以下ではDropbox本体と、本体を補助するdropboxパッケージに分けて説明する。

# Dropbox本体のダウンロードとインストール

Dropboxの公式サイトに記載されているとおり以下のコマンドを実行する。

`cd`したり`wget`したり`tar`したりしているが、これはホームディレクトリ直下にダウンロードしたtgzファイルを展開するだけだ。
このtgzファイルには`.dropbox-dist`ディレクトリが入っており、これでホームディレクトリ直下にDropbox本体が入った`.dropbox-dist`ディレクトリができる。

~~~~
$ cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
~~~~

続いてDropboxのデーモンの起動を行う。Dropboxのデーモンは`.dropbox-dist/dropboxd`である。
もしXが起動しているGUI環境であれば、この時点でウィンドウが表示されてユーザ名とパスワードの入力を求められる。
もしXが起動していないCUI環境であれば、以下のように認証用のURLが表示されるので、このURLにWebブラウザからアクセスして認証を行うことになる。

~~~~
$ .dropbox-dist/dropboxd
This client is not linked to any account...
Please visit https://www.dropbox.com/cli_link?host_id=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx to link this machine.
~~~~

認証が成功すればホームディレクトリ直下に`Dropbox`ディレクトリが作成され、このディレクトリがDropboxで同期される。

# dropboxパッケージのダウンロードとインストール(オプション)

dropboxパッケージはdropboxのデーモンを操作するコマンドやNautilus用のエクステンションを含んでいる。
Dropboxを利用する上で必須というわけではないが、ぜひインストールしておこう。

以下のリンクから自分の環境にあったパッケージをダウンロードする。
今回は64bit版のDebian用のパッケージをダウンロードする。
本エントリ執筆時のバージョンは1.6.0だった。

-[https://www.dropbox.com/install?os=lnx](https://www.dropbox.com/install?os=lnx)

ダウンロードしたパッケージは`dpkg`でインストールする。

~~~~
$ dpkg -i  sudo dpkg -i dropbox_1.6.0_amd64.deb
~~~~

このパッケージをインストールすると`dropbox`コマンドが使用可能になる。
`dropbox`コマンドの実体は、pythonで実装されたスクリプトで、ホームディレクトリにインストールされたDropbox本体を操作する機能を持つ。

`dropbox`コマンドのヘルプは以下のとおりだ。

~~~~
$ dropbox --help
Dropbox command-line interface

commands:

Note: use dropbox help <command> to view usage for a specific command.

 status       get current status of the dropboxd
 help         provide help
 puburl       get public url of a file in your dropbox
 stop         stop dropboxd
 running      return whether dropbox is running
 start        start dropboxd
 filestatus   get current sync status of one or more files
 ls           list directory contents with current sync status
 autostart    automatically start dropbox at login
 exclude      ignores/excludes a directory from syncing
 lansync      enables or disables LAN sync
~~~~

dropboxの起動は`dropbox start`で行える。
これでLinuxでもDropboxの恩恵に預かれるというわけだ。

~~~~
$ dropbox start
~~~~
