---
layout: blog
title: 最小インストールしたDebianの初期設定メモ
tag: linux
---



Debianのインストール時には追加のパッケージを一切インストールせず、1から環境構築するのが好きだ。
以下はDebianを使えるようにする自分用の初期設定のメモ。
気づいたことがあれば随時更新してゆく予定。

# sudo

`sudo`を使えるようにして、`user`ユーザで`sudo`できるようにする。
設定後はいったんシェルから抜けてログインし直す。
以降はroot権限が必要なコマンドも特に明記しない。

~~~~
su
apt-get update
apt-get install sudo
gpasswd -a user sudo
exit
exit
~~~~

# sshのインストール

`openssh-server`パッケージをインストールし、sshサーバを立てる。
これ以降はsshによる遠隔操作で環境構築できる。

~~~~
apt-get install openssh-server
~~~~

# aptの設定

`/etc/apt/sources.list`を書き換えておく。
具体的にはcontribとnon-freeのパッケージを追加し、さらにdebian-multimediaのリポジトリを追加する。
だいたい以下のような感じになる。

~~~~
deb http://ftp.jp.debian.org/debian/ jessie main contrib non-free
deb-src http://ftp.jp.debian.org/debian/ jessie main contrib non-free

deb http://security.debian.org/ jessie/updates main contrib non-free
deb-src http://security.debian.org/ jessie/updates main contrib non-free

deb http://ftp.jp.debian.org/debian/ jessie-updates main contrib non-free
deb-src http://ftp.jp.debian.org/debian/ jessie-updates main contrib non-free

deb http://ftp.jp.debian.org/debian/ jessie-backports main contrib non-free
deb-src http://ftp.jp.debian.org/debian/ jessie-backports main contrib non-free

deb http://www.deb-multimedia.org jessie main non-free
~~~~

# シェル関係

シェルで作業するのに欠かせないパッケージ群をインストールする。
`bash-completion`パッケージを入れれば大抵は補完が効くので`zsh`は使っていない。

~~~~
apt-get install bash-completion
apt-get install less
apt-get install vim
apt-get install htop
apt-get install screen
apt-get install psmisc
~~~~

# X環境

Xを使えるようにする。
X本体と基本的なツール、ログインマネージャ、ウィンドウマネージャをインストールする。
ログインマネージャには[SLiM](http://www.xmisao.com/2013/08/21/display-manager-slim.html)を、ウィンドウマネージャは[Awesome](http://awesome.naquadah.org/)を使っている。
タイル型ウィンドウマネージャ万歳。

~~~~
apt-get install xserver-xorg
apt-get install xinit
apt-get install xterm
apt-get install slim
apt-get install awesome
~~~~

# Dropbox

いわゆるdotfilesを共有しているので、Dropboxをインストールする。
詳しくは[64bit環境のDebianにDropboxをインストール](http://www.xmisao.com/2013/12/17/debian-64bit-dropbox-install.html)を参照。

Dropboxを使う上で不足しているパッケージは事前にインストールしておく。

~~~~
apt-get install python-gtk2 python libatk1.0-0 libgtk2.0-0
~~~~

# 各種設定

基本的には前述のDropboxで共有してあるファイルやディレクトリにリンクを張る。
参考までに以下のファイルやディレクトリを共有している。

- `.bashrc`
- `.vimrc`
- `.vim`
- `.gvimrc`
- `.screenrc`
- `.xsession`
- `.xmodmaprc`
- `.Xresource`
- 他

# ビルド環境

後々どうせ必要になるので整えておく。
`build-essential`パッケージで大抵のものは入る。

~~~~
apt-get install build-essential
~~~~

# Ruby

Ruby使いなので`ruby`を入れておく。
`ruby-dev`も入れておくと幸せになれる。

~~~~
apt-get install ruby ruby-dev
~~~~

ついでに`gem`で`mechanize`のような複雑なパッケージをインストールしてみて、不足しているパッケージがあれば随時インストールし、ネイティブエクステンションをビルドできる環境を整えておくと良い。

~~~~
gem install mechanize
~~~~

# 日本語変換

インプットメソッドはUIMを使う。
日本語変換にはMozcを使う。
パッケージをインストール後、`im-config`で`uim`を選択して設定完了。

~~~~
apt-get install uim mozc-server uim-mozc
~~~~

~~~~
im-config
~~~~

# サウンドサーバ

PulseAudioをインストールする。
音量設定を行う`pavucontrol`パッケージも入れておく。

~~~~
apt-get install pulseaudio pavucontrol
~~~~

# システム関係

CPUの省電力設定を行うため`cpufrequtils`をインストールする。

~~~~
apt-get install cpufrequtils
~~~~

# お気に入りのアプリケーション

良く使うアプリケーションをまとめて入れる。
ブラウザはFirefoxを使いたいが、Debianのリポジトリはバージョンが古いため、自力でインストールする。
詳しくは[x86_64のLinuxでMozilla公式のfirefoxの64bit版バイナリを使う](http://www.xmisao.com/2013/04/10/linux-x64-firefox.html)を参照。

~~~~
apt-get install vim-gtk
apt-get install geeqie
apt-get install rox-filer
apt-get install smplayer
apt-get install audacious
apt-get install chromium
apt-get install gimp
apt-get install dia
apt-get install tgif
apt-get install libreoffice
~~~~

## Firefox拡張のインストール

現在使っているFirefox拡張は以下のとおり。
それぞれインストールする。

- Adblock Plus
- Firebug
- FireGestures
- Flashblock
- Googleアナリティクス オプトアウト アドオン
- Vimperator
