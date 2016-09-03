---
layout: blog
title: コマンドを実行した結果の終了コードを確認する方法(Windows/Linux)
tag: shell
---



コマンドを実行した結果の終了コードをシェルで確認する方法。
複数のプラットフォームを行き来しているとふらふらしてくる。

Windowsの場合は以下。

~~~~
somecommand
echo %ERRORLEVEL%
~~~~

Linuxの場合は以下。

~~~~
somecommand
echo $?
~~~~

Linuxはまだしも、Windowsの方は少し覚えることが多い。
