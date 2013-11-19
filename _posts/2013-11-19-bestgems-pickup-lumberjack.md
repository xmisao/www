---
layout: blog
title: BestGems Pickup! 第7回 「lumberjack」
tag: bestgems_pickup
---

# BestGems Pickup! 第7回 「lumberjack」

拙作の[BestGems](http://bestgems.org/)から注目のGemを紹介するエントリー。第7回は「[lumberjack](https://rubygems.org/gems/lumberjack)」を取り上げる。

## 概要

lumberjackはログ出力ユーティリティだ。シンプルで高機能かつ高速な実装を標榜しており、Ruby標準のLoggerやActiveSupport::BufferedLoggerを置き換えられるとしている。

なお"lumberjack"とは「木こり」の意味である。この名前は"log"が「丸太」の意味を持つことにかけていると思われる。

lumberjackは今日現在、合計ダウンロードランキング214位、デイリーダウンロードランキング158位につけている。人気上昇中のgemと言える。

## インストール

    gem install lumberjack

## 使用例

Lumberjackの使いかたは、標準ライブラリの`Logger`と良く似ている。基本的には、`Lumberjack::Logger`を生成し、あとはそのインスタンスのログ出力メソッドを呼び出すだけである。詳しい使い方は、次の解説で説明する。

~~~~
require 'lumberjack'
include Lumberjack

logger = Logger.new("logs/application.log")
logger.info("Begin request")
logger.debug(request.params)
begin
  # do something
rescue => exception
  logger.error(exception)
  raise
end
logger.info("End request")
~~~~

## 解説

Lumberjackの機能をもう少し詳しく見ていこう。

### Loggerの生成

`Logger`のコンストラクタには、ログの出力先と、オプションを与える。どちらも省略が可能で、デフォルトでは`STDOUT`にログレベル`INFO`以上のログが出力される。

~~~~
logger = Lumberjack::Logger.new()
~~~~

以下は`application.log`ファイルに、`DEBUG`以上のログを出力する`Logger`を生成する例である。

~~~~
logger = Lumberjack::Logger.new("application.log", {:level => Lumberjack::Serverity.DEBUG})
~~~~

### ログレベル

Lumberjackのログレベルは、最も軽微なDEBUGから最も重大なUNKNOWNまで、以下の6段階がある。

|レベル|意味|
|:-|:-|
|0|DEBUG|
|1|INFO|
|2|WARN|
|3|ERROR|
|4|FETAL|
|5|UNKNOWN|
{: .table .table-striped}

`Logger`に設定したログレベル以上のレベルのメッセージだけが、実際に出力される仕組みだ。

### ログ出力

`Logger`インスタンスのログ出力用のメソッドは、ログレベルに応じてそれぞれ以下のとおりである。

~~~~
logger.debug("DEBUG message")
logger.info("INFO message")
logger.error("ERROR message")
logger.fetal("FETAL message")
logger.unknown("UNKNOWN message")
~~~~

### 出力内容

ログに出力されるメッセージには、以下のメタデータが付与される。

- serverity -- ログのレベル
- time -- メッセージが記録された時刻
- program name -- ログを出力したプログラムの名前
- process id -- ログを出力したプロセスのID(pid)
- unit of work id -- 処理単位のユニークな12バイト長の16進数値

### 処理単位

Lumberjackでは、処理をまとまりを処理単位として指定できる。処理単位は`Lumberjack.unit_of_work`ブロックで指定する。

ログには処理単位ごとにログにユニークなIDが記録される。適切に処理単位を使ってやることで、プログラム中のログを出力した箇所が特定しやすくなる。

~~~~
Lumberjack.unit_of_work do
  logger.info("Begin request")
  yield
  logger.info("End request")
end
~~~~

### 高度なロギング

Lumberjackには、より高度なログ出力機能が存在する。これらの機能は多岐にわたるので、この紹介では簡単に触れるにとどめておくことにする。詳しくはLumberjackのドキュメントとソースコードを参照して欲しい。

Lumberjackでは、ログ出力先が差し替え可能で、syslogやDBにログを保存できるようになっている。これらの機能は、`lumberjack_syslog`や`lumberjack_mongo_device`など別のgemパッケージで提供されている。

Lumberjackのログは自在にフォーマットをカスタマイズできる。例えばクラス毎に固有のログ出力フォーマットを定義したり、ログ出力の時刻形式や、出力するメタデータを絞り込むこともできる。

Lumberjackのログはデフォルトでバッファリングされる。このバッファリングの設定は、`Logger`初期化時にオプションとしてバッファリング時間やバッファサイズを指定して変更可能である。

Lumberjackは時刻とサイズによるログローリング機能を備えている。またLumberjacはマルチプロセスに対応しており、マルチプロセスによる同一ファイルへのロギングが安全に行える。

### まとめ

以上のように、Lumberjackは必要十分な機能を持ったログ出力ライブラリである。特にマルチプロセス対応なので、標準ライブラリの`Logger`が使えないケースにも活用できるだろう。使いかたも`Logger`とほぼ同様なので、学習コストも低い。

ログ出力は大きなアプリケーションには欠かせない機能だが、Lumberjackを使えば簡単に強力なログ出力機能を実装できる。Rubyでアプリケーションを開発する際には、ぜひ覚えておきたいライブラリである。
