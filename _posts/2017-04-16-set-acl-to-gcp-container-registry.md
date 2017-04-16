---
layout: blog
title: GCPのContainer Registryに格納したDockerイメージにACLでアクセス権を設定する
tag: ['gcp', 'docker']
---

# サマリ

Google Cloud Platform(GCP)の外にあるホストからContainer Registry(GCR)に格納したプライベートDockerイメージをpullできるようにした方法のメモです。以下の4ステップで実現できました。

1. Dockerイメージにアクセスするための専用のサービスアカウントを作成する
2. Dockerイメージが格納されるGoogle Cloud Storage(GCS)のバケットに対してACLを設定する
3. GCP外のホストにサービスアカウントの認証情報を設定する
4. GCP外のホストから`gcloud docker -- pull`してイメージを取得する

この手順はGCRの公式ドキュメントの[アクセス制御](https://cloud.google.com/container-registry/docs/access-control)を参考に、プライベートなDockerイメージを参照できるようにした手順になります。

# 前提

以下の前提があります。

- GCRを既に使用している
- GCP SDKのコマンド(`gcloud`と`gsutil`)がインストールされており操作対象のプロジェクトにアクセスできるよう設定済み
- GCP外のホストにGCP SDKのコマンド(`gcloud`)がインストール済み
- GCP外のホストにDocker環境が構築済み

コマンドやサービスの仕様は執筆時点のものです。

検証に使用したソフトウェアのバージョンは以下のとおりです。

|ソフトウェア    |バージョン    |備考                                                   |
|:-              |:-            |:-                                                     |
|Google Cloud SDK|145.0.0       |-                                                      |
|Docker Client   |1.12. 6       |-                                                      |
|Docker Server   |1.12. 6       |-                                                      |
{: .table .table-striped}

# 1. Dockerイメージにアクセスするための専用のサービスアカウントを作成する

[サービスアカウント](https://console.cloud.google.com/iam-admin/serviceaccounts/)のページからサービスアカウントを作成します。この時点では権限は何も付与しなくて良いです。

サービスアカウントのキーを作成してキーファイルを保存しておきます。
このキーファイルをGCP外のホストに配布して認証に使用します。

この後の設定で使用するのでサービスアカウントIDを控えておきます。
サービスアカウントIDは以下のような形式です。

```
サービスアカウント名@プロジェクトID.iam.gserviceaccount.com
```

# 2. Dockerイメージが格納されるGoogle Cloud Storage(GCS)のバケットに対してACLを設定する

GCRそのものに権限設定はありません。
GCRがDockerイメージの格納先として使用するGCSのバケットとそのオブジェクトに対して権限を設定します。

GCRが使用するGCSのバケット名は以下の形式です。
プロジェクトでGCRを有効化していると作られているはずです。
[GCSのページ](https://console.cloud.google.com/storage/)から確認して下さい。

```
リージョン.artifacts.プロジェクトID.appspot.com 
```

このバケットとバケット内のオブジェクトに対して、先ほど作成したサービスアカウントが、既存のDockerイメージと今後格納するDockerイメージの両方にアクセスできるよう、読み込み専用のACLを設定します。

GCPコンソールからもできますがバケット内のオブジェクトに再帰的にACLを設定することができないようなので、CLIの`gsutil`を使用してACLを設定します。

## 念の為:設定前のACLのダウンロード

念の為、設定前のバケットのACLをダウンロードして、書き戻すことができるようにしておくこともできます。

### ACLのダウンロード

以下のコマンドを実行するとACLの設定が記述されたテキストファイルがダウンロードできます。
リダイレクトして保存しておきます。

```
gsutil acl get gs://リージョン.artifacts.プロジェクトID.appspot.com > acl.txt
gsutil defacl get gs://リージョン.artifacts.プロジェクトID.appspot.com > defacl.txt
```

### ACLの書き戻し

このテキストファイルがあれば以下のようにしてACLを書き戻すことができます。

```
gsutil acl set acl.txt gs://リージョン.artifacts.プロジェクトID.appspot.com
gsutil defacl set defac.txt gs://リージョン.artifacts.プロジェクトID.appspot.com
```

## 読み込み権限の追加

バケットとバケット内のオブジェクトに対してサービスアカウントの読み込み専用の権限を設定します。

`gsutil acl`はGCSのACLを操作するコマンドです。
`-r`が再帰的な変更、`-u アカウント:権限`はユーザ単位の権限設定を行うオプションです。

以下はバケットとバケット内のオブジェクトにサービスアカウントで読み込みの権限を追加するコマンドの例です。

```
gsutil acl ch -r -u サービスアカウント名@プロジェクトID.iam.gserviceaccount.com:READ gs://リージョン.artifacts.プロジェクトID.appspot.com 
```

同様に今後バケット内に作成されるオブジェクトに対するデフォルトACLも設定します。
コマンドに`gsutil defacl`を使用し`-r`が無くなるだけです。(デフォルトACLの設定はバケット単位)

```
gsutil defacl ch -u サービスアカウント名@プロジェクトID.iam.gserviceaccount.com:READ gs://リージョン.artifacts.プロジェクトID.appspot.com 
```

詳細は`gsutil`の公式ドキュメントを参照して下さい。

* [https://cloud.google.com/storage/docs/gsutil/commands/acl](https://cloud.google.com/storage/docs/gsutil/commands/acl)
* [https://cloud.google.com/storage/docs/gsutil/commands/defacl](https://cloud.google.com/storage/docs/gsutil/commands/defacl)

# 3. GCP外のホストにサービスアカウントの認証情報を設定する

キーファイルをGCP外のホストに転送しておきます。
そして以下のように`gcloud auth activate-service-account`コマンドを使用して、認証情報を登録します。

```
gcloud auth activate-service-account サービスアカウント名@プロジェクトID.iam.gserviceaccount.com --key-file キーファイル.json --project プロジェクトID
```

詳細は`gcloud auth activate-service-account`の公式ドキュメントを参照して下さい。

* [https://cloud.google.com/sdk/gcloud/reference/auth/activate-service-account](https://cloud.google.com/sdk/gcloud/reference/auth/activate-service-account)

# 4. GCP外のホストから`gcloud docker -- pull`してイメージを取得する

以上の設定が終わるとGCRのDockerレジストリからpullができます。
正しく設定できていれば、以下のように`gcloud docker -- pull`すると、狙い通りイメージがpullできるはずです。

```
gcloud docker -- pull リージョン.gcr.io/プロジェクトID/タグ
```

詳細は`gcloud docker`の公式ドキュメントを参照して下さい。

* [https://cloud.google.com/sdk/gcloud/reference/docker](https://cloud.google.com/sdk/gcloud/reference/docker)

# 補足:`gcloud docker`を使用せずにDockerイメージをpullする

私は試していませんが`docker login`で`https://gcr.io`にログインする認証情報を設定しておくことで、`gcloud docker`を使用せずに`docker`コマンドでGCRのレジストリにアクセスすることもできるようです。

GCRのリファレンスの[高度な認証方式](https://cloud.google.com/container-registry/docs/advanced-authentication?hl=ja)と、[docker loginコマンドのリファレンス](https://docs.docker.com/engine/reference/commandline/login/)を参照して下さい。
