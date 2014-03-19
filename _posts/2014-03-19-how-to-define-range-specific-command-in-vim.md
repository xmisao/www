---
layout: blog
title: vimで範囲指定できるコマンドを定義する方法
tag: vim
---

# vimで範囲指定できるコマンドを定義する方法

vimで範囲指定できるコマンドを定義するには以下のようにする。

~~~~
" 範囲を受け取る関数の定義
function! PrintRange() range
    echo "firstline: " . a:firstline
    echo "lastline: " . a:lastline
endfunction

" 範囲指定できるコマンドの定義
command! -range PrintRange <line1>,<line2>call PrintRange()
~~~~

この例では、範囲の最初の行と最後の行を出力する関数`PrintRange()`と、その関数を実行するコマンド`PrintRange`を定義している。

ポイントは3つある。

1つ目は呼び出し先の関数に`range`指定をつけること。これにより、関数から選択範囲の先頭と末尾の行数を格納した変数`a:firstline`と`a:lastline`にアクセスできるようになる。また、この関数は`:1,10call PrintRange()`の形で範囲指定して呼び出した際に、範囲全体に対して1度だけ実行されるようになる。

2つ目は`command!`に属性`-range`を付加すること。これにより、このコマンドは範囲指定して実行できるようになる。もしこの指定がないと、コマンドは範囲指定して実行した場合、no range allowedで失敗してしまう。

3つ目は`command!`で`<line1>,<line2>call`で関数を呼び出すこと。`<line1>`と`<line2>`はそれぞれ範囲の最初の行、最後の行に置き換えられる。結果として、この呼び出し方によって、コマンドに渡された範囲を関数に受け渡すことができる。
