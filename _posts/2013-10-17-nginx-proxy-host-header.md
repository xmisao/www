---
layout: blog
title: リバースプロキシ化したnginxでHostヘッダを素通しする方法
tag: ['server', 'nginx']
---

nginxによるリバースプロキシでは、HTTPのHostヘッダがnginxにより書き換えられてバックエンドのサーバにつながる。この挙動は、バックエンドでHostヘッダに基づいて処理をする場合(例えばCookieの付与もそう)に、思わぬ落とし穴となる。

これを避けるために、バックエンドのサーバにも、nginxにアクセスされた時と同様のHostヘッダを付与してやりたくなる。nginxでは`proxy_ses_header`の設定を使えばこれを実現できる。

~~~~
server {
	listen 80;
	server_name example.com;

	location / {
		proxy_pass http://127.0.0.1:8080;
		proxy_set_header Host $host;
	}
}
~~~~

この設定の`proxy_set_header Host $host;`がHostヘッダをnginxで追加してやる設定だ。$hostはホスト名に置換されて、逐次Hostヘッダに上書きされる。結果、この仮想ホストにアクセスがあった場合、バックエンドのサーバは、自分が直接ホストに対するアクセスを処理しているように見えるというわけだ。

- 関連
 - [nginxをリバースプロキシにする設定](http://www.xmisao.com/2013/10/11/nginx-reverse-proxy.html)
