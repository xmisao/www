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
*color0: #333333
*color1: #A94952
*color2: #83A949
*color3: #A99F49
*color4: #4983A9
*color5: #A94983
*color6: #49A99F
*color7: #AAAAAA
*color8: #666666
*color9: #ED6975
*color10: #B8ED69
*color11: #EDE169
*color12: #69B8ED
*color13: #ED69B8
*color14: #69EDE1
*color15: #CCCCCC
~~~~

![colortest-16b]({{ site.url }}/assets/2014_09_25_colortest.png)

リソース設定は一般的には`~/.Xdefaults`に記述し、Xアプリケーションに読み込ませる。
別の方法として`xrdb`コマンドでリソース設定ファイルの内容をルートウィンドウに反映することもできる。
この場合は慣例としてファイルは`~/.Xresources`にすることが多い。

~~~~
xrdb -merge ./.Xresources
~~~~
