---
layout: blog
title: vimのcompletefuncの仕様についてのメモ
tag: vim
---

# vimのcompletefuncの仕様についてのメモ

## ユーザ補完とcompletfunc

vimでは__\<C-x>\<C-u>__でユーザ補完を呼び出すことができる。
ユーザ補完は変数`completefunc`で指定された関数を使って行われる。
あるきまりに従って補完用の関数を作って`completefunc`に指定してやることで、vimで独自の補完を定義することができる。

`completefunc`の関数はユーザ補完が開始されたタイミングで__2回__呼ばれる。
この呼び出しはそれぞれ異なった役割を持ち、関数は別の値を返すことが期待される。
これがポイントであり、補完の関数の理解を難しくしている原因である。

2回の呼び出しとは以下である。

1. 補完するテキストの始点の桁番号を返すことを期待した呼び出し
2. 補完するテキストの候補を返すことを期待した呼び出し

`completefunc`の関数は2つの引数`findstart`と`base`を取り、どちらの呼び出しかで渡される引数が異なる。
*1.*の呼び出しでは、`findstart`が1で、`base`がemptyである。
*2.*の呼び出しでは、`findstart`が0で、`base`には補完するテキストの始点からカーソル位置までの文字列が入る。

## completefuncの例

これを踏まえて、vimのドキュメントから月の名前を補完する補完関数の例を見てみよう。

~~~~
fun! CompleteMonths(findstart, base)
  if a:findstart
    " 単語の始点を検索する
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] =~ '\a'
      let start -= 1
    endwhile
    return start
  else
    " "a:base" にマッチする月を探す
    let res = []
    for m in split("Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec")
      if m =~ '^' . a:base
        call add(res, m)
      endif
    endfor
    return res
  endif
endfun
set completefunc=CompleteMonths
~~~~

## 補完するテキストの始点の桁番号を期待した呼び出し

まずこの関数は、`a:firstline`を見て、1回目の呼び出しか2回目の呼び出しかを判定して、別の処理を行う。
`if a:firstline`が真になる1回目の呼び出しでは、単語の始点を検索して桁番号を返す。
具体的にははじめに`getline(.)`でカーソルのある行の文字列を取得する。
続いて`col('.') - 1`で、カーソル位置の直前を単語のはじまりだと仮定する。
次の`while`ループでは、単語のはじまりの文字がパターン`\a`にマッチしている間、単語のはじまりを前にずらしてゆくことで、本当の単語のはじまりを特定する。
なお`\a`は`isfile`変数で指定されたファイル名の構成文字であり、一般的にはスペースは含まれない。

このため\[\]をカーソル位置として以下の行で`CompleteMonths`が呼び出されると、barのはじまりの桁番号である`4`がこの関数の返り値となる。

~~~~
foo bar[] baz
~~~~

## 補完するテキストの候補を返すことを期待した呼び出し

続いて2回目の呼び出しでは、`if a:firstline`は偽となる。
こちらは前述の呼び出しよりいくらか見通しが良い。
`a:base`には補完を開始する単語のはじまりからカーソル位置までの文字列が格納されている。
この値を使って候補の絞り込みを行う。
今回は月の名前を補完する例のため`for m in split("Jan..."`で月の名前の配列を用意する。
この要素を`a:base`とマッチさせて、マッチする要素だけを残した配列を作り、これを返す。
これがそのまま補完の候補である。

例えば`a:base`が`M`なら、`Mar`と`May`のみを要素として持つ配列が返り値となる。
なお返すのは文字列の配列ではなく、ハッシュの配列でも構わない。
有効なハッシュの形式は[vimで独自の補完を設定する(complete関数の使い方)](http://www.xmisao.com/2014/05/01/vim-complete.html)で紹介した`complete`関数の第2引数と同様である。

参考

- [Vim documentation: insert#complete-functions](http://vim-jp.org/vimdoc-ja/insert.html#complete-functions)
