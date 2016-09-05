---
layout: blog
title: AwesomeでJavaのGUIプログラムが上手く動作しない場合の対処法
tag: linux
---



タイル型ウィンドウマネージャ[Awesome](http://awesome.naquadah.org/)を使っていてJavaのGUIを使ったプログラムがうまく動作しない現象に遭遇した。
特にエラー等は出ないのだが、メニューがクリックできなかったり、ともかく挙動がおかしい。
いろいろ調べたところ、AwesomeではXのルートウィンドウのウィンドウマネージャ名というプロパティが設定されていないのが原因らしい。

[wmname](http://tools.suckless.org/wmname)はXのルートウィンドウのウィンドウマネージャ名を表示・設定できる小さなプログラムだ。
以下の手順でダウンロード、ビルドし、ウィンドウマネージャ名を`LG3D`と設定すると、AwesoemでもJavaのGUIを使ったプログラムが正しく動作するようになった。

~~~~
git clone http://git.suckless.org/wmname
cd wmname
make
./wmname LG3D
~~~~
