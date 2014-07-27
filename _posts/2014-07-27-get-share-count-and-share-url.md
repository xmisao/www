---
layout: blog
title: ソーシャルメディアのシェア数取得とシェア用のURLまとめ
tag: web
---

# ソーシャルメディアのシェア数取得とシェア用のURLまとめ

## はじめに

ソーシャルメディアへの共有ボタンを自作したい際などに、シェア数を取得するURL・ページをシェアする用のURLをまとめる。
対象とするソーシャルメディアは、はてなブックマーク、Google+、Facebook、Twitterの4つ。

## シェア数取得

いずれもURLにシェア数を取得したいページのURLを連結するとシェア数が取得できる。

### はてなブックマーク

URL: *http://api.b.st-hatena.com/entry.count?url=*

特にフォーマットは無く、単純にブックマーク数が文字列で返る。
以下はレスポンスの例。

~~~~
1
~~~~

### Google+

残念ながらGoogle+の+1数を取得する方法はない。

公式のGoogle+ボタンを読み込んで、その内容から+1数を取得する荒業はあるらしい。

### Facebook

URL: *https://graph.facebook.com/*

JSONが返る。
`shares`の値がシェア数である。
1回もシェアされていない場合、`shares`のキー自体が存在しない事に注意。
以下はレスポンスの例。

~~~~
{
   "id": "http://www.xmisao.com/2013/11/10/linux-kill-signals.html",
   "shares": 30
}
~~~~

### Twitter

URL: *http://urls.api.twitter.com/1/urls/count.json?url=*

JSONが返る。
`count`の値がtweet数である。
1回もtweetされていない場合は`0`が入っている。
以下はレスポンスの例。

~~~~
{"count":1,"url":"http:\/\/www.xmisao.com\/"}
~~~~

## シェア用URL

いずれもURLにシェアさせたいページのURLを連結するとシェア用のページを表示できる。

### はてなブックマーク

URL: *http://b.hatena.ne.jp/append?*

はてなブックマークに追加するページを表示する。

### Google+

URL: *http://plus.google.com/share?url=*

Google+に投稿するページを表示する。
URLのみ入力された状態で、本文は空欄である。

### Facebook

URL: *https://www.facebook.com/sharer/sharer.php?u=*

Facebookでシェアするページを表示する。
URLのみ入力された状態で、本文は空欄である。

### Twitter

URL: *http://twitter.com/home?status=*

Twitterに投稿するページを表示する。
TwitterにはURLを特別にシェアする仕組みはないので、あくまで任意の内容をtweetさせるもの。
タイトルが必要な場合は、タイトルもURLエンコードして含めてやる必要がある。

## おわりに

このブログの共有ボタンを自作のものに切り替えるために調べた。
ソーシャルメディア毎にそれぞれ癖があって、なかなか使いづらい。
特にGoogle+のシェア数がAPIで取得できないのはどうにかならないのか。
