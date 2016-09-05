---
layout: blog
title: Debian/Ubuntuでデフォルトのターミナルエミュレータを変更する
tag: debian
---



rootで以下を実行するとデフォルトのターミナルエミュレータを変更できる。

~~~~
update-alternatives --config x-terminal-emulator
~~~~

新しいデスクトップ環境をインストールした時などにデフォルトのターミナルエミュレータが変更されてしまうことがある。
そのような場合にお気に入りのターミナルエミュレータを再設定するのに使用する。
