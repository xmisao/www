---
layout: blog
title: Android端末をリモート操作するアプリ3つ!
tag: android
---

# Android端末をリモート操作するアプリ3つ!

ちょっと必要に迫られて、Android端末をリモート操作する方法があるのかどうか、その事情を調べてみた。
結論から書くと、root化していない端末で、PCからの操作のみでAndroid端末を完全にリモート操作する方法は、現時点で存在しない。

## リモート操作の定義

まずAndroidをリモート操作する言葉についてだ。
この言葉は以下の2つの意味で使われている。
このエントリでは、この違いをはっきりさせておく。

1. Android端末のファイルやアプリを遠隔操作で管理する
2. Andorid端末の画面を直接遠隔操作する

## 1. Android端末のファイルやアプリを遠隔操作で管理する

![AirDroid]({{ site.url }}/assets/2013_12_23_airdroid.jpg)

*AirDroidの仮想デスクトップ画面*

Android端末のファイルやアプリを、PCから遠隔操作で管理するリモート操作である。
Android端末とPCのファイル共有や、小さな画面では煩雑な操作をPCから行う目的で使われる。

このリモート操作を実現するアプリで一番メジャーなのは、AirDroidだ。

- [AirDroid](https://play.google.com/store/apps/details?id=com.sand.airdroid&hl=ja)

AirDroidをAndroid端末で起動すると、AirDroidの仮想デスクトップを表示するHTTPサーバが立ち上がる。
Android端末の画面にURLが表示されるので、PCからこのURLにアクセスし、ブラウザ経由で遠隔操作を行う。
PCからアクセスしたタイミングでAndroid端末にはダイアログが表示され、操作を承認するとはじめて遠隔操作が可能となる。

つまりAirDoridによる遠隔操作にはAndroid端末で以下の2操作が必要である。

1. AirDroidを起動する
2. AirDroidでPCからアクセスを承認する

AirDroidで行える主な操作は以下のとおり。

- メッセージの表示と送受信
- アプリの管理
- ファイル、写真、音楽、ビデオの管理
- 着信音の設定
- 通話と通話履歴の管理
- 連絡先の管理
- スクリーンショットの撮影(要root化)
- カメラの操作

## 2. Andorid端末の画面を直接遠隔操作する

いわゆるVNCやRemote Desktopのように、PCからAndroid端末の画面を直接操作するリモート操作である。
PCでのリモート操作に慣れている人であれば、こちらを思い浮かべる人が多いだろう。

この方式のリモート操作は、Androidでの実装が困難らしく、root化していない端末では満足に利用できない。一応、メジャーと思われる2つのアプリを紹介する。

### droid VNC server (無料)

- [droid VNC server](https://play.google.com/store/apps/details?id=org.onaips.vnc&hl=ja)

利用には端末のroot化が必須である。

その名の通りAndroid端末にVNCサーバを立ち上げるものだ。
root化さえしていれば、理想的なリモート操作が可能だと思われる。

アプリを起動してStartをタップするとVNCサーバが立ち上がる。
またJava Appletによる遠隔操作が行えるHTTPサーバも同時に立ち上がる。

一応、CyanogenModを導入した手元のKindle Fire HD 8.9で試してみたが、どうやってもVNCサーバに接続することはできなかった。残念だ。

### VMLite VNC Server (有料)

- [VMLite VNC Server](https://play.google.com/store/apps/details?id=com.vmlite.vncserver&hl=ja)

端末をroot化していなくても以下の条件付きで利用可能である。
root化した端末なら端末単体で動作可能だ。

- Android端末をUSBデバッグモードに設定しておく
- 端末とPC(Windows / Mac)をUSBケーブルで接続する
- PCからVMLite Android App Controllerを起動する

アプリを起動してStartをタップすると、root化した端末ならVNCサーバが立ち上がる。root化していない端末なら、

また同時にWebブラウザ経由の遠隔操作を可能とする、HTTPサーバも立ち上がる。こちらはJava Appletではなく、HTML5 Canvasを利用しており、Javaは不要である。

VMLite VNC Serverは有料(約1000円)だけあって、こちらは無事にVNCで接続可能であった。またWebブラウザ経由の遠隔操作も可能であった。

## おわりに

以上、Android端末のリモート操作事情について調査して3つのアプリを紹介した。この分野はまだ実用になる方法がないというのが正直な感想である。
