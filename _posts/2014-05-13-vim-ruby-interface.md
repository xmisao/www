---
layout: blog
title: VimのRubyインタフェース入門
tag: ['vim', 'ruby']
---

# VimのRubyインタフェース入門

## はじめに

`+ruby`でビルドされたVimではRubyインタフェースが利用できる。
このインタフェースを使えばVimをRubyを使って制御することができる。
このエントリではVimのRubyインタフェースの使い方を簡単に説明する。

## Rubyの実行

Vimスクリプト中で`ruby`コマンドを使って以下のようにする。

~~~~
ruby puts "Hello, Ruby!"
~~~~

複数行のスクリプトを渡すにはヒアドキュメント風に以下のようにする。

~~~~
ruby << EOF
puts "Hello, Ruby!"
puts "Hello, Ruby!"
puts "Hello, Ruby!"
EOF
~~~~

## VIMモジュール

Vimから呼び出したRubyスクリプトでは`VIM`モジュールが使用できる。
Rubyスクリプトではこのモジュールを使用してVimとのやりとりを行う。

### VIM::evaluate

Vimで式を評価して、その値をRuby側で取得するモジュール関数である。
Rubyから変数の値を取得したり、Vimの関数を実行した結果を取得するのに使用する。
ヘルプでは返り値は文字列となっているが、[配列や辞書も扱うことができる](http://www.xmisao.com/2014/05/07/if-ruby-vim-evaluate-memo.html)。

~~~~
let a = "foo"
let b = 42
ruby << EOF
p VIM.evaluate('a') #=> "foo"
p VIM.evaluate('b') #=> 42
p VIM.evaluate('getpos(".")') #=> [0, 43, 1, 0]
EOF
~~~~

### VIM::command

Vimでコマンドを実行するモジュール関数である。

~~~~
ruby << EOF
  VIM::command("sp") # ウィンドウを分割
EOF
~~~~

RubyからVimに値を渡す場合はこのモジュール関数で`let`すれば良い。

~~~~
func! Add(v0, v1)
ruby << EOF
  v0 = VIM::evaluate('a:v0')
  v1 = VIM::evaluate('a:v1')
  VIM::command("let result = #{v0 + v1}")
EOF
  return result
endfunc
echo Add(1, 2) #=> 3
~~~~

### VIM::Buffer, Vim::Window

前述の`VIM::evalute`と`VIM::command`で事実上すべてのVimの機能をRubyから制御できるのだが、Rubyインタフェースにはバッファとウィンドウを簡単に扱うためのクラスが用意されている。

~~~~
ruby << EOF
# カレントバッファの内容を表示する
buf = VIM::Buffer.current
for i in 1..buf.count
  print buf[i]
end
EOF
~~~~

~~~~
ruby << EOF
# カレントウィンドウの幅と高さカーソル位置を表示する
win = VIM::Window.current
print "width: #{win.width}" #=> "width: 70"
print "height: #{win.height}" #=> "height: 76"
print "cursor: #{win.cursor.inspect}" #=> "cursor: [92, 0]"
EOF
~~~~

## おわりに

以上、VimのRubyインタフェースの使い方をざっと説明した。
Rubyに慣れきっていてVimスクリプトで複雑な処理を書くのが辛い…といった場合や、何かVimスクリプトの限界を越えた高度な処理を行いたい場合は、Rubyインタフェースを使ってみても良いだろう。

- 参考
  - [Vim documentation: if_ruby](http://vim-jp.org/vimdoc-ja/if_ruby.html)
