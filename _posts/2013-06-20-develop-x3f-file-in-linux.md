---
layout: default
title: LinuxでSIGMAのX3Fファイルを現像する
---

# LinuxでSIGMAのX3Fファイルを現像する

SIGMAのカメラはX3Fファイルで写真を保存するが、Linuxで広く使われているRAWファイル現像用のプログラムであるdcrawは、X3F形式を十分にサポートしていない。このためdcrawを利用するufraw等ではX3Fファイルを現像することはできない。

事実上、SIGMAのユーザは写真の現像のためにSIGMA Photo Proが動作するWindowsかMacを使わざるを得ないわけだが、wineとAdobe DNG Converterを使えばLinuxでもX3Fファイルを現像する抜け道が存在する。

## Adobe DNG Converterとは

Adobe DNG Converterは、各社のカメラのRAWファイルを、DNGファイルに変換できるツールである。下記ページから「Adobe DNG Converter 8.1 アップデート」のリンクからダウンロードできる。

[http://www.adobe.com/jp/support/downloads/dngwin.html](http://www.adobe.com/jp/support/downloads/dngwin.html)

DNGファイルは仕様が公開されており、dcrawでもサポートされている。本エントリではSIGMAのX3Fファイルに限定して話を進めるが、実際にはdcrawがサポートしていない大部分のカメラの写真をLinuxで現像するのに応用できるはずだ。

## wineのインストール

wineをインストールする。debianの場合は以下。

    apt-get install wine

環境がx64の場合は32bit版をインストールする。

    dpkg --add-architecture i386
		apt-get update
		apt-get install wine-bin:i386

なおAdobe DNG Converterの動作確認はwine 1.4.1で行った。

## Adobe DNG Converterのインストール

wineで先ほどダウンロードしたインストーラを起動し、Adobe DNG Converterをインストールする。

    wine DNGConverter_8_1.exe

もしwineを初めて使うなら、~/.wine/drive_c/Program Files/Adobe以下にAdobe DNG Converter.exeが展開される。

## Adobe DNG Converterの使い方

wineでAdobe DNG Converter.exeを実行するだけで、あとはGUIで操作することができる。

    wine "~/.wine/drive_c/Program Files/Adobe以下にAdobe DNG Converter.exe"

これだけだとひねりがないが、Adobe DNG Converterはコマンドラインで指定されたRAWファイルを自動でDNGファイルに変換する機能がある。GUIを使わずともスクリプト等で一括変換できるのだ。

ただしGUIを表示させずに変換するには、オプションを1つ以上与える必要がある。ここでは-cを指定する。-cはデフォルトなので副作用はない。以下のコマンドでSDIM1234.X3FがSDIM1234.DNGに変換される。

    wine "~/.wine/drive_c/Program Files/Adobe以下にAdobe DNG Converter.exe" -c SDIM1234.X3F

Adobe DNG Converterの詳しいオプションについては、次のPDFファイルを参照。

(http://wwwimages.adobe.com/www.adobe.com/content/dam/Adobe/en/products/photoshop/pdfs/dng_commandline.pdf)[http://wwwimages.adobe.com/www.adobe.com/content/dam/Adobe/en/products/photoshop/pdfs/dng_commandline.pdf]

## 好みの現像ソフトで現像する

DNGファイルは様々なソフトでサポートされているので、あとはufrawなど好みの現像ソフトで思う存分現像すれば良い。Linuxで良い写真ライフを!
