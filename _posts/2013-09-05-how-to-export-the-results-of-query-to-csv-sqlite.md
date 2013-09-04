---
layout: blog
title: SQLite3でクエリの結果をCSVファイルへ出力する方法
tag: sqlite
---

# SQLite3でクエリの結果をCSVファイルへ出力する方法

SQLite3のコマンドラインインタフェースsqlite3には出力形式を変更できる機能がある。これを使えば、クエリ結果をCSVファイルに書き出すことが可能だ。

具体的には以下の操作。`.mode csv`で出力をCSV形式に指定し、`.output`で出力先のファイルを指定する。あとはクエリを実行するだけだ。

    .mode csv
    .output result.csv
    select * ffrom sometable;

カラム名のヘッダが必要な場合は、`.headers on`をつけてやれば良い。

    .headers on
    .mode csv
    .output result.csv
    select * ffrom sometable;

ちなみにsqlite3は多機能で、`.mode`で指定できるモードには以下がある。

- csv -- カンマ区切り
- column -- 左寄せカラム(幅は`.width`で指定)
- insert -- HTMLのテーブル
- line -- 1つの値を1行に出力
- list -- `.separator`で指定したデリミタ区切り
- tabs -- タブ区切り
- tcl -- TCLリスト要素
