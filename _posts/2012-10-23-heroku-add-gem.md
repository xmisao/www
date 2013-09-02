---
layout: blog
title: Herokuでのgem追加方法
---

# Herokuでのgem追加方法

Gemfileにパッケージを記入する。

以下のコマンドでGemfile.lockを更新する。

    bundler update

GemfileとGemfile.lockの両方をコミットしてpushする。
エラーがでなければok。

なおbundlerは

    gem install bundle

でインストールできる。
