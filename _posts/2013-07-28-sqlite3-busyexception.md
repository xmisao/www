---
layout: blog
title: SequelでSQLite3のBusyExceptionが出た場合の対処法
tag: database
---



SequelでSQLite3を使ってコードを書いていたら、ある時からBusyExceptionが発生しプログラムが落ちるようになってしまった。

このエラーは、SQLite3のタイムアウトが早すぎるため発生している。デフォルトではタイムアウトは0で、ロックできなければその瞬間エラーとなる。

DBがロックできるまで待つようにするには、SQLite3の接続時にオプション引数でタイムアウト時間を設定してやれば良い。Sequelの場合は以下。

    DB = Sequel.sqlite('DB', :timeout => 60000)

Ruby on Railsの場合は以下のエントリが参考になる。database.ymlでタイムアウトの設定をするようだ。

* [SQLite3::BusyException](http://stackoverflow.com/questions/78801/sqlite3busyexception)
