---
layout: blog
title: GCP外のホストからDockerコンテナのログをStackdriver Loggingに送る
tag: ['gcp', 'docker']
---

# サマリ

Google Cloud Platform(GCP)の外にあるホストからDockerのGoogle Cloud Logging driver(`gcplogs`)を使用してコンテナのログをStackdriver Loggingに送信するようにした手順のメモです。
参考としてDocker Composeを使用してコンテナを起動する場合の`docker-compose.yml`の書き方も紹介します。

1. IAMからサービスアカウントに"Logging"の"ログ書き込み"権限を付与する
2. サービスアカウントのキーファイルをGCP外のホストに配置する
3. GCP外のホストでDockerに環境変数(`GOOGLE_APPLICATION_CREDENTIALS`)を追加する(systemd)
4. GCPにログを送信するオプションでDockerコンテナを起動する
5. 参考:Docker Composeからコンテナを起動する

## 前提

コマンドやサービスの仕様は執筆時点のものです。
検証に使用したソフトウェアのバージョンは以下のとおりです。

|ソフトウェア    |バージョン    |備考                                                   |
|:-              |:-            |:-                                                     |
|Docker          |1.12.6        |-                                                      |
|Docker Compose  |1.6.2         |-                                                      |
{: .table .table-striped}

# はじめに

## GCPとStackdriver Loggingについて

GCPのStackdriver Loggingは、AWSでいうCloudWatch Logsに相当するサービスです。
かつてはGoogle Cloud Loggingという名前ですが、2016年9月にStackdriver Loggingに名前が変わりました。(ややこしい!)
GCPの操作ログや、GCPの各サービスが出力したログ、GCE(Google Compute Engine)上のアプリケーションが出力するログの他、GCP以外のホスト、果てはAWSからもログを出力してStackdriver Loggingに集約することができます。

## Dockerとロギングドライバについて

Dockerはロギングドライバという仕組みでログの出力形式や出力先を切り替えることができます。
このうちGoogle Cloud Logging driver(`gcplogs`)を使用すると、コンテナが出力するログをDockerが直接Stackdriver Loggingに送信できます。

GCEインスタンスからであればGoogle Cloud Logging driverは[インスタンスメタデータ](https://cloud.google.com/compute/docs/storing-retrieving-metadata)から送信に必要な情報を取得する仕組みなので、Dockerのログドライバに`gcplogs`を指定するだけでStackdriver Loggingにログを送信することができます。

一方GCEインスタンス以外のホストからだとインスタンスメタデータは使用できません。
このためDockerにGCPの認証情報と送信先のプロジェクトIDを教えてやらないと、Stackdriver Loggingにログを送信することはできません。
このメモはその設定方法をまとめたものです。

# 1. IAMからサービスアカウントに"Logging"の"ログ書き込み"権限を付与する

ログ送信する使用するGCPのサービスアカウントにIAMから権限を付与します。
[Google Cloud ConsoleのIAMのページ](https://console.cloud.google.com/iam-admin/iam)でサービスアカウントに"Logging"の"ログ書き込み"権限を付与して下さい。
これでこのサービスアカウントを使用してGoogle Stackdriverにログを送信することができるようになります。

# 2. サービスアカウントのキーファイルをGCP外のホストに配置する

サービスアカウントのキーファイルをGCP外のホストに配置します。
もしキーを作成していない場合は[Google Cloud Consoleのサービスアカウントのページ](https://console.cloud.google.com/iam-admin/serviceaccounts)から、キーを作成してキーファイルをダウンロードすることができます。

配置したキーファイルはDockerデーモンが使用します。
(`docker`コマンドを実行してコンテナを立ち上げる一般ユーザではありません)
Dockerデーモンはrootユーザで実行しますので、キーファイルに安全に所有者とパーミッションを設定するなら、所有者は`root`でパーミッションは`400`にできます。

# 3. GCP外のホストでDockerに環境変数(`GOOGLE_APPLICATION_CREDENTIALS`)を追加する(systemd)

Dockerデーモンがキーファイルの認証情報を使用してStackderiverにログを送信できるようにする設定を行います。

大抵の環境ではsystemd経由でDockerデーモンを起動していると思います。
systemdでDockerデーモンの設定を行う方法は環境により異なります。
ご自身の環境の設定方法は以下のDockerの公式ドキュメントを参照して下さい。

* [Docker デーモンのオプション変更](http://docs.docker.jp/engine/admin/systemd.html#custom-docker-daemon-options)

私の環境では以下のファイルがsystemdのDockerの設定のファイルでした。
このファイルを編集します。

```
/etc/systemd/system/multi-user.target.wants/docker.service
```

`[Service]`セクションに`Environment=`で`GOOGLE_APPLICATION_CREDENTIALS`環境変数を追加します。
値はキーファイルへのフルパスを指定します。

```
[Service]
# いろいろな設定が書いてある

# GCP Credentials
Environment="GOOGLE_APPLICATION_CREDENTIALS=/path/to/your/credentials.json"
```

設定ファイルの編集が済んだらsystemdに変更後の内容を読み込ませます。

```
systemctl daemon-reload
```

systemd上で設定が反映されているかは以下のように確認できます。

```
systemctl show docker
```

確認できたらDockerデーモンを再起動して下さい。

```
service docker restart
```

# 4. GCPにログを送信するオプションでDockerコンテナを起動する 

以上でGCP外のホストのDockerデーモンからGoogle Cloud Logging Driverを使用して、Stackdriver Loggingにログが出力できるようになりました。

実際にログをStackdriverに出力するには、コンテナの起動時にログドライバとプロジェクトIDの指定が必要です。
`docker run`でコンテナを起動する場合は以下のとおりです。
`<プロジェクトID>`はご自身のGCPのプロジェクトIDに、`<イメージ名>`は起動するDockerイメージ名に置き換えて下さい。

```
docker run --log-driver=gcplogs --log-opt gcp-poject=<プロジェクトID> <イメージ名>
```

`--log-driver=gcplogs`はログドライバに`gcplogs`(Google Cloud Logging driver)を使用する設定です。

`--log-opt gcp-poject=プロジェクトID`はGCPのプロジェクトIDの指定です。
GCP外のホストだと、インスタンスメタデータからプロジェクトIDが取得できないため、プロジェクトIDの指定は必須です。

Google Cloud Logging driverについては以下のDockerの公式ドキュメントを参照して下さい。

* [Google Cloud Logging driver](https://docs.docker.com/engine/admin/logging/gcplogs/)

# 5. 参考:Docker Composeからコンテナを起動する

前節の`docker run`に相当する`docker-compose.yml`を記述します。
Composeファイルのバージョンによって指定が異なります。

v1の場合は以下のとおり`log_driver`と`log_opt`で指定します。

```
  log_driver: gcplogs
  log_opt:
    gcp-project: "<プロジェクトID>"
```

未検証ですがv2およびv3では以下のとおり`logging`以下の`driver`, `options`で指定するとのことです。

```
  logging:
    driver: gcplogs
    options:
      gcp-project: "<プロジェクトID>"
```

ロギングドライバ周りのComposeファイルの記述については以下のDockerの公式ドキュメントを参照して下さい。

* [Compose file version 1 reference](https://docs.docker.com/compose/compose-file/compose-file-v1/#logdriver)
* [Compose file version 2 reference](https://docs.docker.com/compose/compose-file/compose-file-v2/#logging)
* [Compose file version 3 reference](https://docs.docker.com/compose/compose-file/#logging)
