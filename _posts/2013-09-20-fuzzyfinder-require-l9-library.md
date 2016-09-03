---
layout: blog
title: FuzzyFinder 4.0以降の動作にはL9というライブラリも必要
tag: vim
---



最新の[FuzzyFinder](http://www.vim.org/scripts/script.php?script_id=1984)インストールしたら、以下のエラーが出るようになってしまった。

~~~~
Error detected while processing /home/xmisao/.vim/bundle/FuzzyFinder/plugin/fuf.vim:
line   13:
***** L9 library must be installed! *****
Press ENTER or type command to continue
~~~~

親切なエラーメッセージが出ているが、あまりvimプラグインでライブラリという概念に馴染みがないのでL9って何?となった。

[L9](http://www.vim.org/scripts/script.php?script_id=3252)とはvimプログラミングに便利な関数とコマンドを提供するライブラリなのだそうな。しかも使い方はソースを読めときていて、実体がつかめない。

> INTRODUCTION  
> l9 is a Vim-script library, which provides some utility functions and commands for programming in Vim.  
> 
> USAGE  
> See source code. 

ざっとL9のソースを確認したところ、配列の操作やファイル入出力など、vimプラグイン開発のための関数やコマンドの詰め合わせのようだ。

ともかく、このL9ライブラリをインストールしてやると、晴れてFuzzyFinderが動作するようになった。

Vundleはかなり良い線を行っているが、それでもなおvimプラグインの管理は貧弱なので、あまり他のプラグインに依存する作りにして欲しくないなあというのが正直なところ。
