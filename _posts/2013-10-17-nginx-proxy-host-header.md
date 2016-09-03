---
layout: blog
title: リバースプロキシ化したnginxでHostヘッダを素通しする設定
tag: ['server', 'nginx']
---




nginxによるリバースプロキシでは、HTTPのHostヘッダがnginxにより書き換えられてバックエンドのサーバに伝わる。この挙動は、バックエンドでHostヘッダに基づいて処理をする場合(例えばCookieの付与)に、思わぬ落とし穴となることがある。

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

この設定の`proxy_set_header Host $host;`がHostヘッダをnginxで設定してやる指定になる。$hostはホスト名に置換されて、バックエンドへのアクセス時にHostヘッダに上書きされる。

結果、バックエンドのサーバは、自分が直接そのホストに対するアクセスを処理しているように見え、Hostに基づく様々な処理がうまく動くようになるわけだ。

- 関連
 - [nginxをリバースプロキシにする設定](http://www.xmisao.com/2013/10/11/nginx-reverse-proxy.html)
