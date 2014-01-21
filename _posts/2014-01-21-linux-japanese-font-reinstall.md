---
layout: blog
title: Debianで日本語フォントが化けるようになった時の対処療法
tag: ['linux', 'debian']
---

# Debianで日本語フォントが化けるようになった時の対処療法

何かのはずみで日本語フォントが文字化けするようになってしまった。
Debianを使っているとたまにそんなこともある。

完全に経験則で対処療法なのだが、このような場合は、何らかの日本語フォントをインストールしてやると直る事がある。
新しいフォントを入れるのが嫌なら、例えば`fonts-vlgothic`パッケージあたりを再インストールしてやれば良い。

~~~~
apt-get remove fonts-vlgothic
apt-get install fonts-vlgothic
~~~~

このエントリーが誰かの役に立つことを祈る。
