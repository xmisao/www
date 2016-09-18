---
layout: blog
title: Debian wheezyにxrdpをインストール
tag: ['linux', 'xrdp']
---



xrdpは*nixで動作するフリーのRDP(リモートデスクトップ)サーバだ。
Debian wheezyにはxrdp 0.5.0のパッケージが用意されており、簡単に利用できる。

ただし現時点のxrdpの最新版は0.6系であり、0.5系のxrdpはやや古い。
xrdp 0.5系には日本語のキーマップに関連したバグがあるらしく、利用には注意が必要。
私は日本語のキーマップを使っていないのでこの問題については未検証。

以下ではDebian wheezy標準のxrdp 0.5.0をインストールする前提で進める。

# xrdpのインストール

xrdpは以下でインストールできる。

~~~~bash
apt-get install xrdp
~~~~

インストールと同時にxrdpのデーモンが立ち上がる。

# rdesktopのインストール(Windowsから接続するなら不要)

ローカルからxrdpに接続したい場合はrdesktopをインストールする。
rdesktopはフリーのRDPクライアントだ。
以下でインストールできる。

~~~~bash
apt-get install rdesktop
~~~~

# xrdpへの接続

rdesktopを使用してローカルホストのxrdpに接続するには以下のようにする。

~~~~bash
rdesktop localhost
~~~~

これでrdesktopのウィンドウが開きログインウィンドウが表示される。
ユーザ名とパスワードを入力してログインする。

![xrdp login](/assets/2014_09_24_xrdp_login.jpg)

コンソールからログインした場合と同じデスクトップ環境が起動して操作可能になった。

![xrdp desktop](/assets/2014_09_24_xrdp_desktop.jpg)

このようにxrdpは設定なしに利用をはじめることができる。
ただいくらか注意点もあるので設定を確認してみよう。

# xrdpの設定を確認する

xrdpの設定は`/etc/xrdp/`以下に配置されている。
Debian wheezyでは以下のファイルが存在していた。

- xrdp.ini -- XRDP本体の設定ファイル
- sesman.ini -- XRDPのセッションマネージャの設定ファイル
- startwm.sh -- セッションマネージャから起動するスクリプト
- rsakeys.ini -- 接続に使うRSA鍵のペア?
- km-0407.ini -- キーマップファイル(以下同様)
- km-0409.ini
- km-040c.ini
- km-0410.ini
- km-0419.ini
- km-041d.ini

重要なのは`xrdp.ini`と`sesman.ini`だ。
`rsakeys.ini`はインストール時に自動的に生成される。
`startwm.sh`は後述するとおりユーザ毎の設定が可能となっているため、通常は編集しなくて良い。
`km-*.ini`はキーマップファイルなので無視する。

`xrdp.ini`には接続を受け付けるポート、圧縮のモード、暗号化レベル、コネクション設定が書かれている。
Debian wheezyでは`crypt_level`で指定する暗号化レベルが`low`となっているので`high`に変更すると良い。

`sesman.ini`にはセキュリティやログイン後に起動するスクリプト等の設定が書かれている。実際に使用をはじめる前に、こちらも一度設定を確認しておくと良いだろう。

# xrdp接続時に起動するウィンドウマネージャを変更する

Debian wheezyのデフォルトの`sesman.ini`では、ユーザ毎にxrdp接続時に起動するウィンドウマネージャを変更できる設定になっている。

ホームディレクトリに`startwm.sh`というシェルスクリプトを配置する。
するとxrdpのセッションマネージャは、ログイン時に`startwm.sh`を実行する。

このファイルに好みのウィンドウマネージャを起動する設定を書いてやれば良いわけだ。
例えばxrdpに接続した時にLXDEを起動するには次のようにすれば良い。

~~~~bash
exec startlxde
~~~~
