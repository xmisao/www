---
layout: blog
title: はじめてのVimスクリプト
tag: vim
---

# はじめてのVimスクリプト

## はじめに

はじめてVimスクリプトを書く人に向けたVimスクリプトの書き方のメモ。

## ドキュメントで読むべき箇所

以下で紹介する2ページは絶対に押さえておいたほうが良い。

- [Vim documentation: eval](http://vim-jp.org/vimdoc-ja/eval.html)

何か困ったらまずはこのページを読むべきである。
Vimスクリプトの基本と関数やコマンドの一覧が掲載されている。

- [Vim documentation: vimindex](http://vim-jp.org/vimdoc-ja/vimindex.html)

Vimの全コマンドが掲載されている。
Vimスクリプトは本質的にコマンドの塊に他ならない。
適宜参考にすべきだろう。

これらのページは、元がデキストだけあって非常に読みにくいので、覚悟して読むこと。

なおそれぞれ`:help eval.txt`と`:help vimindex.txt`でVim上でも読むことができる。

また調べ物は以下のようにググると幸せになれるかも知れない。

~~~~
site:vim-jp.org hogehoge
~~~~

## おすすめのプラグイン

- [QuickRun](https://github.com/thinca/vim-quickrun)

定番である。
便利なので入れておくと捗る。

QuickRunはバッファの内容を実行して、出力結果を別のバッファに書き出してくれるプラグインだ。
範囲指定で実行することもでき、ビジュアルモードで選択した部分が実行できるのは非常に便利である。
試行錯誤にうってつけだ。

Vimスクリプトの実行は`:QuickRun vim`でできる。

## Hello, World!

いわゆるHello, World!を作ってみよう。

### スクリプトファイルの作成

まず`hello.vim`などとして適当にVimスクリプトファイルを作る。
Vimスクリプトの拡張子は`.vim`である。

### スクリプトファイルの編集

Vimスクリプトでメッセージを表示するには`echo`コマンドを使う。
文字列リテラルは`"`または`'`で囲む。
よって`Hello, World!`を表示するコードは以下である。

~~~~
echo 'Hello, World!'
~~~~

### スクリプトファイルの実行

Vimスクリプトは`:source`でvimに実行させることができる。
`hello.vim`を実行させるには以下のようにする。

~~~~
:source hello.vim
~~~~

編集中のVimスクリプトを実行したいなら以下でも良い。

~~~~
:source %
~~~~

## echomと:messageによるprintfデバッグ

いわゆるprintfデバッグの方法を紹介する。

Vimスクリプトでは基本的に`echo`すればprintfデバッグが可能だ。
`echo`はあらゆる式を評価して文字にして表示してくれる。
(配列や辞書も`echo`で表示可能である)

だが、ある程度複雑な事をするようになってくると、`echo`ではメッセージが流れて見えなくなってしまう場面が少なくない。

そのような場合には`echo`の代わりに`echom`を使うと良い。

`echom`は画面にメッセージを出力するとともに、メッセージ履歴にもメッセージを残すコマンドである。

メッセージ履歴はあとから`:messages`で参照することができる。

## おわりに

以上、Vimスクリプトを書き始める人に向けて、役立ちそうなことをまとめた。

私も[RubyJump](https://github.com/xmisao/rubyjump.vim/blob/master/README.ja.md)を作り始める前に知っておきたかった…orz
