---
layout: blog
title: SequelでJOINした時に重複したカラムを特定する方法
tag: ruby
---



ソースを読むまで良く理解できなかったのでメモっておく。RubyのORM、Sequelを使っている時に、JOINの結果カラム名が重複した場合に、カラムを特定する方法だ。

以下のようなデータベースがあったとする。

~~~~
require 'sequel'

DB = Sequel.sqlite()

DB.create_table :foo do
	primary_key :id
	integer :dup
end

DB[:foo].insert({:dup => 1})
DB[:foo].insert({:dup => 2})
DB[:foo].insert({:dup => 3})

DB.create_table :bar do
	primary_key :id
	integer :dup
	foreign_key :foo_id, :foo
end

DB[:bar].insert({:dup => 300, :foo_id => 2})
DB[:bar].insert({:dup => 200, :foo_id => 1})
DB[:bar].insert({:dup => 100, :foo_id => 3})
~~~~

この時に例えば以下のSQLのように`bar.dup`でソートしたい時にSequelでどう書けば良いのだろうか。

~~~~
SELECT * FROM bar JOIN foo ON bar.foo_id = foo.id ORDER ASC bar.dup; 
~~~~

私が見つけた方法は`Sequel.pualify()`を使う方法だ。
テーブル名とカラム名のシンボルを受け取り、これで識別子を作ることができる。

~~~~
bar.join(:foo, :foo_id => :id).order(Sequel.asc(Sequel.qualify(:bar, :dup))).each{|row|
	p row
}
~~~~

上記1行で発行されるSQLは以下。
確かに`bar.dup`でORDER BYされている。

~~~~
"SELECT * FROM `bar` INNER JOIN `foo` ON (`foo`.`id` = `bar`.`foo_id`) ORDER BY `bar`.`dup` ASC"
~~~~

出力結果は以下のとおりとなる。
`bar`テーブルの`dup`カラムを昇順ソートしたのでこれで正しい。
ソート結果に反して`:dup`には`foo`テーブルの`dup`カラムの値が上書きされている事に注意。

~~~~
{:id=>3, :dup=>3, :foo_id=>3}
{:id=>2, :dup=>2, :foo_id=>2}
{:id=>1, :dup=>1, :foo_id=>1}
~~~~
