---
layout: blog
title: SQLite3のクエリ結果をSQLで保存(エクスポート)する方法
tag: sqlite
---

# SQLite3のクエリ結果をSQLで保存(エクスポート)する方法

SQLite3を使っていて、クエリの結果をSQLとして保存する方法のメモ。

`sqlite3`を起動して以下のようにする。
`TABLE_NAME`は出力したいテーブル名に置き換える。
これで`TABLE_NAME.sql`というinsert文が大量に書かれたSQLファイルができる。

~~~~
.mode insert TABLE_NAME
.out TABLE_NAME.sql
SELECT * FROM TABLE_NAME
~~~~

ちなみにこのデータをDBに書き戻す(インポートする)には以下のようにする。
`DB`はデータベースファイルに読み替える。

~~~~
sqlite3 DB < TABLE_NAME.sql
~~~~

大量のレコードをinsertする処理は遅いことに注意。
その場合はsqlファイルを編集して、トランザクションを使うようにすると良い。
以下のように、先頭に`BEGIN;`、末尾に`END;`を書くだけで良い。

~~~~
BEGIN;
insert XXX ...
END;
~~~~
