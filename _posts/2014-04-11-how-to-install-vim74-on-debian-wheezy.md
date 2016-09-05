---
layout: blog
title: Debian WheezyにVim 7.4をインストールする
tag: ['linux', 'vim']
---



Debian WheezyのVimは7.3なので、neocompleteが動作しなくて血を吐いた。
至急、Debian WheezyにVim 7.4をインストールする必要がある。

~~~~
neocomplete does not work this version of Vim.
It requires Vim 7.3.885 or above and "if_lua" enabled Vim.
~~~~

以下の手順でソースコードを取得して、ビルドしてインストールした。
依存するライブラリなどは`apt-get build-dep vim`でインストールしてしまった。
いわゆる`gvim`が使いたいのと、neocompleteがluaを要求するので、`configure`はこんな感じにした。
これで`/usr/local`以下にvimがインストールされるので、パスが通っていれば普通に使えるようになる。

~~~~
$ hg clone https://vim.googlecode.com/hg/ vim
$ cd vim
$ make distclean
# apt-get build-dep vim
$ ./configure --with-gnome --with-features=huge --enable-pythoninterp --enable-rubyinterp --enable-luainterp
$ make
# make install
~~~~

別の方法として、公式のソースコードではなくDebian Jessie以降のソースパッケージを使う方法も考えられるが、そちらは試していない。

参考

- [How To Install Vim 7.4 On Debian Based Systems (From Source)](http://linuxg.net/how-to-install-vim-7-4-on-debian-based-systems-from-source/)
