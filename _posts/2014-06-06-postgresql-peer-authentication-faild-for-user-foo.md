---
layout: blog
title: psqlがPeer authentication faild for user 'foo'のエラーで接続できない場合
tag: database
---



PostgreSQLでユーザを追加した後に`psql`コマンドを使ってそのユーザで接続を試みると以下のエラーが発生した。
これはUNIXドメインソケットでPeer認証を行った結果として発生するエラーである。

~~~~
$ psql -U foo
psql: FATAL:  Peer authentication failed for user "foo"
~~~~

このエラーが発生する場合、PostgreSQLの設定ファイル`pg_hba.conf`に以下のような一文があるはずだ。
これはUNIXドメインソケットによるローカル接続においてPeer認証を行う設定である。
Peer認証はOSのユーザを使った認証であり、この例ではOSの`foo`ユーザが認証しないと失敗する。
`psql`はデフォルトでローカル接続を試みるため、Peer認証が失敗してエラーとなるのだ。

~~~~
local all all peer
~~~~

このエラーを回避するには以下の方法がある。

1. ローカル接続でパスワード認証など別の認証方法を使うよう設定を変更する
2. `psql`コマンドでホストを指定してTCP/IP経由で接続するようにする

1.の場合、例えばローカル接続にパスワード認証を使用するように設定すれば良い。

~~~~
local all all md5
~~~~

2.の場合、`psql`コマンドでホスト名は`-h`オプションで指定する。
これでTCP/IPが利用され、正しく接続できるはずである。

~~~~
$ psql -U foo -h localhost
~~~~
