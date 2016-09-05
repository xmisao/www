---
layout: blog
title: Linuxでスクリーンショットを撮るならShutterを使ってみよう
tag: linux
---



shutterはWindowsでいうSnipping Toolを強化したようなLinux用のスクリーンショットツールである。DebianやUbuntuであればaptからインストールできる。perl製のリッチなツールなので依存するパッケージがぼこぼこ入る。

~~~~
apt-get install shutter
~~~~

shutterを起動すると以下のような画面が表示される。スクリーンショットは、範囲選択(Selection)、デスクトップ全体(Desktop)、ウィンドウ(Window)の3種類の方法で撮ることができる。試しに範囲選択でスクリーンショットを撮ってみよう。

![Shutter 1]({{ site.url }}/assets/2014_02_07_shutter_1.jpg)

範囲選択でスクリーンショットを撮ろうとすると、画面が暗くなりマウスでキャプチャする範囲をドラッグすることを促すヘルプが表示される。この際にshutterの画面は消えるので、shutterの画面が邪魔になることはない。Escキーを押下すると範囲選択をキャンセルできる。

![Shutter 2]({{ site.url }}/assets/2014_02_07_shutter_3.jpg)

ドラッグした範囲は明るく表示される。範囲は端をドラッグするか、カーソルキーを押下することで微調整が可能だ。Enterキーで範囲を確定して、スクリーンショットが撮れる。

![Shutter 3]({{ site.url }}/assets/2014_02_07_shutter_2.jpg)

撮ったスクリーンショットはshutterのウィンドウに表示される。ここからEditで簡単な編集を行ったり、画像を保存したり、ExportでWebに画像をアップロードすることができる。

![Shutter 4]({{ site.url }}/assets/2014_02_07_shutter_4.jpg)

shutterはシステムトレイに常駐するため、システムトレイからスクリーンショットを撮ることも可能だ。対応したデスクトップ環境なら、スクリーンショットを撮るショートカットキーを設定することもできる。

またshutterは、マルチディスプレイ環境や、複数のワークスペースを持つウィンドウマネージャにも対応しており、全体として非常にしっかりとしたツールという印象を受ける。

Linuxでスクリーンショットを撮るには`xwd`や`import`を使った[古典的な方法](http://www.xmisao.com/2013/09/17/linux-xwindow-screenshot.html)も便利だが、大量にスクリーンショットを撮りたい場合などに、shutterは重宝するはずだ。Linuxを使う上でぜひ押さえておきたいツールである。
