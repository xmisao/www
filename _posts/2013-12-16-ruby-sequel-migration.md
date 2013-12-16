---
layout: blog
title: Sequelによるデータベーススキーマのマイグレーション
tag: ['ruby']
---

# Sequelによるデータベーススキーマのマイグレーション

RubyのORMであるSequelには、データベースのスキーマを管理し、マイグレーションする機能がある。
マイグレーションに伴うスキーマ変更の定義は、Sequelの機能を使ったシンプルなDSLで記述する。
以下でその使い方を見てみよう。

マイグレーションの記述にはSequelの`Sequel.migration`メソッドを利用する。
このメソッドのブロック内に、アップグレードに伴う変更`up`と、それを取り消すダウングレードに伴う変更`down`を記述する。

例えば、データベースの最初のバージョンとして、`table1`テーブルを作成するマイグレーションを記述することにする。
定義ファイルを配置する`migrations`ディレクトリを作成し、`001_create_database.rb`として以下のようなファイルを作成する。

なお、ファイル名の先頭はバージョン番号である。今回は余裕をみてバージョンを3桁の数値にしている。
バージョンに続く`_`以降の名前は何でも良く、わかりやすい名前をつければ良い。

~~~~
Sequel.migration do
	# アップグレードの処理
	up do
		# table1テーブルを作成する
		create_table(:table1) do
			primary_key :id
			String :foo
		end
	end

	# ダウングレードの処理
	down do
		# table1テーブルを削除する
		drop_table(:table1)
	end
end
~~~~

データベースに対してマイグレーションを実行するには、`sequel`コマンドを用いる。
このコマンドは、Sequelのgemに同梱されている。もし必要であればパスを通しておこう。
親切なLinux環境などであれば既にパスが通っているはずである。

マイグレーションの実行は`sequel -m`だ。
引数にマイグレーション用のファイルを保存したディレクトリと、マイグレーション対象のデータベースを指定する。
例えば、マイグレーション用のファイルが`migrations`ディレクトリに保存されており、SQLite3の`DB`データベースにマイグレーションを実行するには次のようにする。

~~~~
$ sequel -m migrations sqlite://DB
~~~~

`DB`データベースの中身を確認してみよう。
作成を指示した`table1`と、マイグレーションのバージョン管理用の`schema_info`テーブルが作成されている事が確認できる。

~~~~
$ sqlite3 DB ".tables"
schema_info  table1     
~~~~

~~~~
$ sqlite3 DB ".schema table1"
CREATE TABLE `table1` (`id` integer PRIMARY KEY AUTOINCREMENT, `foo` varchar(255));
~~~~

~~~~
$ sqlite3 -header DB "SELECT * FROM schema_info"
version
1
~~~~

これだけではマイグレーションの意味がさほど感じられないので、`table1`にカラムを追加し、さらに`table2`テーブルを作成するマイグレーションを記述してみよう。
以下の内容を`migrations`ディレクトリ以下に、`002_update_database.rb`ファイルとして記述する。

~~~~
Sequel.migration do
	# アップグレードの処理
	up do
		# table1テーブルにカラムを追加する
		alter_table(:table1) do
			add_column :bar, String
		end
		# table2テーブルを作成する
		create_table(:table2) do
			primary_key :id
			String :buz
		end
	end

	# ダウングレードの処理
	down do
		# table1のカラムを削除する
		alter_table(:table1) do
			drop_column :bar
		end
		# table2テーブルを削除する
		drop_table(:table2)
	end
end
~~~~

そして再び`sequel -m`でマイグレーションを実行する。
`sequel -m`は、`schema_info`テーブルから現在のデータベースのバージョンを調べ、最新の状態まで自動的にスキーマをアップグレードする。

~~~~
$ sequel -m migrations sqlite://DB
~~~~

マイグレーション後のデータベースの中身は以下のとおりだ。
最新のスキーマに更新されており、スキーマのバージョンが2になった事もわかる。

~~~~
$ sqlite3 DB ".tables"
schema_info  table1       table2
~~~~

~~~~
$ sqlite3 DB ".schema table1"
CREATE TABLE `table1` (`id` integer PRIMARY KEY AUTOINCREMENT, `foo` varchar(255), `bar` varchar(255));
~~~~

~~~~
$ sqlite3 DB ".schema table2"
CREATE TABLE `table2` (`id` integer PRIMARY KEY AUTOINCREMENT, `buz` varchar(255));
~~~~

~~~~
$ sqlite3 -header DB "SELECT * FROM schema_info"
version
2
~~~~

`sequel -m`はスキーマのアップグレードだけでなく、スキーマを特定のバージョンまでダウングレードすることも可能だ。
マイグレーションの定義に`down`を定義するのはこのためである。
バージョンを指定してマイグレーションを行うには、`-M`オプションを指定する。
例えば、データベースをバージョン0(つまり、まっさらな状態)に戻すには以下のようにする。

~~~~
$ sequel -m migrations -M 0 sqlite://DB
~~~~

~~~~
$ sqlite3 DB ".tables"
schema_info
~~~~

~~~~
$ sqlite3 -header DB "SELECT * FROM schema_info"
version
0
~~~~

以上、Sequelのマイグレーション機能の使い方を説明した。
マイグレーションに関するより詳しい説明は、以下の公式のドキュメントを参照してほしい。

- [migration.rdoc](http://sequel.jeremyevans.net/rdoc/files/doc/migration_rdoc.html)
