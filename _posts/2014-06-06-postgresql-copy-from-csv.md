---
layout: blog
title: COPY文でCSVファイルとテーブル間でデータを高速にコピーする(PostgreSQL)
tag: database
---



PostgreSQLには`COPY`文が用意されており、ファイルとテーブル間でデータを高速にコピーすることができる。
このエントリでは`COPY`文でCSVファイルにデータを出力、またCSVファイルからデータを入力する方法を紹介する。
また参考として約4000万レコードのデータをCSVからPostgreSQLに`COPY`した際の処理時間の実測値を示す。

なお環境はDebian Wheezy標準のPostgreSQL 9.1.12を使用している。
詳しくは`COPY`文についての[公式のドキュメント](http://www.postgresql.jp/document/9.1/html/sql-copy.html)を参照。

# CSVファイルに出力

テーブル`table`の内容をファイル`/path/to/file.csv`にコピーするには以下のようにする。
ファイル名は絶対パスを与える必要があることに注意。

~~~~
COPY table TO '/path/to/file.csv' WITH CSV
~~~~

# CSVファイルから入力

ファイル`/path/to/file.csv`の内容をテーブル`table`にコピーするには以下のようにする。
やはりファイル名は絶対パスを与える必要があることに注意。

~~~~
COPY table FROM '/path/to/file.csv' WITH CSV
~~~~

# 参考:4000万レコードのCOPYの処理時間

以下のテーブルにCSVから約4000万件のデータを`COPY`した。

~~~~
bestgems=> \d values;
                         Table "public.values"
 Column |  Type   |                      Modifiers                      
--------+---------+-----------------------------------------------------
 id     | integer | not null default nextval('values_id_seq'::regclass)
 type   | integer | 
 gem_id | integer | 
 date   | date    | 
 value  | integer | 
Indexes:
    "values_pkey" PRIMARY KEY, btree (id)
    "values_date_index" btree (date)
    "values_type_index" btree (type)
    "valuess_gem_id_index" btree (gem_id)
Foreign-key constraints:
    "values_gem_id_fkey" FOREIGN KEY (gem_id) REFERENCES gems(id)
~~~~

実測したマシンのスペックは以下のとおり。

- CPU: AMD FX-8350 8コア 4.0GHz
- RAM: 32GB
- SSD: CFD CSSD-S6T120NTS2Q

結果は44,805,691件のコピーに3852秒かかった。

~~~~
bestgems=# COPY values FROM '/home/xmisao/bestgems/tools/psql_migrator/csv/values.csv' WITH CSV;
COPY 44805691
Time: 3852193.226 ms
~~~~

# 参考:インデックスとWALの無効化による高速化

`COPY`文はインデックスやWAL(ログ先行書き込み)の影響を受けるというエントリを見つけた。
インデックスを削除したり、WALを無効化したりすることで、COPY文を高速化できるとのことである。

- [大量のデータを高速に投入するには](http://lets.postgresql.jp/documents/technical/bulkload/)
