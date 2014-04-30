---
layout: blog
title: vimで\*.mdのMarkdownを編集する際のfiletype設定
tag: vim
---

# vimで\*.mdのMarkdownを編集する際のfiletype設定

最近のvimはデフォルトでmarkdownのシンタックスハイライトが可能になっているが、一般的にmarkdownの拡張子で使われる`*.md`はmodula2のfiletypeと認識されて、読み込んでも正しくシンタックスハイライトが行われない。

これを解決するためには、`*.md`のファイルを読み込んだ際に、filetypeを設定する`autocmd`を`.vimrc`に書いてやれば良い。一例としては以下である。

~~~~
au BufNewFile,BufRead *.md :set filetype=markdown
~~~~

なお`set filetype=`の代わりに`setf`(`setfiletype`)を使ってはいけない。これらはfiletypeが設定されていない時だけ有効で、既に設定されたfiletypeを変更することはできない。
