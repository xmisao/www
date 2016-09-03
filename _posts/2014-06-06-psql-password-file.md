---
layout: blog
title: パスワードファイルを使ってpsqlのパスワード入力を省略する
tag: database
---



PostgreSQLの`psql`コマンドには、オプションでパスワードを与えることができない。
常に対話でパスワードを入力する必要があり、バッチ処理などで支障がある。

オプションでパスワードを与える代わりに、
`psql`コマンドはパスワードファイルを使って
対話によるパスワード入力を省略することができる。

パスワードファイルは`$HOME/.pgpass`である。
書式は以下のとおり。

~~~~
ホスト名:ポート:データベース:ユーザ:パスワード
~~~~

以下はlocalhostのmydbデータベースにfooユーザでパスワードbarで接続する例である。

~~~~
localhost:5432:mydb:foo:bar
~~~~

あとは`psql`コマンドでDBに接続すれば、パスワード入力が省略されるはずである。

~~~~
psql -h localhost -U foo mydb
~~~~

- 参考
  - [31.15. パスワードファイル](http://www.postgresql.jp/document/9.2/html/libpq-pgpass.html)
