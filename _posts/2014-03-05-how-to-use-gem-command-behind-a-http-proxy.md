---
layout: blog
title: HTTPプロキシ越しにgemコマンドを使うにはHTTP_PROXY環境変数を設定する
tag: ruby
---



HTTPプロキシ下にあるネットワークから`gem`コマンドを使ってgemパッケージのダウンロードを行うには、`HTTP_PROXY`環境変数を設定してやる。
環境変数に設定するHTTPプロキシの書式は、プロキシが認証なし、認証ありの場合でそれぞれ以下のとおり。

- 認証なしプロキシ
  - `http://ホスト:ポート/`
- 認証ありプロキシ
  - `http://ユーザ名:パスワード@ホスト:ポート/`

一例としてプロキシサーバのホストがproxy.example.comでポートが8080で認証なしの場合は以下のようにする。

~~~~
export HTTP_PROXY=http://proxy.example.com:8080/
gem install x2ch
~~~~

もしくは

~~~~
export HTTP_PROXY=http://proxy.example.com:8080/ gem install x2ch
~~~~

`gem`コマンドに限らず、環境変数`HTTP_PROXY`または`http_proxy`は、HTTPプロキシを指定する環境変数として広く使われている。
manやヘルプに書かれていなくても、コマンドによっては使えることがある。ものは試しだ。

参考

- [How do I update Ruby Gems from behind a Proxy (ISA-NTLM)](http://stackoverflow.com/questions/4418/how-do-i-update-ruby-gems-from-behind-a-proxy-isa-ntlm)
