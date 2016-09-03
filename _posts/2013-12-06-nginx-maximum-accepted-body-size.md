---
layout: blog
title: nginxの最大bodyサイズを設定する
tag: nginx
---



nginxが受け付ける最大のbodyサイズはデフォルトで1Mバイトに制限されている。
この制限に引っかかると、大きなファイルのアップロードなどが、413 Request Entity Too Largeで失敗してしまう。
nginxが受け付ける最大のbodyサイズは`client_max_body_size`で調整することができる。
一例として、example.comのバーチャルホストで10Mバイトまでのbodyを受け付けるには、以下のようにする。

~~~~
server {
        listen 80;
        server_name example.com;
        client_max_body_size 10m;

				# 省略
}
~~~~
