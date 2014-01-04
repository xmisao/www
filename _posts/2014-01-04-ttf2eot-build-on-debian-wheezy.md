---
layout: blog
title: TTFをEOTに変換するttf2eotをLinuxでビルドするメモ
tag: ['linux', 'fonts']
---

# TTFをEOTに変換するttf2eotをLinuxでビルドするメモ

[ttf2eot](http://code.google.com/p/ttf2eot/)はTTF形式のフォントをEOT形式に変換するツールだ。このツールのDebian Wheezyでのビルド方法をメモする。

ソースコードはLatest Versionとされるものがダウンロードできるが、ここはせっかくなのでリポジトリからチェックアウトする。

~~~~
svn checkout http://ttf2eot.googlecode.com/svn/trunk/ ttf2eot-read-only
~~~~

だが、このまま`make`してもなんやかんや言われてビルドが通らない。(gccのバージョンに依る?)
これは[issue 22](http://code.google.com/p/ttf2eot/issues/detail?id=22)と[issue 25](http://code.google.com/p/ttf2eot/issues/detail?id=25)で報告されている。

ビルドを成功させるパッチがissue 22で公開されているのでこれを適用する。

- [cstddef.patch](http://ttf2eot.googlecode.com/issues/attachment?aid=220001000&name=cstddef.patch&token=TSd6ArovvMoCNQJjD3ejAhDn1nY%3A1388795866574)

~~~~
patch -c OpenTypeUtilities.cpp < cstddef.patch
~~~~

あとは`make`するだけである。
これで`ttf2eot`ができる。

~~~~
make
~~~~

なお`ttf2eot`の使い方は以下のとおり。
TTFフォントを指定してやるとEOTフォントに変換して標準出力するのでリダイレクトしてやる。

~~~~
ttf2eot something.ttf > something.eot
~~~~
