---
layout: blog
title: vimプラグインneocompleteの導入とRuby向けの設定メモ
tag: ['vim', 'ruby']
---

# vimプラグインneocompleteの導入とRuby向けの設定メモ

自動的な入力補完を行ってくれる超絶便利なvimプラグインとして[neocomplete](https://github.com/Shougo/neocomplete.vim)がある。

## インストール

[Vundle](http://www.xmisao.com/2013/08/22/vundle.html)を使っていれば以下を`.vimrc`に記載して、`BundleInstall`でインストールできる。

~~~~
Bundle "Shougo/neocomplete.vim"
~~~~

### 設定

`.vimrc`に以下の設定をする。

デフォルトでneocompleteを有効にするため、以下の1行を追加する。

~~~~
let g:neocomplete#enable_at_startup = 1
~~~~

またRubyスクリプトの編集中は`.`等を押下したタイミングでvimのオムニ補完を効かせたいので、以下の設定をする。

~~~~
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
~~~~
