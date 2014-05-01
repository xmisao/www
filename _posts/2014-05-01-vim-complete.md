---
layout: blog
title: vimで独自の補完を設定する(complete関数の使い方)
tag: vim
---

# vimで独自の補完を設定する(complete関数の使い方)

vimで独自の補完を実行するには、`complete`関数を使用する。
`complete`関数は第1引数に単語の開始位置を示す行内のバイトオフセット(通常は`col('.')`でカーソル位置を指定する)、第2引数で候補のリストを指定する。
リストの要素は文字列か所定のキーを持つハッシュである。

![vim complete 1]({{ site.url }}/assets/2014_05_01_vim_complete_1.png)

以下は最も単純な文字列のリストを指定して`complete`関数を使った例である。
この形式では、候補に表示されるテキストと実際に挿入されるテキストは同様で、追加情報などはない。

注意点として`complete`関数はインサートモードでしか動作しない。このため以下の例では動作確認用に、インサートモードでF5を押下した際に、`<C-R>=`を使って式を評価することで、補完関数を呼び出すマップを定義している。

~~~~
inoremap <F5> <C-R>=MyCmpl()<CR>
func! MyCmpl()
  call complete(col('.'), ['foo', 'bar', 'baz'])
  return ''
endfunc
~~~~

次の例は文字列のリストの代わりにハッシュのリストを使った例である。`word`はハッシュを使う場合の必須のキーで、挿入されるテキストを指定するものである。

~~~~
inoremap <F5> <C-R>=MyCmpl()<CR>
func! MyCmpl()
  call complete(col('.'), [
    \ {'word': 'foo'},
    \ {'word': 'bar'},
    \ {'word': 'baz'}])
  return ''
endfunc
~~~~

`word`以外にも、`complete`関数は下表のキーを解釈して様々な挙動をする。以降では補完を設定する上で特に重要と思われる`abbr`、`menu`、`info`についてスクリーンショットを交えて紹介する。

|キー|意味|
|:-|:-|
|word|挿入されるテキスト。必須|
|abbr|"word" の略。これが空でなければ、メニューで "word" の代わりに表示される。|
|menu|ポップアップメニューにおける追加情報。"word" または"abbr" の後に表示される。|
|info|この要素についての追加情報。プレビューウィンドウに表示することができる。|
|kind|候補の種類を表す1文字|
|icase|0 でないならば、候補同士を比較するとき大文字小文字は無視される。省略された場合は 0 となり、大文字小文字の違いしかない候補も追加される。|
|dup|0 でないならば、すでに同じ候補があってもこの候補を追加する。|
|empty|0 でないならば、空文字であってもこの候補を追加する。|
{: .table .table-striped}

![vim complete 2]({{ site.url }}/assets/2014_05_01_vim_complete_2.png)

上記の例に追加で`abbr`を定義した。`abbr`は`word`の代わりに補完候補のポップアップに表示される文字列である。これを使ってポップアップに表示される文字列を自在に変更することができる。

~~~~
inoremap <F5> <C-R>=MyCmpl()<CR>
func! MyCmpl()
  call complete(col('.'), [
    \ {'word': 'foo', 'abbr': '1: foo'},
    \ {'word': 'bar', 'abbr': '2: bar'},
    \ {'word': 'baz', 'abbr': '3: baz'}])
  return ''
endfunc
~~~~

![vim complete 3]({{ site.url }}/assets/2014_05_01_vim_complete_3.png)

更に`menu`を定義した。`menu`は候補の末尾に表示される追加情報である。以下の例では`1:foo`に対して`hoge`を、`2:bar`に対して`piyo`を、`3:baz`に対して`fuga`を、それぞれ追加情報として表示する。

~~~~
inoremap <F5> <C-R>=MyCmpl()<CR>
func! MyCmpl()
  call complete(col('.'), [
    \ {'word': 'foo', 'abbr': '1: foo', 'menu': 'hoge'},
    \ {'word': 'bar', 'abbr': '2: bar', 'menu': 'piyo'},
    \ {'word': 'baz', 'abbr': '3: baz', 'menu': 'fuga'}])
  return ''
endfunc
~~~~

![vim complete 4]({{ site.url }}/assets/2014_05_01_vim_complete_4.png)

`info`はプレビューウィンドウに表示する内容を指定するキーである。このキーが指定されると、スクリーンショットにあるように、候補を選択している最中にプレビューウィンドウが表示されるようになる。

~~~~
inoremap <F6> <C-R>=MyCmpl()<CR>
func! MyCmpl()
  call complete(col('.'), [
    \ {'word': 'foo', 'abbr': '1: foo', 'menu': 'hoge', 'info': 'FOO - HOGE'},
    \ {'word': 'bar', 'abbr': '2: bar', 'menu': 'piyo', 'info': 'BAR - PIYO'},
    \ {'word': 'baz', 'abbr': '3: baz', 'menu': 'fuga', 'info': 'BAZ - FUGA'}])
  return ''
endfunc
~~~~

以上、`complete`関数の使い方と、主なオプションを紹介した。これだけでも簡単なプラグインを作ることができそうだ。

参考

- [Vim documentation: eval complete](http://vim-jp.org/vimdoc-ja/eval.html#complete%28%29)
