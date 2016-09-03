---
layout: blog
title: PostgreSQLでINSERT時に自動採番の主キーが重複してエラーが出る場合の対処法
tag: database
---



PostgreSQLでは主キーを省略して`INSERT`すると主キーが自動的に採番される。
主キーの採番はシーケンスオブジェクトを使って行われ、通常はユニークな値が採番される。
しかしデータの`COPY`等を契機に、シーケンスオブジェクトとテーブル中のキー値にずれが生じる場合があるようだ。
そのような状態になると主キーを省略した`INSERT`でキーが重複したことを示す以下のエラーが発生する。

~~~~
ERROR:  duplicate key value violates unique constraint "table_pkey"
~~~~

シーケンスオブジェクトとテーブル中のキー値のずれは、以下の3ステップで確認・修復ができる。
対象のテーブルは`table`テーブルで主キーは`id`カラムとする。

1. 最大のキー値の確認
2. シーケンスオブジェクトの値の確認
3. シーケンスオブジェクトの値の更新

# 1. 最大のキー値の確認

まずテーブル中の最大のキー値を調べる。

~~~~
SELECT MAX(id) FROM table;
~~~~

# 2. シーケンスの値の確認

続いて`nextval`関数でシーケンスオブジェクトが採番する値を調べる。
この値が最大のキー値より小さければずれが生じている。

~~~~
SELECT nextval('table_id_seq');
~~~~

# 3. シーケンスの値の更新

修復するには`setval`関数でシーケンスオブジェクトの値を以下のように更新してやれば良い。

~~~~
SELECT setval('table_id_seq', (SELECT MAX(id) FROM table));
~~~~

- 参考
  - [9.15. シーケンス操作関数](http://www.postgresql.jp/document/9.1/html/functions-sequence.html)
  - [How to reset postgres' primary key sequence when it falls out of sync?](http://stackoverflow.com/questions/244243/how-to-reset-postgres-primary-key-sequence-when-it-falls-out-of-sync)
