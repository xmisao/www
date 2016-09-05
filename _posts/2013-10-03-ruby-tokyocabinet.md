---
layout: blog
title: TokyoCabinetのオンメモリハッシュデータベースをRubyで利用する
tag: programming
---



TokyoCabinetはいわゆるKVS(Key-Value Store)だ。
TokyoCabinetは各種言語のバインディングを提供しており、Rubyでも簡単に使うことができる。
このエントリではTokyoCabinetのオンメモリハッシュデータベースの使い方を紹介する。

# インストール

今回はdebianのパッケージを使うことにする。
`ruby-tokyocabinet`をインストールする。

~~~~
apt-get install ruby-tokyocabinet
~~~~

# 使用例

まず`ADB::new()`でデータベースのオブジェクトを生成し、`open('*')`でオンメモリのハッシュデータベースを開く。あとはHashライクにアクセスすることができる。

~~~~
require 'tokyocabinet'
include TokyoCabinet

db = ADB::new
db.open('*')
db['foo'] = 'bar'
puts db['foo']
~~~~

TokyoCabinetを使う上で理解しておく必要があるのは、キーと値はどちらも文字列である必要があることだ。型の自動的な変換はされないので、文字列以外をキーや値にしたい場合は、`Array#pack()`や`Marshal.dump()`を使って文字列化すると良いだろう。

~~~~
require 'tokyocabinet'
include TokyoCabinet

db = ADB::new
db.open('*')

db['foo'] = [1].pack('i')
db['bar'] = [1.0].pack('d')
db['buz'] = Marshal.dump(Object.new)

p db['foo'].unpack('i')
p db['bar'].unpack('d')
p Marshal.restore(db['buz'])
~~~~

~~~~
[1]
[1.0]
#<Object:0x00000000e353f0>
~~~~
