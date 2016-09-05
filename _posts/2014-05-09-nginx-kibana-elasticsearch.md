---
layout: blog
title: nginxでkibanaを配信する / nginxをelasticsearchのリバースプロキシとする
tag: ['nginx', 'kibana', 'elasticsearch']
---



# はじめに

kibanaやelasticsearchはアクセス制限の仕組みを持っていないので、インターネット上のホストにこれらのソフトをインストールして使用するには、HTTPサーバでアクセスアクセス制限を行うしかない。

今回はnginxを使ってkibanaを配信するとともに、nginxをelasticsearchのリバースプロキシとして、両方にBASIC認証でアクセス制限をかける方法を紹介する。

# nginx

設定の前提は以下のとおり。
実際には自分の環境に沿って読み替えること。

- kibanaとelasticsearchにアクセスするドメインは`example.com`
- kibanaは`/var/www`に設置されている
- パスワードファイルは`/etc/nginx/htpasswd`に設定されている
- elasticsearchは`localhost:9200`で動作している

~~~~
server {
  listen 80; 
  server_name example.com;
  root /var/www;
  auth_basic 'closed site';
  auth_basic_user_file /etc/nginx/htpasswd;

  location /es/ {
    proxy_pass http://127.0.0.1:9200/;
  }
}
~~~~

これで`http://example.com/`でkibanaを配信し、`http://example.com/es/`のアクセスがelasticsearchに転送されるようになる。

# kibana

ブラウザから見たelasticsearchのアクセス先は`http://example.com/es/`だ。
これを踏まえてkibanaの`config.js`で`elasticsearch:`の行を以下のようにする。

~~~~
elasticsearch: "http://example.com/es",
~~~~

# おわりに

以上でkibanaを配信する設定、elasticsearchのリバースプロキシの設定が完了した。
さっそく`http://example.com/`にアクセスしよう。
正しく設定できていれば、これでkibanaとelasticsearchにアクセス制限をかけつつ、kibanaが正しく動作するはずだ。
