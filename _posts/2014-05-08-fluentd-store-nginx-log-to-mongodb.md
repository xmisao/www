---
layout: blog
title: fluentdでnginxのログをMongoDBに保存する
tag: ['fluentd', 'linux']
---

# fluentdでnginxのログをMongoDBに保存する(debian wheezy)

fluentdでnginxのログをMongoDBに保存してみよう。

## 準備

### MongoDBのインストール

debian wheezyならMongoDBは`mongodb`パッケージでインストールできる。

~~~~
apt-get install mongodb
~~~~

### MongoDB Output pluginのインストール

fluentdをgemでインストールした場合、ログをMongoDBに保存するには、MongoDB Output pluginのインストールが必要である。

以下でインストールできる。

~~~~
gem install fluent-plugin-mongo --no-ri --no-rdoc
~~~~

## nginxの設定

今回は[このエントリ](http://qiita.com/key/items/038b7913b3bb0298c625)を参考に、アクセスログをltsv形式で出力するように設定することにしよう。

`/etc/nginx/conf.d/log_format.conf`を作成して以下の内容を記述し、`ltsv`ログフォーマットを定義する。

~~~~
log_format ltsv 'time:$time_iso8601\t'
                'remote_addr:$remote_addr\t'
                'request_method:$request_method\t'
                'request_length:$request_length\t'
                'request_uri:$request_uri\t'
                'https:$https\t'
                'uri:$uri\t'
                'query_string:$query_string\t'
                'status:$status\t'
                'bytes_sent:$bytes_sent\t'
                'body_bytes_sent:$body_bytes_sent\t'
                'referer:$http_referer\t'
                'useragent:$http_user_agent\t'
                'forwardedfor:$http_x_forwarded_for\t'
                'request_time:$request_time\t'
                'upstream_response_time:$upstream_response_time';
~~~~

続いてnginxのserverコンテキストで、以下のようにltvs形式でログを出よくするように設定する。

~~~~
access_log /var/log/nginx/access.log ltsv;
~~~~

nginxに設定ファイルを読み込ませて完了。事前に複数のログフォーマットが混在しないように、ログは整理しておきたい。

~~~~
/etc/init.d/nginx reload
~~~~

## fluentdの設定

fluentdの設定ファイル`fluent.conf`に以下の内容を記述する。

~~~~
<source>
  type tail
  format ltsv
  tag mongo.nginx.access
  path /var/log/nginx/access.log
  pos_file /var/log/fluentd/buffer/access.log.pos
</source>

<match mongo.nginx.access>
  type mongo
  database nginx
  collection access
  host localhost
  port 27017
  flush_interval 10s
</match>
~~~~

設定ファイル中で指定したposファイルの保存場所を作成する。

~~~~
mkdir -p /var/log/fluentd/buffer
~~~~

これでflutendを再起動すればnginxのログを収集すると同時にMongoDBのnginxデータベースのaccessコレクションにデータが保存されるようになる。

## 確認

`mongo`コマンドでMongoDBに接続し、データが保存されているか確認してみよう。

~~~~
mongo
~~~~

~~~~
MongoDB shell version: 2.0.6
connecting to: test
> use nginx
switched to db nginx
> db["access"].findOne();
{
        "_id" : ObjectId("536ae37363dc2f770f000001"),
        "remote_addr" : "66.249.79.15",
        "request_method" : "GET",
        "request_length" : "276",
        "request_uri" : "/related/%E5%B0%8F%E5%B9%A1%E8%A8%98%E5%AD%90",
        "https" : "",
        "uri" : "/related/\\xE5\\xB0\\x8F\\xE5\\xB9\\xA1\\xE8\\xA8\\x98\\xE5\\xAD\\x90",
        "query_string" : "-",
        "status" : "200",
        "bytes_sent" : "2700",
        "body_bytes_sent" : "2446",
        "referer" : "-",
        "useragent" : "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)",
        "forwardedfor" : "-",
        "request_time" : "0.059",
        "upstream_response_time" : "0.059",
        "time" : ISODate("2014-05-08T01:52:42Z")
}
~~~~
