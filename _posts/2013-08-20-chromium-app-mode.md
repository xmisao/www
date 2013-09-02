---
layout: blog
title: Chromium(Google Chrome)でWebページをアプリのように使う
tag: linux
---

# Chromium(Google Chrome)でWebページをアプリのように使う

Chromium(Google Chrome)には、メニューバーやタブバーを表示せずに、Webページをアプリケーションのように開けるappモードが存在する。

これにプロファイル切り替えの機能を併用すると、GmailやSNSを独立したプロファイルで、別々のウィンドウで開きっぱなしにできる。

具体的には以下のようなコマンドを使う。
この例では~/.config/app/をプロファイルの保存先として、Gmailを開いたウィンドウが開く。

    chromium --user-data-dir=~/.config/app/ --app=http://gmail.com/

オプションの意味は以下のとおり。

- --user-data-dir -- プロファイルの保存先
- --app -- appモードで開くURL

昔々、同様の機能を持つMozillaのPRISMというソフトがあったが、開発が終わってしまった。そのため、今はこの方法でChromiumを使っている。
