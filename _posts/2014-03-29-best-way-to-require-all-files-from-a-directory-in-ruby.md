---
layout: blog
title: Rubyでディレクトリ内のすべてのファイルをrequireする方法
tag: ruby
---



ディレクトリの絶対パスを指定する場合は以下のようにすれば、ディレクトリ内のすべてのファイルを`require`することができる。

~~~~
Dir["/path/to/directory/*.rb"].each {|file| require file }
~~~~

例えば`lib`ディレクトリなど、相対パスを指定したい場合は`File.dirname(__FILE__)`を使って相対パスを絶対パスに変換してやれば同様の方法で`require`できる。

~~~~
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }
~~~~

参考

- [Best way to require all files from a directory in ruby?](http://stackoverflow.com/questions/735073/best-way-to-require-all-files-from-a-directory-in-ruby)
