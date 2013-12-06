---
layout: blog
title: nginxの最大bodyサイズを設定する
tag: nginx
---

# nginxの最大bodyサイズを設定する

nginxが受け付ける最大のbodyサイズはデフォルトで1Mバイトに制限されている。
nginxをリバースプロキシとして運用している場合、この制限が原因で大きなファイルのアップロードなどが、413 Request Entity Too Largeで失敗する事がある。
nginxが受け付ける最大のbodyサイズは`client_max_body_size`で調整することができる。
一例として、example.comで10Mバイトまでのbodyを受け付けるには、以下のようにする。

~~~~
server {
        listen 80;
        server_name example.com;
        client_max_body_size 10m;

        location / {
                proxy_pass http://127.0.0.1:8080;
        }
}
~~~~
