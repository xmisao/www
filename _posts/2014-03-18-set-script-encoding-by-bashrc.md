---
layout: blog
title: スクリプトエンコーディングをUTF-8にしてRuby 1.9のマジックコメントを不要にする
tag: ruby
---



Ruby 1.9ではデフォルトのスクリプトエンコーディングがUS-ASCIIとなっている。
このため日本語を含むRubyスクリプトを実行すると以下のようなエラーが出る。

~~~~
japanese.rb:1: invalid multibyte char (US-ASCII)
~~~~

これを避けるためには、Rubyスクリプトの先頭にマジックコメントを書き、文字コードを指定してやる必要がある。
以下はUTF-8でRubyスクリプトを書く場合のマジックコメントの例である。

~~~~
# coding:utf-8
puts "ハローワールド!"
~~~~

しかし、スクリプト毎にマジックコメントを書くのは非常に億劫である。

Rubyはコマンドラインオプション`-K`でスクリプトのエンコーディングを指定できる。
以下のように`ruby`を実行すると、スクリプトエンコーディングはUTF-8となる。

~~~~
ruby -Ku japanese.rb
~~~~

とはいえRubyスクリプト実行の度にオプションを指定するのはナンセンスだ。
実はRubyは環境変数`RUBYOPT`を参照して、この環境変数の内容のオプションが指定されたように動作するようになっている。

ようは環境変数`RUBYOPT`に`-Ku`を指定してやれば、Ruby 1.8と同じように日本語のスクリプトも難なく実行できるようになる。
bashであば`~/.bashrc`あたりに以下を書いてやれば良い。

~~~~
RUBYOPT="-Ku"
export RUBYOPT
~~~~

1.9でRubyはエンコーディング周りが高機能になったが、デフォルトのスクリプトエンコーディングがUS-ASCIIで、日本語を書くのにマジックコメントが必要になったのは本当に罪深いと思う。

なお流石に問題があると思ったのか、Ruby 2.0ではデフォルトのスクリプトエンコーディングがUTF-8となり、大抵の環境でマジックコメントは不要になった。
Ruby 1.9など使わず、さっさとRuby 2.0を使えということか。
