---
layout: blog
title: BestGems.orgを100倍高速化した話
tag: bestgems
---

# BestGems.orgを100倍高速化した話

昨日、拙作の[BestGems.org](http://bestgems.org/)を新バージョンにアップデートすると共に、新サーバへの移行を完了した。
このアップデートで旧バージョンで課題となっていた各Gemのページの表示速度が100倍高速化した。

## ベンチマーク

以下は簡単なベンチマーク。
10ページのアクセスを行い合計時間を出力する。

~~~~ruby
require 'open-uri'
require 'time'

def download(url)
  print "downloaded #{url}"
  started_at = Time.now
  open(url){|f| f.read }
  result = Time.now - started_at
  puts " at #{result}s"
  result
end

sum = 0
sum += download('http://bestgems.org/gems/rake')
sum += download('http://bestgems.org/gems/rack')
sum += download('http://bestgems.org/gems/thor')
sum += download('http://bestgems.org/gems/activesupport')
sum += download('http://bestgems.org/gems/json')
sum += download('http://bestgems.org/gems/multi_json')
sum += download('http://bestgems.org/gems/mime-types')
sum += download('http://bestgems.org/gems/rails')
sum += download('http://bestgems.org/gems/i18n')
sum += download('http://bestgems.org/gems/builder')
puts sum.to_s
~~~~

旧バージョンでは10ページのアクセスに100秒かかっていた。ひどい…。

~~~~
downloaded http://bestgems.org/gems/rake at 0.249296939s
downloaded http://bestgems.org/gems/rack at 10.556407385s
downloaded http://bestgems.org/gems/thor at 6.902401679s
downloaded http://bestgems.org/gems/activesupport at 10.213957877s
downloaded http://bestgems.org/gems/json at 17.835216018s
downloaded http://bestgems.org/gems/multi_json at 13.798588048s
downloaded http://bestgems.org/gems/mime-types at 9.786475948s
downloaded http://bestgems.org/gems/rails at 10.61230847s
downloaded http://bestgems.org/gems/i18n at 12.881345234s
downloaded http://bestgems.org/gems/builder at 14.351074123s
107.18707172100001
~~~~

新バージョンでは10ページのアクセスが1秒で終わる。早い!

~~~~
downloaded http://bestgems.org/gems/rake at 0.153764902s
downloaded http://bestgems.org/gems/rack at 0.136589385s
downloaded http://bestgems.org/gems/thor at 0.15602094s
downloaded http://bestgems.org/gems/activesupport at 0.117254203s
downloaded http://bestgems.org/gems/json at 0.11654316s
downloaded http://bestgems.org/gems/multi_json at 0.14214575s
downloaded http://bestgems.org/gems/mime-types at 0.14060139s
downloaded http://bestgems.org/gems/rails at 0.153238463s
downloaded http://bestgems.org/gems/i18n at 0.156610276s
downloaded http://bestgems.org/gems/builder at 0.150958813s
1.4237272819999998
~~~~

## アップデート概要

新バージョンは6月頭からこつこつと作って暖めていたもの。
新バージョンと旧バージョンの差分は2032行の追加と349行の削除となっている。
BestGems.orgの`*.rb`と`*.erb`は合計3000行くらいしかないから、実に2/3にあたるコードを変更する書き直しに近いアップデートだった。

高速化の最大のポイントは良かれと思って非正規化していたテーブルを正規化したこと。
次点のポイントはSQLiteからPostgreSQLに移行したこと。

旧バージョンでは合計ダウンロードのトレンドを保持する`total`テーブル、日別ダウンロードのトレンドを保持する`daily`テーブル、注目Gemランキングを保持する`featured`テーブルがあった。
これらのテーブルはJOINを避けるためにGemの名前や説明を重複して保持する頭の悪い構造になっていた。

各Gemのページではダウンロード数やランキングのトレンドデータを表示するため、これらのテーブルのレコードを数百レコード読み込む必要がある。
しかし、これらのテーブルは1レコードのサイズが非常に大きいため、それがボトルネックとなって、ページの生成が非常に遅くなってしまっていたのだった。

新バージョンでは、これらのテーブルを正規化して遥かに小さなテーブルに分割した。
具体的にはGemの名前や説明を保持する`gems`テーブルと、ダウンロード数と注目スコアを保持する`values`テーブルと、ランキングを保持する`rankings`テーブルにした。
むしろこちらの方が当然の構造なのだが、設計した当時は非正規化した方がJOINが不要でテーブル間の整合を考えなくて良い分だけ、実装・速度面でメリットがあると思い込んでいた。
軽率な設計だったと反省している。

ただ正規化したお陰でレコード数が2倍に増えて、今日現在で1億レコード程度の規模になってしまった。
8万近いGemについて、合計ダウンロード数、日別ダウンロード数、合計ランキング順位、日別ランキング順位を保存するので、1日に32万レコードずつレコード数が増えてゆく。
BestGems.orgは地味なサイトでアクセスも1日100PV程度と非常に少ないのだが、普通に動かすだけでも結構スケーラビリティを考える必要がある。

## サーバ移行

BestGems.orgはAmazon EC2で動かしている。

BestGems.orgをリリースした2013年7月当時はまだT2インスタンスがなかったため、旧サーバはt1.microで、EBSもMagneticであった。
今回は料金がt1.microと同額のt2.smallに移行し、EBSも40GBのGeneral Purpose SSDに変更した。

t2.smallではCPUクレジットは余っているので、常にCPUはバーストした状態を維持できている。
t1.microではCPUのstealがひどく、特に1日ごとにRubyGems.orgをスクレイピングするバッチ処理が非常に遅かったのだが、それが改善した。

## まとめ

これまでは性能がネックでBestGems.orgに積極的な機能追加ができなかったのだが、今後はばんばんBestGems.orgに新機能を追加しようと考えている。
とりあえず構想としては以下がある。

- BestGems.org APIの提供
  - BestGems.orgで保存しているダウンロード数や順位のトレンドをJSON等で取得できるAPIを提供する
- Gemの詳細情報の保存
  - 説明の全文、作者、ソースコードのURLなど、従来のBestGems.orgで対象としていなかった情報を保存する
- GitHubの情報の保存
  - 前記の詳細情報を元にGitHubから情報を取得し、Ster数などを新たなランキング指標として利用できるようにする

BestGems.orgはオープンソースであり、機能追加についてはGitHub上で構想・実装してゆくつもり。
気になる人はぜひ[BestGems.orgのリポジトリ](https://github.com/xmisao/bestgems.org)をwatchして欲しい。
