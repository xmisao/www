---
layout: default
title: Node.jsでGoogle Maps APIのジオコーディングを利用する
---

# Node.jsでGoogle Maps APIのジオコーディングを利用する

geocoderライブラリを使うとGoogle Maps API v3.0で提供されるジオコーディングをNode.jsから利用できる。

Webアプリケーションに組み込むのはもちろん、住所の一覧を一括で座標に変換するなど、いろいろ応用できる。

## インストール

    npm install geocoder

## 使い方

ジオコーディング、逆ジオコーディングともに取得できるデータはGoogle Maps APIのデータそのまま。

    var geocoder = require('geocoder');
     
    // ジオコーディング(住所から座標を得る)
    geocoder.geocode("東京都港区三田2-16-4", function ( err, data ) {
			// 任意の処理
    });
     
    // 逆ジオコーディング(座標から住所を得る)
    geocoder.reverseGeocode(35.6480801, 139.7416143, function ( err, data ) {
			// 任意の処理
    });
     
    // センサの有効化
    geocoder.reverseGeocode(35.6480801, 139.7416143, function ( err, data ) {
			// 任意の処理
    }, { sensor: true });

参考:
[Geocoding With Node.js](http://blog.stephenwyattbush.com/2011/07/16/geocoding-with-nodejs)

## おまけ

これで[ラーメン二郎マップ](/jirorian/)を作りました。
