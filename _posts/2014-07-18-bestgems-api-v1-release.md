---
layout: blog
title: BestGems API v1を公開した
tag: bestgems
---



拙作のGemのダウンロードランキングサイト[BestGems.org](http://bestgems.org/)のAPIを公開したのでブログに書いておく。

要約するとBestGems.orgが保存しているGemのダウンロード数等を時系列で取得できるAPIとなっている。
RubyGems.orgは時系列のデータを公開していないので、Gemの作者にとっては垂涎の情報と言えるだろう。

仕様は[BestGems API v1 Specification](https://github.com/xmisao/bestgems.org/wiki/BestGems-API-v1-Specification)を参照のこと。

以下は本日時点の仕様の日本語訳である。私の英語が怪しいので本当に日本語訳になっているか不明だが…。

# イントロダクション

- このAPIを使ってプログラムからBestGems.orgのデータを取得できる。
- RESTfulなAPI設計である。HTTPとJSONを使用する。
- アクセスはご自由に。クライアントの認証は存在しない。

# トレンドAPI

- トレンドデータをリクエストされたデータを含むハッシュの配列として返す。
- トレンドは日付で降順ソートされている。
- もし`[GEM_NAME]`が見つからなければ、ステータスコード`404`を返す。

**注意**

トレンドAPIの結果は完全ではない。以下の例が示すように、しばしば結果には抜けがある。完全なデータが返却されることを期待してはならない。

~~~~
[{"date":"2014-01-04", "total_downloads":4567},
 {"date":"2014-01-02", "total_downloads":2345},
 {"date":"2014-01-01", "total_downloads":1234}]
~~~~

## 合計ダウンロード数トレンド

**エンドポイント:**

~~~~
GET - /api/v1/gems/[GEM_NAME]/total_downloads.json
~~~~

**結果の例:**

~~~~
[{"date":"2014-07-16","total_downloads":123},
 {"date":"2014-07-15","total_downloads":456},
 {"date":"2014-07-14","total_downloads":789}]
~~~~

## 日別ダウンロード数トレンド

**エンドポイント:**

~~~~
GET - /api/v1/gems/[GEM_NAME]/daily_downloads.json
~~~~

**結果の例:**

~~~~
[{"date":"2014-07-16","daily_downloads":123},
 {"date":"2014-07-15","daily_downloads":456},
 {"date":"2014-07-14","daily_downloads":789}]
~~~~

## 合計ランキング順位トレンド

**エンドポイント:**

~~~~
GET - /api/v1/gems/[GEM_NAME]/total_ranking.json
~~~~

**結果の例:**

~~~~
[{"date":"2014-07-16","total_ranking":123},
 {"date":"2014-07-15","total_ranking":456},
 {"date":"2014-07-14","total_ranking":789}]
~~~~

## 日別ランキング順位トレンド

**エンドポイント:**

~~~~
GET - /api/v1/gems/[GEM_NAME]/daily_ranking.json
~~~~

**結果の例:**

~~~~
[{"date":"2014-07-16","daily_ranking":123},
 {"date":"2014-07-15","daily_ranking":456},
 {"date":"2014-07-14","daily_ranking":789}]
~~~~
