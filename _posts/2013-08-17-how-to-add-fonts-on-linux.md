---
layout: default
title: Linuxでフォントを追加する方法
tag: linux
---

# Linuxでフォントを追加する方法

Linuxでシステムに新しいフォントを追加する手順をまとめた。
以下の4ステップで新しいフォントを確実に認識させられる。

1. /usr/share/fonts/X11の適切なディレクトリにフォントをコピーする。
2. rootで mkfontdir コピー先のディレクトリ を実行してインデックスを更新する。
3. rootで fc-cache -vf を実行してフォントキャッシュを更新する。
4. xset fp rehash を実行してフォントパスを再読み込みさせる。
