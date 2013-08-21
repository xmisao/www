---
layout: default
title: 軽量ディスプレイマネージャslimと自動ログイン設定
tag: linux
---

# 軽量ディスプレイマネージャSLiMと自動ログイン設定

[SLiM](http://slim.berlios.de/)は軽量なXのディスプレイマネージャだ。

ディスプレイマネージャはGDMや、KDMがメジャーだが、これらはそれぞれGnomeとKDEに依存している。私はウィンドウマネージャに[Awesome](http://awesome.naquadah.org/)を愛用しているので、GDMもKDMも使いたくない。

SLiMは特定のデスクトップ環境に依存しない。またX11標準のXDMより高機能で、見た目が良い。こだわりの環境を使っている人にぴったりのディスプレイマネージャだ。

Debianではパッケージがあり、SLiMは以下でインストールできる。

    apt-get install slim

XDMとの最大の違いは、パスワード入力なしで自動ログインする設定ができるところだ。設定は/etc/slim.confで行う。自動ログインに必要なのは以下の2行。

    default_user xmisao
    auto_login yes

これでSLiMの起動と同時に、ユーザxmisaoにパスワード入力なしで自動ログインできる。快適。
