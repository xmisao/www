---
layout: blog
title: VimでGitを使うならfugitiveを使おう
tag: vim
---



VimでGitを使う時、いちいち!gitしていたが、さすがに億劫になったので[fugitive](https://github.com/tpope/vim-fugitive)を入れてみた。

# インストール

Vimのプラグインを管理するプラグイン「Vundle」が入っていない場合は、これを機にVundleも導入しよう。

[Vundleでvimプラグインを管理する](http://www.xmisao.com/2013/08/22/vundle.html)

.vimrcに以下を追加して、BundleInstallを実行すればインストールされる。

    Bundle "tpope/vim-fugitive"

# 使い方

fugitiveを入れてリポジトリ内のファイルを編集すると、Gから始まる各種コマンドが使えるようになる。

例えば編集中のファイルをpushする以下の一連の操作はこんな感じ。

|コマンド|fugitiveコマンド|
|:-|:-|
|git add %|Gwrite|
|git commit -m "hoge"|Gcommit -m "hoge"|
|git push origin master|Git push origin master|
{: .table .table-striped}

まだ全然使いこなせていないが、これだけでも非常に便利。
