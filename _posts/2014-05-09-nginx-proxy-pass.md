---
layout: blog
title: nginxのproxy_passの注意点
tag: nginx
---



nginxをリバースプロキシにする場合に使用する`proxy_pass`ディレクティブは、URIが与えられた場合と、そうでない場合で挙動が異なる。

どういうことかというと、以下の*1.*と*2.*は別々の結果となる。`proxy_pass`ディレクティブの引数に注目して欲しい。

~~~~
# 1. specified with a URI
location /name/ {
    proxy_pass http://127.0.0.1/;
}
~~~~

~~~~
# 2. specified without a URI
location /name/ {
    proxy_pass http://127.0.0.1;
}
~~~~

1.は`proxy_pass`ディレクティブに完全なURIを与えた例である。この場合`http://example.com/name/foo`へのアクセスは、`/name`が削除された`http://127.0.0.1/foo`へ転送される。

2.は`proxy_pass`ディレクティブに完全なURIを与えなかった例である。この場合`http://example.com/name/foo`へのアクセスは、そのまま`http://127.0.0.1/name/foo`へ転送される。

この事は少々わかりにくいが[nginxのドキュメント](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass)にも書かれている。

>If the proxy_pass directive is specified with a URI, then when a request is passed to the server, the part of a normalized request URI matching the location is replaced by a URI specified in the directive: 

>If proxy_pass is specified without a URI, the request URI is passed to the server in the same form as sent by a client when the original request is processed, or the full normalized request URI is passed when processing the changed URI: 

サブドメインが使用できない環境で、`location`毎に接続先のWebサーバを切り替えたい場合など、一般的には*1.*の挙動の方が好ましいように思われる。

nginxでリバースプロキシを設定する場合には、自分がどちらのパターンの`proxy_pass`を書いているのか注意が必要になる。
