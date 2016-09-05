---
layout: blog
title: Amazon S3で静的ホスティングする際のDNS設定
tag: aws
---



Amazon S3はCNAMEで参照する事になるが、CNAMEは他のレコードと一切共存できないので注意が必要。
特にexample.comのようにサブドメインをつけない場合は良く考えた方が良い。(naked domainと呼ばれる)
Web公開用にはwwwなどをつけておいて、example.comへの接続は、www.example.comに転送するようにしておくのが無難。

DNSのサービスに転送がついていない場合は、wwwizer.comのサービスを使えば別途サーバを用意せずに済む。
単にwwwを付与したいドメインのAレコードを174.129.25.170に向けるだけで良い。

wwwizer.comを使ってAmazon S3で公開した静的Webサイトを公開すると、アクセス時には以下のような挙動になる。

1. example.comへのDNS問い合わせがwwwizer.comのサーバに解決される
2. wwwizer.comにアクセスすると、wwwizer.comのHTTPサーバによりwww.example.comにリダイレクトされる
3. www.example.comへのDNS問い合わせがCNAMEレコードによりAmazon S3に解決される
4. Amazon S3へのDNS問い合わせが走り、S3上の静的ファイルが返却される

参考:  
[Static hosting on Amazon S3 - DNS Configuration](http://stackoverflow.com/questions/8312162/static-hosting-on-amazon-s3-dns-configuration)
