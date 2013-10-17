---
layout: blog
title: nginxをリバースプロキシにする設定
tag: ['server', 'nginx']
---

# nginxをリバースプロキシにする設定

nginxを別のHTTPサーバのリバースプロキシとして設定するには、`location`と`proxy_pass`により以下の設定をする。

~~~~
server {
	listen 80;
	server_name example.com;

	location / {
		proxy_pass http://127.0.0.1:8080;
	}
}
~~~~

この設定では、example.comのポート80に対するアクセスを、すべてlocalhostのポート8080で動作している別のHTTPサーバで処理する。
