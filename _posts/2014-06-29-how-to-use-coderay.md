---
layout: blog
title: coderayでシンタックスハイライトする
tag: ruby
---

# coderayでシンタックスハイライトする

[coderay](http://coderay.rubychan.de/)はピュアRubyのシンタクスハイライト用ライブラリだ。
公式サイトによると現時点で22個の主要な言語に対応している。

シンタックスハイライトの分野ではPythonの[pygments](http://pygments.org/)が有名だ。
pygmentsはBrainFuckなどどうでも良いものを含めて100以上もの言語に対応している。
pygmentsをRubyから使用するためのラッパ[pygments.rb](https://github.com/tmm1/pygments.rb)もある。
しかし、ピュアRubyという点でcoderayを抑えておくのもメリットがあるだろう。

## インストール

coderayはgemからインストールできる。

~~~~ bash
gem install coderay
~~~~

## 使い方

coderayによるハイライトは以下2つの操作により行う。

1. 言語をパースしてトークンの集合を作る
2. トークンの集合を任意の形式で出力する

*1.*の操作を行うモジュールをScanner、*2.*の操作を行うモジュールをEncoderと呼ぶ。

以下はRubyのソースコードを、ターミナルに出力させる例である。
`CodeRay.scan`でトークンの集合を作り、トークンの集合を`terminal`でターミナル出力用の文字列にしている。
たった1行であるが、これだけで色付きでRubyのソースコードを表示できる。

~~~~ ruby
require 'coderay'

src = <<RUBY
def hello
  puts 'Hello.'
end
RUBY

puts CodeRay.scan(src, :ruby).terminal
~~~~

別のバリエーションも見てみよう。
ファイルの内容をハイライトして表示するには`CodeRay.scan_file`を使う。
この場合、言語の種類は拡張子から判断されるので、指定不要である。
さらに結果をHTMLで出力するに、`html`を使う。

~~~~ ruby
require 'coderay'

puts CodeRay.scan_file('hello.rb').html
~~~~

出力結果は以下のようになる。

~~~~ html
<span class="keyword">def</span> <span class="function">hello</span>
  puts <span class="string"><span class="delimiter">'</span><span class="content">Hello.</span><span class="delimiter">'</span></span>
<span class="keyword">end</span>
~~~~
