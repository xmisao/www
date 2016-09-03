---
layout: blog
title: debian wheezyにelasticsearchをインストール
tag: ['linux', 'elasticsearch']
---



debian weheezyにelasticsearchをインストールするメモ。

# 準備

elasticsearchにはJavaが必要である。
事前にインストールしておく。
OpenJDK 7をインストールする場合は以下。

~~~~
apt-get install openjdk-7-jre
~~~~

# ダウンロード

[公式サイト](http://www.elasticsearch.org/overview/elkdownloads/)から最新版のelasticsearchをダウンロードする。
本エントリ執筆時点の最新版は1.1.1であった。

~~~~
wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.1.1.tar.gz 
~~~~

# インストール

elasticsearchは圧縮ファイルを展開するだけで使用可能になる。
今回は`/opt/elasticsearch`にelasticsearchを配置することにする。

~~~~
tar zxvf elasticsearch-1.1.1.tar.gz
mv elasticsearch-1.1.1 /opt/elasticsearch
~~~~

# 実行

`bin`以下にある`elasticsearch`を実行して動作することを確認する。

~~~~
cd /opt/elasticsearch
bin/elasticsearch
~~~~

elasticsearchが起動すると9200番でHTTPサーバが立ち上がる。
以下のように`curl`でアクセスして応答が帰ってくれば成功だ。

~~~~
curl -X GET http://localhost:9200/
~~~~

~~~~
{
  "status" : 200,
  "name" : "Darkhawk",
  "version" : {
    "number" : "1.1.1",
    "build_hash" : "f1585f096d3f3985e73456debdc1a0745f512bbc",
    "build_timestamp" : "2014-04-16T14:27:12Z",
    "build_snapshot" : false,
    "lucene_version" : "4.7"
  },
  "tagline" : "You Know, for Search"
}
~~~~
