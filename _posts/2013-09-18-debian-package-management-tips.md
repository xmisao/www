---
layout: blog
title: Debianパッケージ管理の5つのTIPS
tag: linux
---



apt-getやdpkgでパッケージを入れたり消したりできるようになったばかりのDebianパッケージ管理初心者。このエントリでは、そんな初心者に一歩進んだDebianパッケージ管理の5つのTIPSを紹介する。

解説中のPACKAGEはパッケージ名に、FILEはファイルにそれぞれ読み替えること。

# 1. パッケージが含むファイルを一覧表示

    dpkg -L PACKAGE

あるインストール済みパッケージが含むファイルを一覧表示するコマンドだ。このパッケージはどんなファイルを提供しているんだ? と調べる場合に使う。

# 2. ファイルが含まれるパッケージを検索

    dpkg -s FILE

あるファイルがどのパッケージから提供されたものなんか調べるコマンドだ。いつの間にかできていたが、こいつは一体何者なんだ? と思った場合に使う。

# 3. ソースコードのダウンロード

    apt-get source PACKAGE

リポジトリからソースパッケージをダウンロードし、中身を展開するコマンドだ。パッケージの実装がどうなっているのか、調査したり、独自のパッチを当てたりする場合に使うコマンドだ。自由なソフトウェアを使っていると実感させてくれる神コマンド。

# 4. パッケージの完全削除

    apt-get purge PACKAGE

パッケージを完全に削除するコマンドだ。実は`apt-get remove`では設定ファイルなど、一部のファイルは残ったままになる。パッケージをいったん完全削除して再インストールしたい場合や、あるパッケージの影響を完全に取り除きたい場合に使う。

# 5. キャッシュの削除

    apt-get autoremove
    apt-get clean

`autoremove`は依存関係で不要になったパッケージを自動的に削除するコマンド。`clean`はダウンロード済みパッケージのキャッシュをクリアするコマンドだ。2つを併せて実行することで、不要なファイルを削除し、ディスク容量を空けることができる。
