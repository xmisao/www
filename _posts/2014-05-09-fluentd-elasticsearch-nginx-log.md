---
layout: blog
title: kibanaのためにfluentdでnginxのログをelasticsearchへ送る設定例
tag: ['kibana', 'fluentd', 'elasticsearch', 'nginx']
---



# はじめに

nginxのログをfluentd + elasticsearch + kibanaで可視化する設定例。

# nginx

fluentdがnginxのログを解釈できるように、あらかじめログフォーマットを設定しておく。
今回は[こちらのエントリ](http://www.xmisao.com/2014/05/08/fluentd-store-nginx-log-to-mongodb.html)の方法でltsv形式でログを出力するようにしておくことにする。
前提とするltsvを出力する`log_format`の設定は以下。

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
                'upstream_response_time:$upstream_response_time\t'
                'host:$host';
~~~~

# fluentd

## fluent-plugin-elasticsearch

fluentdでelasticsearchにデータを送るためのプラグイン、fluent-plugin-elasticsearchをインストールする。
インストールはgemから以下で良い。
ビルドにlibcurlが必要なので予めインストールしておく。

~~~~
gem install fluent-plugin-elasticsearch
~~~~

## fluent-plugin-typecast

__2014/5/10 追記:fluentdがv.0.10.42以上ならこのプラグインを使わない方法がある。詳しくは一番下の追記を参照。__

fluentdでデータの型を変換するプラグイン、fluent-plugin-typecastもインストールしておく。
インストールはgemから以下のとおり。

~~~~
get install fluent-plugin-typecast
~~~~

## fluentdの設定

`fluentd.conf`に以下の内容を記述する。

~~~~
<source>
  type tail
  format ltsv
  tag nginx
  path /var/log/nginx/access.log
  pos_file /var/log/fluentd/buffer/access.log.pos
</source>

<match nginx>
  type typecast
  item_types request_length:integer,status:integer,request_time:float,bytes_sent:integer,body_bytes_sent:integer,upstream_response_time:integer
  prefix typed
</match>

<match typed.nginx>
  type elasticsearch
  host localhost
  port 9200
  index_name fluentd
  type_name nginx
  logstash_format true
</match>
~~~~

sourceではtailプラグインを使って、nginxのログを読み込む設定をする。
今回はltsv形式のログを読み込むので、`format ltsv`を指定する。

ltsvでパースしたデータの値はすべて文字列である。
そこでデータをelasticsearchに送る前に、fluent-plugin-typecastを使ってデータを適切な型に変換する。

まず`type typecast`でこのプラグインを指定し、`item_types`に要素の名前と変換する型を指定する。
注意点として`item_types`に指定する値はスペースを含んではならない。
`prefix`はタグに付けるプレフィックスを指定する。
今回は`typed`を指定しているので、このプラグインが出力するデータのタグは`typed.nginx`となる。

最後にデータをelasticsearchに送る設定をする。
`type elasticsearch`でfluent-plugin-elasticsearchを指定する。
このプラグインでのポイントは`logstash_format true`である。
これはlogstashの形式でデータを出力するオプションだ。
これを指定しないとelasticsearchに格納されるレコードに`@timestamp`フィールドが作られず、kibanaでデータを時系列で描画することができない。

# おわりに

以上で、fluentdでnginxのログを収集し、elasticsearchに送信する設定が完了した。
設定項目は多いが内容は簡単なものなので、手順さえわかれば手早く設定することができると思う。
kibanaをインストールしていれば、これでkibanaの画面上でログの可視化が可能となるはずである。

# 2014/5/10追記

[@repeatedly](https://twitter.com/repeatedly/status/464961290247475200)さん、情報ありがとうございます!

fluentdがv.0.10.42以上であればtailプラグインに型変換をする機能が追加されているとのこと。このためfluent-plugin-typecastは不要である。fluent-plugin-typecastを使わずに書いた`fluentd.conf`は以下。

~~~~
<source>
  type forward
</source>

<source>
  type tail
  format ltsv
  tag nginx
  path /var/log/nginx/access.log
  pos_file /var/log/fluentd/buffer/access.log.pos
  types request_length:integer,status:integer,request_time:float,bytes_sent:integer,body_bytes_sent:integer,upstream_response_time:integer
</source>

<match nginx>
  type elasticsearch
  host localhost
  port 9200
  index_name fluentd
  type_name nginx
  logstash_format true
</match>
~~~~
