---
layout: blog
title: RSSフィードの購読ボタンの作成と購読者数のチェック
tag: web
---



ブログを書いていると何かと気になるRSSの購読者数。
今日はその購読者数に関わる小ネタを2つほど。

# 購読ボタンの作成

購読者数を増やすにはFeedlyやLivedoor Readerの購読ボタンを設置するのが有効と思われる。
これらのボタンは以下のジェネレータで生成することができる。
いずれもHTMLコードを吐き出すので、それをブログに書き込めば良い。

- [Feedly button](http://www.feedly.com/factory.html)
- [RSS登録バナー](http://reader.livedoor.com/publish/banner/)

# 購読者数のチェック

自分のブログがどれだけ読まれているのか確認したくなるのが人情。
以下のWebサービスやURLによってブログのFeedlyやLivedoor Readerの購読者数を確認することができる。
Feedlyの購読者については、購読者数の推移もわかるFeedly Graphが便利だ。
Livedoor Readerの購読者数はフィードのURLを読み替えて以下のURLにアクセスすればわかる。

- [Feedly Subscribers Checker 2](http://knowledgecolors.net/fsc2.html)
- [Feedly Graph](http://www.feedlygraph.info/)
- [http://rpc.reader.livedoor.com/count?feedlink=フィードのＵＲＬ](http://rpc.reader.livedoor.com/count?feedlink=http://www.xmisao.com/feed.xml)
