---
layout: blog
title: AWSの性能レポーティングツール AWS-Reportingを作った
tag: ['aws-reporting', 'aws']
---

# AWSの性能レポーティングツール AWS-Reportingを作った

AWSの性能レポーティングツールであるAWS-Reportingを公開した。
8月頭からコツコツと作っていたもの。

- [xmisao/aws-reporting](https://github.com/xmisao/aws-reporting)

## 概要

AWS-ReportingはAWSの性能レポーティングツールである。
Amazon CloudWathcからデータを取得して、HTML形式でレポートを出力する。
スクリーンショットは以下のような感じ。

![Screenshot](http://aws-reporting.xmisao.com/screenshot.png)

## デモ

レポートのサンプルには以下からアクセスできる。

- [http://aws-reporting.xmisao.com/demo/](http://aws-reporting.xmisao.com/demo/)

## インストール

gemとして公開しているため、`gem install`でインストールできる。

~~~~
gem install aws-reporting
~~~~

## 使い方

### 設定

`aws-reporting config`コマンドを実行する。
AWSのアクセスキーIDとシークレットアクセスキーを設定する。
もちろんIAMも使える。

~~~~
aws-reporting config
~~~~

### レポート生成

`aws-reporting run`コマンドを実行する。
このコマンドにより、AWS-ReportingはAmazon CloudWatchからデータを取得し、`/path/to/report`にHTML形式でレポートを保存する。

~~~~
aws-reporting run /path/to/report
~~~~

### レポート確認

Firefoxを使っているなら、HTTPサーバなしにレポートを開いて直接参照することができる。
他のブラウザのために、AWS-Reportingは簡単なHTTPサーバ機能を備えている。

`aws-reporting serve`コマンドを実行する。
HTTPサーバが立ち上がり`/path/to/report`が公開される。
デフォルトのURLは`http://localhost:23456/`である。

~~~~
aws-reporting serve /path/to/report
~~~~

## 便利な使い方

### レポート生成をcronでスケジュールする

デイリーでレポートを出力するには`crontab`で以下のように設定すると良い。

~~~~
0 0 * * * aws-reporting run /path/to/report/`date +"\%Y\%m\%d"`
~~~~

レポートは`/path/to/report/20140824`のように保存される。

### HTTPサーバでレポートを公開する

例えば、nginxのバーチャルホスト設定は、以下のようになる。

~~~~
server {
  listen 80;
  server_name your.domain;

  root /path/to/report;
  index index.html;
}
~~~~
