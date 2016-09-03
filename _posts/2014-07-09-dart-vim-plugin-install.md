---
layout: blog
title: VimのDartプラグイン
tag: ['vim', 'dart']
---



VimでDartを編集するためのプラグインとして[Dart plugin for VIM](https://github.com/dart-lang/dart-vim-plugin)がある。

Vundleを使っているなら以下を`.vimrc`に記述して、`BundleInstall`でインストールできる。

~~~~
Bundle 'dart-lang/dart-vim-plugin'
~~~~

ソースを見るとftdetectで`*.dart`なファイルを開いた時にFileTypeが`dart`になるコードが入っているのだが、手元の環境では何故かこれが有効にならなかった。

仕方ないので`.vimrc`に以下を記述してお茶を濁す。

~~~~
" for dart
au BufNewFile,BufRead *.dart :set filetype=dart
~~~~

このプラグインができることは実質シンタックスハイライトだけだが、無いよりマシ。
