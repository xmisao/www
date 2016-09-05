---
layout: blog
title: ripperでシンタックスエラーを検出する
tag: ruby
---



[Rubyの標準添付ライブラリripperでRubyのソースをパースする](http://www.xmisao.com/2014/05/12/ruby-ripper.html)で紹介したとおり、ripperはRubyスクリプトのパーサである。

このripperを拙作のvimプラグイン [RubyJump](https://github.com/xmisao/rubyjump.vim)で使いたいと思ったのだが、RubyJumpは編集中のRubyスクリプトが渡されるケースもあり、シンタックスエラーのあるRubyスクリプトが入力される可能性がある。

ripperによるパースがコケた場合は、フェールバックとして正規表現によるパースを行いたかったので、何とかしてripperでシンタックスエラーを検出したいと思っていた。

ドキュメントを眺めたが方法が良くわからなかったので、思い切ってruby-listで質問してみたところ、ご親切にも中田 伸悦さんから[回答をいただいた](http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-list/49823)。ありがとうございます。

ripperでシンタックスエラーを検出するには`on_parse_error`を使えば良いとのこと。以下は`on_parse_error`でシンタックスエラーを検出する例。

~~~~
require 'ripper'

class MyRipper < Ripper
  def on_parse_error(msg)
    puts msg
  end
end

src = <<SRC
42.times do
}
SRC

MyRipper.parse(src) # syntax error, unexpected tSTRING_DEND
~~~~

シンタックスエラーも検出できるとは、ripperすごい!
