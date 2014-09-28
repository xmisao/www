---
layout: blog
title: Rubyで巨大なYAMLファイルを少しずつ読み込んで処理する
tag: ruby
---

# Rubyで巨大なYAMLファイルを少しずつ読み込んで処理する

複数のドキュメントから成る巨大なYAMLファイルを、1ドキュメントずつ読み込んで処理する方法。

まずテスト用に巨大なYAMLファイルを作る。
以下のスクリプトを`generate_yaml.rb`として保存。

~~~~ruby
require 'yaml'
require 'securerandom'

puts YAML.dump_stream( *(0..1024 * 10).map{ SecureRandom.hex(512) } )
~~~~

このプログラムは1024byteの文字列を含むドキュメントを10240個連結して出力する。

以下のように実行。
約10MBのYAMLファイルができた。

~~~~
$ ruby generate_yaml.rb > huge.yaml
$ du -h huge.yaml
11M     huge.yaml
~~~~

こいつを少ないメモリで読み込んで処理したいとする。

複数のドキュメントから成るYAMLファイルを効率的に読み込むには`YAML.load_stream`を使う。
以下のスクリプトを`load_stream.rb`として保存。
このスクリプトは標準入力から全ドキュメントを順番に読み込み出力するもの。

~~~~ruby
require 'yaml'

YAML.load_stream(STDIN){|doc|
  p doc
}
~~~~

このスクリプトに先ほど作った巨大なYAMLファイルを読み込んで処理させる。
[timeでメモリ使用量を測定する方法](2014-09-28-shell-time-command-and-gnu-time-command.html)を使用してメモリ使用量を計る。
出力は無駄なので`/dev/null`へリダイレクトする。

~~~~
$ /usr/bin/time -f "%M" ruby load_stream.rb < huge.yaml > /dev/null
12236
~~~~

使用メモリはRubyインタプリタを含めてわずか12MBだった。
このスクリプト自体はほとんどメモリを使わずに巨大なYAMLが処理できていることがわかる。

ちなみに`YAML.load_documents`はメモリに全ドキュメントを読み込んでしまう。
比較用に`load_documents.rb`として以下を保存。
読み込みに使うメソッドが違う以外は同じスクリプトである。

~~~~ruby
require 'yaml'

YAML.load_documents(STDIN){|doc|
  p doc
}
~~~~

結果は以下のとおり。
35MBほどメモリを使用していることがわかる。

~~~~
$ /usr/bin/time -f "%M" ruby load_documents.rb < huge.yaml > /dev/null
35288
~~~~
