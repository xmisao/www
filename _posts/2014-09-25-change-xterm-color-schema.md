---
layout: blog
title: xtermの配色を変更する
tag: ['linux', 'xterm']
---

# xtermの配色を変更する

xtermの配色はX Window Systemのリソース設定(X resources)で変更する。

例えば以下のリソース設定を読みこませるとxtermの配色はスクリーンショットのようになる。
なお配色テストには`colortest-16b`コマンドが便利である。
debianであればaptから`colortest`パッケージでインストールできる。

~~~~
*background: #292929
*foreground: #ffffff
*color0: #404040
*color1: #CE5666
*color2: #80A673
*color3: #E0BC93
*color4: #778BAF
*color5: #94738C
*color6: #B5D2DD
*color7: #d2d2d2
*color8: #505050
*color9: #952743
*color10: #97D599
*color11: #FFCAA2
*color12: #5A667F
*color13: #D8ADCE
*color14: #82A9CC
*color15: #ffffff
~~~~

![colortest-16b]({{ site.url }}/assets/2014_09_25_colortest.png)

リソース設定は一般的には`~/.Xdefaults`に記述し、Xアプリケーションに読み込ませる。
別の方法として`xrdb`コマンドでリソース設定ファイルの内容をルートウィンドウに反映することもできる。
この場合は慣例としてファイルは`~/.Xresources`にすることが多い。

~~~~
xrdb -merge ./.Xresources
~~~~
