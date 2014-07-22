---
layout: blog
title: Sequelでレコードがあれば更新なければ挿入するUPSERTを実装
tag: sequel
---

# Sequelでレコードがあれば更新なければ挿入するUPSERTを実装

レコードがあれば更新を行い、なければ挿入を行いたい。
そのようなケースはデータベースを使っているとしばしば存在する。

このような処理はINSERTとUPDATEを合わせてUPSERTと呼ばれる。
DBMSの中には、UPSERTを1ステートメントで行える機能を持つものがある。
MySQLやSQLiteのREPLACE構文がそれである。
しかしREPLACE構文は標準化されていないので、DBMS依存のプログラムとなり使い勝手が悪い。
またSequelはREPLACE構文をサポートしていない。

本エントリではDBMSに依らずに使用できる擬似的なUPSERTをSequelのプログラムで実装する。

以下がプログラムで実装した擬似的なUPSERTの例だ。
Sequelで実行されるSQLはコメントで併記した。

~~~~ruby
require 'sequel'

DB = Sequel.sqlite

DB.create_table :table do
  primary_key :id
  String :column1
  String :column2
end

# UPDATE `table` SET `column2` = 'bar' WHERE (`column1` = 'foo')
if DB[:table].where(:column1 => 'foo').update(:column2 => 'bar') == 0
  # INSERT INTO `table` (`column1`, `column2`) VALUES ('foo', 'bar')
  DB[:table].insert(:column1 => 'foo', :column2 => 'bar')
end
~~~~

上の方はSequelのおまじないなので無視するとして、UPSERTの実装は下5行だ。
最初に`UPDATE`で更新を試みる。
`UPDATE`は更新した行数を返すので、更新した行が無ければ、続けて`INSERT`を実行する。

これだけでUPSERTがプログラムで実装できる。
行の確認のために`SELECT`するよりはスマートだ。
通常のINSERTより多少遅くなるのはやむを得ない。

なお例では省略したが必要に応じてトランザクションを使うこと。

- 参考
  - [How to update or insert on Sequel dataset?](http://stackoverflow.com/questions/9769024/how-to-update-or-insert-on-sequel-dataset)
