---
layout: blog
title: ユニコードでエンコードしたmplusフォントの作り方
tag: linux
---



mplusフォントが好きだ。
しかし、mplusフォントはエンコーディングがJIS X 0208のBDFファイルしか配布されていない。
debianのxfonts-mplusパッケージも同様だ。
これではUTF-8のxtermで、正しく日本語を表示することができない。

何とかしてUTF-8のxtermでmplusフォントを使えないものか、と探したところ以下のエントリが見つかった。

- [sylpheed-2 で M+ BITMAP キター━━(゜∀゜)━━!!](http://d.hatena.ne.jp/nevil/20050829/p2)

JIS X 0208のmplusのエンコーディングをツールで変換し、UnicodeでエンコーディングしたBDFファイルを自作するという内容だ。以下はこのエントリに倣って、自分でUnicodeのmplusフォントを作ってみる。

最後にはこの手順で作成した私家版debパッケージを用意したので、同じ悩みを抱えた人にぜひ使ってもらいたい。

# 手順

1. mplusとモナーフォントを用意する
2. モナーフォントに付属のjis2unicodeというツールを使って、mplusのJIS X 0208のフォントをユニコードに変換する
3. mplusの和文と英文のフォントをマージする
4. BDFファイルの内容を整える
5. BCFファイルをPCF.GZに圧縮する

# 1. mplusとモナーフォントを用意する

それぞれ以下からダウンロードして展開しておく。

- [M+ FONTS](http://sourceforge.jp/projects/mplus-fonts/downloads/5030/mplus_bitmap_fonts-2.2.4.tar.gz/)
- [モナーフォント](http://sourceforge.net/projects/monafont/files/monafont/monafont-2.90/monafont-2.90.tar.bz2/download)

# 2. モナーフォントに付属のjis2unicodeというツールを使って、mplusのJIS X 0208のフォントをユニコードに変換する

mplusフォントから、以下のファイルを作業用のディレクトリにコピーしておく。

- fonts_e/mplus_f10r.bdf
- fonts_e/mplus_f12r.bdf
- fonts_j/mplus_j10r.bdf
- fonts_j/mplus_j12r.bdf

モナーフォントを展開したディレクトリの、tools/jis2unicodeを使って日本語のフォントを変換する。
フォント名は元エントリーにあわせてumplusとする。

    jis2unicode -b < mplus_j10r.bdf > umplus_j10r.bdf
    jis2unicode -b < mplus_j12r.bdf > umplus_j12r.bdf


# 3. mplusの和文と英文のフォントをマージする

英文と和文両方に対応できるように、英文と和文のフォントをマージする。
単にcatで連結して、次の手順で内容を整える。

   cat mplus_f10r.bdf >> umplus_j10r.bdf
   cat mplus_f12r.bdf >> umplus_j12r.bdf

# 4. BDFファイルの内容を整える

umplus_j10r.bdfとumplus_j12r.bdfの先頭のヘッダをそれぞれ以下のように整える。

umplus_j10r.bdf

    FONT -umplus-gothic-medium-R-normal--10-100-75-75-C-100-iso10646-1
    FOUNDRY "umplus"
    CHARSET_REGISTRY "iso10646"
    CHARS 7187

umplus_j12r.bdf

    FONT -umplus-gothic-medium-R-normal--12-120-75-75-C-120-iso10646-1
    FOUNDRY "umplus"
    CHARSET_REGISTRY "iso10646"
    CHARS 7187

1つ目のENDFONTと、連結した英文フォントのヘッダを削除する。
具体的には以下の内容を削除する。(例はumplus_j10r.bdfの場合)

    ENDFONT
    STARTFONT 2.1
    COMMENT This font is a free software.
    COMMENT Unlimited permission is granted to use, copy, and distribute it,
    COMMENT with or without modification, either commercially and noncommercially.
    COMMENT THIS FONT IS PROVIDED "AS IS" WITHOUT WARRANTY.
    FONT -mplus-fxd-medium-R-normal--10-100-75-75-C-60-iso8859-1
    SIZE 10 75 75
    FONTBOUNDINGBOX 6 13 0 -4
    STARTPROPERTIES 20
    FONTNAME_REGISTRY ""
    FOUNDRY "mplus"
    FAMILY_NAME "fxd"
    WEIGHT_NAME "medium"
    SLANT "R"
    SETWIDTH_NAME "normal"
    ADD_STYLE_NAME ""
    PIXEL_SIZE 10
    POINT_SIZE 100
    RESOLUTION_X 75
    RESOLUTION_Y 75
    SPACING "C"
    AVERAGE_WIDTH 60
    CHARSET_REGISTRY "iso8859"
    CHARSET_ENCODING "1"
    COPYRIGHT "Copyright (C) 2002-2004 COZ"
    DEFAULT_CHAR 0
    FONT_DESCENT 4
    FONT_ASCENT 9
    _XMBDFED_INFO "Edited with xmbdfed 4.5."
    ENDPROPERTIES
    CHARS 224

# 5. BCFファイルをPCF.GZに圧縮する

BCFファイルをPCFに変換し、gunzipで圧縮してPCF.GZファイルにする。

    bdftopcf umplus_j10r.bdf | gzip > umplus_j10r.pcf.gz
    bdftopcf umplus_j12r.bdf | gzip > umplus_j12r.pcf.gz

あとはこのフォントをインストールしてやれば完了。

# 私家版debパッケージ

手順が面倒なので、umplus_j12r.pcf.gzとumplus_j10r.pcf.gzをdebianパッケージ化してみた。

- [xfonts-umplus.deb](https://github.com/xmisao/xfonts-umplus/raw/master/xfonts-umplus.deb)

インストールすると/usr/share/fonts/X11/misc以下に両ファイルを展開する。
debianパッケージの作成方法は以下のエントリを参考にした。

- [お手軽 deb パッケージ作成方法](http://d.hatena.ne.jp/conceal-rs/20090518/1242643016)

フォントのインストールについては[Linuxでフォントを追加する方法](http://www.xmisao.com/2013/08/17/how-to-add-fonts-on-linux.html)を参照。
