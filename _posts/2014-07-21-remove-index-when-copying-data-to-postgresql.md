---
layout: blog
title: PostgreSQLでCOPYする時はインデックスを削除すべし、数十倍高速化する
tag: postgresql
---



常識なのかも知れないが、タイトルの通りである。

先日、拙作のGemのランキングサイト[BestGems.org](http://bestgems.org/)の1億レコードほどあるデータベースをSQLite3からPostgreSQLへマイグレーションした。
この際に単に[PostgreSQLのCOPY文](/2014/06/06/postgresql-copy-from-csv.html)を使うだけでは速度が遅すぎる問題が発生したため、このエントリを書く。

PostgreSQLに大量のデータを投入する方法については、[PostgreSQLの公式ドキュメント](http://www.postgresql.jp/document/9.3/html/populate.html)が最も信頼のおける情報源だ。ちゃんと日本語訳されているので、これを読まないという選択肢はないだろう。ドキュメントによると、以下のアプローチがある。

1. 自動コミットをオフにする
2. COPYの使用
3. インデックスを削除する
4. 外部キー制約の削除
5. maintenance_work_memを増やす
6. checkpoint_segmentsを増やす
7. WALアーカイブ処理とストリーミングレプリケーションの無効化
8. 最後にANALYZEを実行
9. pg_dumpに関するいくつかの注意

今回は*2.*と*3.*のアプローチについて結果をまとめる。

# 測定

`values`テーブルと、`rankings`テーブルに合計およそ1億レコードをCOPY文を使って挿入する。
スキーマは以下のとおり。

~~~~
bestgems=# \d values
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
    "values_gem_id_index" btree (gem_id)
    "values_type_index" btree (type)

bestgems=# \d rankings
                          Table "public.rankings"
 Column  |  Type   |                       Modifiers                       
---------+---------+-------------------------------------------------------
 id      | integer | not null default nextval('rankings_id_seq'::regclass)
 type    | integer | 
 gem_id  | integer | 
 date    | date    | 
 ranking | integer | 
Indexes:
    "rankings_pkey" PRIMARY KEY, btree (id)
    "rankings_date_index" btree (date)
    "rankings_gem_id_index" btree (gem_id)
    "rankings_type_index" btree (type)
~~~~

環境はAmazon EC2のt1.microインスタンスに40GBのGeneral Purpose SSDを接続して使用した。

# before

主キーとインデックスを残したまま、単純にCOPY文を実行する。

## SQL

~~~~
COPY values FROM '/home/admin/csv/values.csv' WITH CSV;
COPY rankings FROM '/home/admin/csv/rankings.csv' WITH CSV;
~~~~

## 所要時間

50時間経っても1テーブルの処理も完了せず、所要時間の測定は不能。

# after

主キーとインデックスを削除して、COPY文を実行し、主キーとインデックスを再作成する。

## SQL

~~~~
ALTER TABLE values DROP CONSTRAINT values_pkey;
DROP INDEX values_date_index;
DROP INDEX values_gem_id_index;
DROP INDEX values_type_index;
ALTER TABLE rankings DROP CONSTRAINT rankings_pkey;
DROP INDEX rankings_date_index;
DROP INDEX rankings_gem_id_index;
DROP INDEX rankings_type_index;

COPY values FROM '/home/admin/csv/values.csv' WITH CSV;
COPY rankings FROM '/home/admin/csv/rankings.csv' WITH CSV;

ALTER TABLE values ADD PRIMARY KEY(id);
CREATE INDEX values_date_index ON values (date);
CREATE INDEX values_gem_id_index ON values (gem_id);
CREATE INDEX values_type_index ON values (type);
ALTER TABLE rankings ADD PRIMARY KEY(id);
CREATE INDEX rankings_date_index ON rankings (date);
CREATE INDEX rankings_gem_id_index ON rankings (gem_id);
CREATE INDEX rankings_type_index ON rankings (type);
~~~~

## 所要時間

4時間で完了した。内訳は以下のとおり。

|処理|所要時間(秒)|
|:=|=:|
|主キー、インデックス削除|1|
|COPY文実行|3932|
|主キー、インデックス作成|10986|
{: .table .table-striped}

`\timing`による生の実行結果は以下のとおり。

~~~~
ALTER TABLE
Time: 1106.671 ms
DROP INDEX
Time: 43.870 ms
DROP INDEX
Time: 102.748 ms
DROP INDEX
Time: 20.236 ms
ALTER TABLE
Time: 3.748 ms
DROP INDEX
Time: 3.934 ms
DROP INDEX
Time: 3.998 ms
DROP INDEX
Time: 3.926 ms
COPY 79089
Time: 10915.149 ms
COPY 49157625
Time: 2016675.619 ms
COPY 49157625
Time: 1916136.608 ms
ALTER TABLE
Time: 1855259.334 ms
CREATE INDEX
Time: 1325167.802 ms
CREATE INDEX
Time: 1440119.852 ms
CREATE INDEX
Time: 1360850.543 ms
ALTER TABLE
Time: 1795503.666 ms
CREATE INDEX
Time: 1020237.979 ms
CREATE INDEX
Time: 1131065.034 ms
CREATE INDEX
Time: 1058325.583 ms
~~~~

# まとめ

主キーとインデックスを残したbeforeでは50時間経っても1テーブルのCOPY文も完了しなかったが、主キーとインデックスを削除したafterでは4時間で全体の処理が完了した。
1テーブル2時間と考えると、afterはbeforeに比べて少なくとも25倍は高速であった。
afterのケースではCOPY文の実行よりインデックスの作成に時間がかかった点も興味深い。
