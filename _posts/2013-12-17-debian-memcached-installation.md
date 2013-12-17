---
layout: blog
title: Debian WheezyでmemcachedをインストールしRubyから接続する
tag: linux server ruby
---

# Debian WheezyでmemcachedをインストールしRubyから接続する

Debianであればmemcachedパッケージをaptでインストールできる。
Debian Wheezyのmemcachedパッケージのバージョンは1.4.13である。
本エントリ執筆時の最新版である1.14.16よりやや古いが、そこは気にせずにインストールすることにする。

~~~~
apt-get install memcached
~~~~

これで問題なくmemcachedサービスが動作し始めるが、せっかくなのでプログラムからの接続もテストしてみよう。
このエントリではRubyからmemcachedを使ってみることにする。

Rubyからmemcachedを利用するには、memcachedというgemをインストールすれば良い。
なおgemのmemcachedは現時点でRuby 1.8.7か1.9.2でのみ動作を保証していることに注意する。
gemのmemcachedはlibsasl2というライブラリに依存するネイティブエクステンションである。
このため`libsasl2-dev`をaptから事前にインストールしておく。

~~~~
apt-get install libsasl2-dev
gem install memcached
~~~~

次にmemcachedを使ったプログラムを用意して、実行してみよう。
以下はつまらないが、`foo`というキーに、`bar`という文字列を格納して、それを取得する例である。

~~~~
require 'memcached'
cache = Memcached.new() # Memcached.new("localhost:11211")
cache.set 'foo', 'bar'
p cache.get 'foo' # => 'bar'
~~~~

memcachedを使うために`memcached`を`require`しておく。
memcachedに接続するには`Memcached.new`でアクセス用のオブジェクトを生成する。
`Memcached.new`はデフォルトで*localhost:11211*に接続するので特に引数は不要である。
あとは`Memcached`のインスタンスメソッド、`set`および`get`で、値の格納と取得が行える。

このスクリプトを実行して`bar`が表示されれば成功である。
なおmemcachedに接続できない場合は、`set`の時点で`Memcached::ServerIsMarkedDead`例外が発生する。
