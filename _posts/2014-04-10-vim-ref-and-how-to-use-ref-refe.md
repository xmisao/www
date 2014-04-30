---
layout: blog
title: vim-refとReFeでRubyのリファレンスマニュアルをvimで読む
tag: ['vim', 'ruby']
---

# vim-refとReFeでRubyのリファレンスマニュアルをvimで読む

[前のエントリ](http://www.xmisao.com/2014/04/10/ruby-refe-install.html)では、ReFeを使うとコマンドラインでRubyのリファレンスマニュアルを読めることを説明した。しかし、ReFeの真髄はエディタとの連携にある。

[vim-ref](https://github.com/thinca/vim-ref)はリファレンスマニュアルをvim上で読むためのvimプラグインである。これはReFeにも対応しており、Rubyのソースコードからリファレンスを参照するようなことが簡単にできる。

## インストール

[Vundle](http://www.xmisao.com/2013/08/22/vundle.html)を使っていれば以下を`.vimrc`に記載して、`BundleInstall`でインストールできる。

~~~~
Bundle 'thinca/vim-ref'
~~~~

## 使い方

vim-refをインストールするとリファレンスを検索する`Ref`コマンドが使えるようになる。`Ref`コマンドの使い方は以下のとおり。オプションとクエリは省略可能である。

~~~~
Ref オプション ソース クエリ
~~~~

例えばReFeで`Array#join`のリファレンスを表示するには以下のようにすれば良い。

~~~~
Ref refe Array#join
~~~~

vim-refではあらゆるバッファで有効なキーマップとして`K`が定義されている。
これは非常に便利で、例えば`.rb`ファイルで`Array.new`にカーソルを合わせて`K`を押下すると、`Array.new`のリファレンスが開く。

- `K` -- カーソル下のキーワードにジャンプ

ref-viewerの内部では`K`に加えて以下のキーマップが利用できる。
ようは`K`や`Enter`キーで読み進めて、`<C-t>`か`<C-o>`で戻ることができる。

- `Enter` -- カーソル下のキーワードにジャンプ
- ダブルクリック -- 同上
- `<C-j>` -- 同上
- `<C-t>` -- 前のページに戻る
- `<C-o>` -- 同上
- `<C-i>` -- 次のページに進む

またref-viewerでは、`RefHistory`コマンドを使って履歴を確認することが可能だ。