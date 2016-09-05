---
layout: blog
title: Vimスクリプトでスクリプトのディレクトリを取得する
tag: vim
---



実行中のVimスクリプト自体のパスを取得するには`expand`を使って以下のようにする。
`<sfile>`は取り込まれたファイルのファイル名を示す文字列である。
また`:p`はフルパス名に変換することを指定する文字列である。

注意点として、この呼び出しはスクリプトファイルの直下で行うこと。
関数内では関数名が返却されてしまい期待どおりにパスが得られない。

~~~~
let s:script_path = expand('<sfile>:p') "=> /home/xmisao/.vim/plugin/script_path.vim
~~~~

スクリプトが存在するディレクトリを取得したい場合は`:h`を併用すると良い。

~~~~
let s:script_dir = expand('<sfile>:p:h') "=> /home/xmisao/.vim/plugin
~~~~

# 応用

if_rubyにおいてVimスクリプトからの相対パスでRubyスクリプトをロードすることも簡単に行える。

~~~~
let s:script_dir = expand('<sfile>:p:h')

ruby <<RUBY
  require "#{VIM::evaluate('s:script_dir')}/foo/bar.rb"
RUBY
~~~~
