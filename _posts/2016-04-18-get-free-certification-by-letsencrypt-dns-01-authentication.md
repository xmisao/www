---
layout: blog
title: Let's EncryptのDNS-01を使用して無料のSSL証明書をWebサーバなしで取得する
tag: letsencrypt
---



# サマリ

* DNSによる認証(DNS-01)でドメインを認証し、Let's EncryptからSSL証明書を取得することができたので、メモとしてまとめます。
* クライアントはサードパーティ製の[letsencrypt.sh](https://github.com/lukas2511/letsencrypt.sh)を使用します。
* DNSで認証するには、ドメインに認証専用のサブドメインを追加し、サブドメインに対してTXTレコードを設定できる必要があります。
* HTTPによる認証ではないため、Webサーバは必要ありません。このためHTTPによる認証と比較してとても簡単に証明書を取得できます。

# HTTPによる認証と手間なところ

無料でDVのSSL証明書を取得できる[Let's Encrypt](https://letsencrypt.org/)が話題です。

Let's Encryptで証明書の取得を行う場合、HTTPを使用してドメインを認証を方法(HTTP-01)が紹介されることが多いようです。
この方法でドメインを認証する仕組みは、ざっくり説明すると以下のとおりです。

1. クライアントからLet's Encryptに任意のドメイン(a)の証明書をリクエストする
2. Let's Encryptはレスポンスでクライアントにトークンのファイル名(A)とトークン(B)を送信する
3. ドメイン(a)を解決(\*)してアクセスできるWebサーバの所定のディレクトリ(`/.well-known`)以下に、ファイル名(A)でトークン(B)を記入したファイル(b)を配置する
4. クライアントからLet's Encryptにドメイン(a)の認証チャレンジをリクエストする
5. Let's Encryptは認証チャレンジでドメイン(a)にHTTPでアクセスしファイル(b)を取得してトークンが正しければ認証は成功とみなす
6. 認証が成功した場合のみLet's Encryptは認証チャレンジのレスポンスでクライアントにドメイン(a)の証明書を送付する

(\*)私が確認した限りでは、Aレコードの他、CNAMEで解決することも可能でした。

このようにLet's Encryptで簡単に証明書が取得できます。ヨカッタヨカッタ。
と、言いたいところですが、実際に証明書を取得しようとすると、以下の問題があり、手間です。

* Webサーバを既に運用中の場合、認証チャレンジのためにWebサーバでトークンを公開する必要がある。
* Webサーバを運用していない場合は、認証チャレンジのためにWebサーバを立てて、トークンにアクセスできるようにする必要がある。
* 何らかの方法でWebサーバを負荷分散している場合、どうアクセスされても認証チャレンジが成功するようにする必要があり、運用によっては難しい。

これらの問題は、公式の`letsencrypt`コマンドのプラグインにより、ある程度解決されています。
しかし、現時点では発展途上で、使用しているWebサーバの種類や、設定によって、ひと手間かかるケースが多いように思います。

# DNSによる認証

Let's Encryptと通信し証明書を取得するための仕様は[Automatic Certificate Management Environment(ACME)](https://letsencrypt.github.io/acme-spec/)で公開されています。
この仕様を読むと、実はHTTPではなくDNSを使用して、証明書を取得することも可能です。
Let's Encryptは2016年1月20日に、[DNSによる認証チャレンジをサポート](https://letsencrypt.org/upcoming-features/)しました。

証明書を取得する流れは、認証チャレンジをDNSで行うだけで、HTTPを使用した方法と同じです。
認証チャレンジは、認証対象のドメインのサブドメイン`_acme-challenge`の、TXTレコードにトークンが設定されているかで行います。
例えば`example.com`の証明書を取得する場合、`_acme-challenge.example.com`というサブドメインを追加し、TXTレコードにトークンを設定する必要があります。
このためDNSによる認証を使用するには、以下の2点が要件です。

1. 認証するドメインにサブドメイン(`_acme-challenge`)が追加できること
2. サブドメインのTXTレコードとして、任意の値(トークン)が設定できること

## クライアント

現在、Let's Encrypt公式の`letsencrypt`コマンドは、DNSによる認証をサポートしていません。
GitHubで[プルリクエスト](https://github.com/letsencrypt/letsencrypt/pull/2061)はされていますが、まだマージされていません。

このため、DNSによる認証をサポートしている[letsencrypt.sh](https://github.com/lukas2511/letsencrypt.sh)を使用します。
名前のとおりシェル(bash)スクリプトなので、`bash`が必要です。
また、内部の処理ではコマンドを使用するため、以下のコマンドが使用可能である必要があります。

* `openssl`
* `sed`
* `grep`
* `mktemp`
* `curl`

## letsencrypt.shのインストールとセットアップ

公式のインストール手順はありませんが、シェルスクリプトなのでGitHubからcloneしてくるだけで使用できます。
なお動作確認には本エントリ執筆時点のmasterブランチ(コミットID b0e2ecde5f8d3e26687c5cfdd6c54963437fa0f9)を使用しています。

~~~~
git clone https://github.com/lukas2511/letsencrypt.sh.git
~~~~

cloneしたディレクトリに移動します。
以降では、このディレクトリ下で作業します。

~~~~
cd letsencrypt.sh
~~~~

letsencrypt.shでは、認証チャレンジをフックするシェルスクリプトを、予め用意する必要があります。
豊富なフックスクリプトの例が[Examples for DNS 01 hooks](https://github.com/lukas2511/letsencrypt.sh/wiki/Examples-for-DNS-01-hooks)で公開されており、Route53等と連携して自動的に認証を行うことも可能です。

本エントリでは、letsencrypt.shで証明書をリクエストした際にトークンを出力し、手動でDNSの設定を行った後、認証チャレンジを行うことにします。

フックスクリプトのサンプルは、cloneしたディレクトリの`docs/examples/hook.sh.example`にあります。
以下のソースは、下記の挙動になるように、サンプル改変したものです。(コメント等は除いています)

* 認証チャレンジでトークンを標準出力する
* トークンの標準出力後にエンターが入力されるまで待つ

~~~~ bash
#!/usr/bin/env bash

function deploy_challenge {
    local DOMAIN="${1}" TOKEN_FILENAME="${2}" TOKEN_VALUE="${3}"

    echo "Set TXT record of _acme-challenge.$DOMAIN to $TOKEN_VALUE"
    read
}

function clean_challenge {
    local DOMAIN="${1}" TOKEN_FILENAME="${2}" TOKEN_VALUE="${3}"
}

function deploy_cert {
    local DOMAIN="${1}" KEYFILE="${2}" CERTFILE="${3}" FULLCHAINFILE="${4}" CHAINFILE="${5}" TIMESTAMP="${6}"
}

function unchanged_cert {
    local DOMAIN="${1}" KEYFILE="${2}" CERTFILE="${3}" FULLCHAINFILE="${4}" CHAINFILE="${5}"
}

HANDLER=$1; shift; $HANDLER $@
~~~~

これをカレントディレクトリ内に`hook.sh`として保存し、実行権限を付加(`chmod +x hook.sh`)します。

## letsencrypt.shの実行

DNSにより認証チャレンジを行い、証明書を取得するには以下のようにします。
`example.com`は証明書を取得したいご自身のドメインに読み替えて下さい。

~~~~
./letsencrypt.sh -c -d example.com --challenge dns-01 -k ./hook.sh
~~~~

以下のように出力されます。
最後の行が認証用にTXTレコードを設定するドメインと、TXTレコードに設定するトークンです。
フックスクリプトで`read`していますので、入力待ちになります。

~~~~
#
# !! WARNING !! No main config file found, using default config!
#
Processing example.com
 + Signing domains...
 + Generating private key...
 + Generating signing request...
 + Requesting challenge for example.com...
Set TXT record of _acme-challenge.example.com to ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQ
~~~~

このタイミングで、お使いのDNSサーバで`_acme-challenge.example.com`のTXTレコードにトークンを設定して下さい。

念の為、正しくトークンが設定されてるかを確認したい場合は、`dig`コマンドなどを使用して下さい。
以下は`dig`コマンドで`_acme-challenge.example.com`の全レコード(`any`)をDNSサーバ`8.8.8.8`に問い合わせる例です。

~~~~
dig _acme-challenge.example.com any @8.8.8.8
~~~~

ANSWER SECTIONに、TXTレコードが存在し、値にトークンが出てきているか確認して下さい。
お使いのDNSサーバによっては、変更から反映まで時間がかかる、TTLが長くてキャッシュが残っている、といったことがあるかも知れません。

~~~~
; <<>> DiG 9.10.3-P4-Debian <<>> _acme-challenge.example.com any @8.8.8.8
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 51300
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 512
;; QUESTION SECTION:
;_acme-challenge.example.com. IN ANY

;; ANSWER SECTION:
_acme-challenge.example.com. 9 IN TXT    "ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQ"

;; Query time: 346 msec
;; SERVER: 8.8.8.8#53(8.8.8.8)
;; WHEN: Tue Apr 19 01:31:33 JST 2016
;; MSG SIZE  rcvd: 119
~~~~

TXTレコードが正しく設定されているようなら、エンターを押して入力待ちを抜けます。
Let's Encryptが正しく認証できれば、出力は以下のようになります。

~~~~
 + Responding to challenge for example.com...
 + Challenge is valid!
 + Requesting certificate...
 + Checking certificate...
 + Done!
 + Creating fullchain.pem...
 + Done!
~~~~

## 証明書の確認

完了すると`cert`ディレクトリのドメイン名のディレクトリに、以下のようなファイルができています。

~~~~
certs
certs/example.com
certs/example.com/cert-1460996835.pem
certs/example.com/fullchain.pem
certs/example.com/cert-1460996888.pem
certs/example.com/cert-1460996898.pem
certs/example.com/cert-1460996888.csr
certs/example.com/privkey-1460996949.pem
certs/example.com/cert-1460996949.csr
certs/example.com/cert.pem
certs/example.com/privkey-1460996888.pem
certs/example.com/chain.pem
certs/example.com/cert-1460996949.pem
certs/example.com/cert-1460996898.csr
certs/example.com/privkey.pem
certs/example.com/chain-1460996949.pem
certs/example.com/privkey-1460996835.pem
certs/example.com/cert-1460996835.csr
certs/example.com/cert.csr
certs/example.com/privkey-1460996898.pem
certs/example.com/fullchain-1460996949.pem
~~~~

このうち以下のファイルはシンボリックリンクになっています。
(証明書を再発行すると、シンボリックリンクが差し替わります)
よく使用するのは`fullchain.pem`と`privkey.pem`でしょうか。

* cert.csr
* cert.pem
* chain.pem
* fullchain.pem
* privkey.pem

証明書チェーンとサーバ証明書を`oepnssl`で検証してみましょう。

~~~~
openssl verify -CAfile fullchain.pem cert.pem
~~~~

~~~~
cert.pem: OK
~~~~

ちゃんと認証できていますね!

Webサーバなしで、SSL証明書を取得することができました。

# その他、本エントリで説明しなかった箇所

## 証明書の安全性

証明書の安全性は大丈夫ですか。
鍵の強度や、暗号アルゴリズムについては、本エントリでは説明していません。
セキュアな証明書になっているかは、十分に注意し、ご自身で判断して下さい。

## 定期的な証明書の更新(renew)

Let's Encryptの証明書の期限は90日間です。
業者から購入できるSSL証明書と比較して、短い期間になっています。
実際にLet's EncryptのSSL証明書を使用するには、一連の手順を自動化する必要に迫られます。

## 証明書の配布

証明書を使用するサーバに、証明書をどう配布するかは、本エントリでは扱いませんでした。
まだいろいろな方が試行錯誤している段階と思います。
