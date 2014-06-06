---
layout: blog
title: minitestのテストを全て実行するRakefike
tag: ruby
---

# minitestのテストを全て実行するRakefike

タイトルのとおり、minitestのテストを全て実行するRakefileは以下のように書ける。
これで`test`ディレクトリ以下にある`test_foo.rb`のようなテストスクリプトが全て実行される。

~~~~
# coding: UTF-8

require 'rake/testtask'

task :default => [:test]

Rake::TestTask.new do |test|
  test.test_files = Dir['test/**/test_*.rb']
  test.verbose = true
end
~~~~
