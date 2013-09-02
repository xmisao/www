---
layout: blog
title: jekyllで日本語を含むファイルの変換がYAML Exceptionで失敗する
tag: jekyll
---

# jekyllで日本語を含むファイルの変換がYAML Exceptionで失敗する

jekyllを実行したら以下のようなエラーが出て失敗した。

    YAML Exception reading example.md: invalid byte sequence in US-ASCII

以下のようにLC_CTYPEとLANGを日本語に設定したらエラーは発生しなくなった。

    LC_CTYPE=ja_JP.utf8 LANG=ja_jp.utf8 jekyll
