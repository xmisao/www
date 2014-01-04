---
layout: blog
title: TTFをEOTに変換するttf2eotをLinuxでビルドするメモ
tag: ['linux', 'fonts']
---

# TTFをEOTに変換するttf2eotをLinuxでビルドするメモ

[ttf2eot](http://code.google.com/p/ttf2eot/)はTTF形式のフォントをEOT形式に変換するツールだ。このツールのDebian Wheezyでのビルド方法をメモする。なおWindows版は実行可能バイナリが提供されている模様。

ソースコードはLatest Versionとされるものがダウンロードできるが、ここはせっかくなのでリポジトリからチェックアウトする。

~~~~
svn checkout http://ttf2eot.googlecode.com/svn/trunk/ ttf2eot
~~~~

だが、このまま`make`してもなんやかんや言われてビルドが通らない。(gccのバージョンに依る?)少なくともDebian Wheezyではダメであった。
これは[issue 22](http://code.google.com/p/ttf2eot/issues/detail?id=22)と[issue 25](http://code.google.com/p/ttf2eot/issues/detail?id=25)で報告されている。

ビルドを成功させるパッチ`cstddef.patch`がissue 22で公開されているのでこれを適用する。このパッチは1行だ。

~~~~
patch OpenTypeUtilities.cpp < cstddef.patch
~~~~

あとは`make`するだけである。
これで実行可能ファイル`ttf2eot`ができる。

~~~~
make
~~~~

なお`ttf2eot`の使い方は以下のとおり。
TTFフォントを指定してやるとEOTフォントに変換して標準出力するのでリダイレクトしてやる。

~~~~
ttf2eot something.ttf > something.eot
~~~~
