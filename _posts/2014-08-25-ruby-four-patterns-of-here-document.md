---
layout: blog
title: Rubyのヒアドキュメント 4パターンのまとめ
tag:
---

# Rubyのヒアドキュメント 4パターンのまとめ

Rubyには4種類のヒアドキュメントがある。それぞれ見てみよう。なおヒアドキュメントの命名は著者による。

## 式展開ヒアドキュメント

恐らく最も基本的な識別子に何も付けないヒアドキュメントである。
`"`の文字列に相当し、式展開が行われることがポイント。

~~~~ruby
val = 123
str = <<EOS
  hoge
  piyo
  fuga
  #{val}
EOS
print str
~~~~

~~~~
  hoge
  piyo
  fuga
  123
~~~~

式展開を行うことを明示する意味で、識別子を`"`で囲っても同じ結果が得られるようになっている。

~~~~ruby
val = 123
str = <<"EOS"
  hoge
  piyo
  fuga
  #{val}
EOS
print str
~~~~

~~~~
  hoge
  piyo
  fuga
  123
~~~~

## 非式展開ヒアドキュメント

`'`の文字列に相当する、式展開を行わないヒアドキュメントもある。この場合はヒアドキュメントの識別子を`'`で囲む。

~~~~ruby
val = 123
str = <<'EOS'
  hoge
  piyo
  fuga
  #{val}
EOS
print str
~~~~

~~~~
  hoge
  piyo
  fuga
  #{val}
~~~~

## コマンド出力ヒアドキュメント

これは少し変化球でコマンド出力リテラルに相当する、コマンド実行を行った結果を返すヒアドキュメントである。この場合はヒアドキュメントの識別子をバッククオートで囲む。

~~~~ruby
str = <<`EOS`
echo "What time is is it now?"
date
EOS
print str
~~~~

~~~~
what time is is it now?
Mon Aug 25 23:53:36 JST 2014
~~~~

## インデントヒアドキュメント

これは他のヒアドキュメントと組み合わせて使うことができる。識別子の前に`-`をつけることで、終端の識別子をインデントすることができる。

~~~~ruby
begin
  val = 123
  str = <<-"EOS"
    hoge
    piyo
    fuga
    #{val}
  EOS
end
print str
~~~~

~~~~
    hoge
    piyo
    fuga
    123
~~~~

残念なのはヒアドキュメントの中身までインデントできるわけではないので、結局ヒアドキュメントの内部ではインデントが崩れてしまうことだ。

インデント崩れを解決する方法についてはおまけで述べる。

## おまけ

### ヒアドキュメントをメソッドの引数に使う

ヒアドキュメントの開始ラベルはRuby的には式にあたるため、式が書ける箇所にはヒアドキュメントの開始ラベルを書いて、続けてヒアドキュメントを書くことができる。

~~~~ruby
def method(*args)
  p args
end

method('foo', <<EOS, 'baz')
bar
EOS
~~~~

~~~~
["foo", "bar\n", "bar"]
~~~~

### 複数のヒアドキュメントを併用する

前項で書いたとおりヒアドキュメントの開始ラベルは式なので、複数のヒアドキュメントを1行に書いてしまうこともできる。

~~~~ruby
def method(*args)
  p args
end

method(<<FOO, <<BAR, <<BAZ)
foo
FOO
bar
BAR
baz
BAZ
~~~~

~~~~
["foo\n", "bar\n", "baz\n"]
~~~~

Ruby怖い。

### String#undentでインデントを除去する

先ほどから度々書いているとおり、開始ラベルは式である。少し工夫して開始ラベルに文字列処理のメソッドを呼び出すことで、ヒアドキュメント中のインデントを除去することもできる。

以下は`String#gsub`で行先頭の空白文字を除去することで、インデントを除去する例。

~~~~ruby
begin
  str = <<-EOS.gsub(/^\s+/, '')
    foo
    bar
    baz
  EOS
end
print str
~~~~

~~~~
foo
bar
baz
~~~~

これならインデントを崩さずにヒアドキュメントを使うことができる。

## 所感

無意識的に使っているが、こうして整理してみて勉強になった。

- 参考
  - [Ruby 1.9.3 リファレンスマニュアル > リテラル ](http://docs.ruby-lang.org/ja/1.9.3/doc/spec=2fliteral.html#here)
