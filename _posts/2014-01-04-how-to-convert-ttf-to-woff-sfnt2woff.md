---
layout: blog
title: TTF/OTFのフォントをWOFFに変換するツールsfnt2woff
tag: fonts
---



- [WOFF FONTS!](http://people.mozilla.org/~jkew/woff/)

`sfnt2woff`はTrueType / OpenTypeのフォントをWOFF形式に変換するツールだ。WOFF形式はTrueType / OpenTypeと異なり圧縮が効くのでファイルサイズの面でメリットがある。`sfnt2woff`を使えば手持ちのフォントを簡単に軽量なWebフォントに変換することができる。

`sfnt2woff`はWindowsとMacOS X向けにはコンパイル済みバージョンが提供されている。今回はLinux上で使用したいので、ソースからビルドすることにする。ソースは以下のリンクから入手できる。

- [woff-code-latest.zip](http://people.mozilla.org/~jkew/woff/woff-code-latest.zip)

ビルドは簡単で、ソースコードを展開して、単にmakeするだけだ。これで`sfnt2woff`と、逆に変換を行う`woff2sfnt`ができる。

~~~~
unzip woff-code-latest.zip -d sfnt2woff
cd sfnt2woff
make
~~~~

`sfnt2woff`はフォントを指定してやると、フォントが存在するディレクトリに、WOFF形式に変換したフォントを出力する。以下の例ではカレントディレクトリに`something.woff`が生成される。

~~~~
sfnt2woff something.ttf
~~~~
