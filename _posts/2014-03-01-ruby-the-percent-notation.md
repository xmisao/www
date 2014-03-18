---
layout: blog
title: Rubyの%記法について
tag: ruby
---

# Rubyの%記法について

Rubyの%記法には以下の種類がある。

|%記法|意味|
|:-|:-|
|%!   |ダブルクォート文字列|
|%Q   |同上|
|%q   |シングルクォート文字列|
|%x   |コマンド出力|
|%r   |正規表現|
|%w   |要素が文字列の配列(空白区切り)|
|%W   |要素が文字列の配列(空白区切り)。式展開、バックスラッシュ記法が有効|
|%s   |シンボル。式展開、バックスラッシュ記法は無効|
{: .table .table-striped}

%記法は`%Q!hoge!`のように使う。
区切り文字`!`の部分には改行を含めた任意の非英数字を使うことができる。
よって以下はすべて同じ意味である。

~~~~
%Q!hoge!
%Q@hoge@
%Q#hoge#
%Q$hoge$
%Q%hoge%
%Q^hoge^
%Q&hoge&
%Q*hoge*
%Q-hoge-
%Q_hoge_
%Q=hoge=
%Q+hoge+
%Q`hoge`
%Q~hoge~
%Q\hoge\
%Q|hoge|
%Q;hoge;
%Q:hoge:
%Q'hoge'
%Q"hoge"
%Q,hoge,
%Q.hoge.
%Q/hoge/
%Q?hoge?
~~~~

また特例として区切り文字が括弧(`(`, `[`, `{`, `<`)の場合は、終わりの区切り文字が対応する括弧になる。
よって以下もすべて同じ意味である。

~~~~
%Q(hoge)
%Q[hoge]
%Q{hoge}
%Q<hoge>
~~~~

括弧を区切り文字とした場合、対応がとれていれば区切り文字と同じ括弧を要素に含めることができる。

~~~~
%(()) => "()"
~~~~

参考

- [%記法](http://docs.ruby-lang.org/ja/1.9.3/doc/spec=2fliteral.html#percent)
