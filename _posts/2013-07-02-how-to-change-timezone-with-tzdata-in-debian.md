---
layout: default
title: Debianでタイムゾーンを変更する方法 
---

# Debianでタイムゾーンを変更する方法

Amazon EC2を使っていてdebian wheezyでタイムゾーンの変更をした。滅多に機会がないのでメモっておく。以下のコマンドで対話的に変更できる。

    dpkg-reconfigure tzdata

Linuxのタイムゾーン設定は/etc/localtimeで行われている。タイムゾーン変更時は、基本的にこのファイルを/usr/share/zoneinfo/以下のタイムゾーンデータに差し替えてやれば良い。上記のコマンドでも結果的にはこのファイルの内容が書き換わる。

/etc/localtimeの変更方法はディストリビューションにより様々だが、squeezeより前のdebianではtzconfigというコマンドが用意されており、このコマンドでタイムゾーンの変更を行なっていた。

wheezyも含め、squeeze以降ではtzconfigを実行しようとすると、tzconfigが非推奨であることを示すメッセージが表示されるようになっている。
