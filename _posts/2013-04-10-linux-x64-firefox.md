---
layout: default
title: x86_64のLinuxでMozilla公式のfirefoxの64bit版バイナリを使う
---

# x86_64のLinuxでMozilla公式のfirefoxの64bit版バイナリを使う

なぜかWebからはたどり着けないが、下記のURLからダウンロードできる。
ディストロのfirefoxに満足できない場合は手間をかけず使えてありがたい。
(リンクは現時点の最新版firefox 20.0.1)

[ftp://ftp.mozilla.org/pub/firefox/releases/20.0.1/linux-x86_64/ja/](ftp://ftp.mozilla.org/pub/firefox/releases/20.0.1/linux-x86_64/ja/)

展開して単にfirefoxを起動すれば良い。自分は/opt/firefox以下に置いてパスを通した。

Webからたどり着ける32bit版バイナリは、動作に32bit版のライブラリが必要になる。
手元ではxul周りで以下のようなエラーが出て動かなかった。
Mozillaのフォーラムでも似たような質問があるのでハマりどころなのだと思う。

    XPCOMGlueLoad error for file /opt/firefox/libxpcom.so:
    libxul.so: cannot open shared object file: No such file or directory
    Couldn't load XPCOM.

debian testingを愛用しているが、firefox(iceweasel)のバージョンが現時点で3.5と古く、心もとないのでMozilla公式のビルドを使ってお茶を濁した。
