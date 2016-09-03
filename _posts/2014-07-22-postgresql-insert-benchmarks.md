---
layout: blog
title: PostgreSQLのINSERTのベンチマーク(トランザクション、一括INSERT)
tag: postgresql
---



PostgreSQLのINSERTのベンチマークを行ったので結果をまとめる。

# 高速化のアプローチ

ベンチマークでは、INSERTを高速化するアプローチとして、以下2つのアプローチを採る。

1. トランザクションの使用
2. 一括INSERTの使用

*1.*トランザクションについては、本来は実行速度を目的として使用するものではない。
しかし、トランザクションを使うことで、何らかの処理がまとめて実行されて、高速化することを期待する。
実装に依る部分が大きいと思われるが、この方法は特にSQLite3で顕著に速度が向上することを確認済み。

*2.*については複数レコードを一括して挿入するINSERT文を用いる方法である。
こちらも何らかの処理がまとめて実行されて高速化することを期待する。
PostgreSQLではサポートされているが、DBMSによっては使用できないかも知れない。

# テストケース

挿入レコード数を1万レコードとして、これらのアプローチを使わない場合、どちらかのアプローチを使う場合、両方のアプローチを使う場合で、以下4つのテストケースを考えた。

1. 単純にINSERT文を10000回発行する
2. トランザクションを使って単純にINSERT文を10000回発行する
3. INSERT文1回で10000件のレコードを挿入する
4. トランザクションを使ってINSERT文1回で10000件のレコードを挿入する

# DBスキーマ

拙作[BsetGems.org](http://bestgems.org/)の`values`テーブルを対象とする。
スキーマは以下である。

~~~~
bestgems=> \d values
                         Table "public.values"
 Column |  Type   |                      Modifiers                      
--------+---------+-----------------------------------------------------
 id     | integer | not null default nextval('values_id_seq'::regclass)
 type   | integer | 
 gem_id | integer | 
 date   | date    | 
 value  | integer | 
Indexes:
    "values_pkey" PRIMARY KEY, btree (id)
    "values_date_index" btree (date)
    "values_type_index" btree (type)
    "valuess_gem_id_index" btree (gem_id)
Foreign-key constraints:
    "values_gem_id_fkey" FOREIGN KEY (gem_id) REFERENCES gems(id)
~~~~

# ベンチマーク環境

ベンチマークに使ったPostgreSQLはDebian WheezyのPostgreSQL 9.1である。

テストコードはRubyのORMであるSequelで記述する。

# ベンチマーク

## 1. 単純にINSERT文を10000回発行する

### テストコード

~~~~
require 'benchmark'

result = Benchmark.realtime do
  10000.times{|i|
    Value.insert(:type => 0, :gem_id => i, :date => Date.new(1986, 12, 1), :value => 1234)
  }
end
puts result.to_s
~~~~

### 結果

~~~~
49.344850867
~~~~

## 2. トランザクションを使って単純にINSERT文を10000回発行する

### テストコード

~~~~
require 'benchmark'

result = Benchmark.realtime do
  DB.transaction do
    10000.times{|i|
      Value.insert(:type => 0, :gem_id => i, :date => Date.new(1986, 12, 1), :value => 1234)
    }
  end
end
puts result.to_s
~~~~

### 結果

~~~~
9.331421286
~~~~

## 3. INSERT文1回で10000件のレコードを挿入する

### テストコード

~~~~
require 'benchmark'

result = Benchmark.realtime do
  data = []
  10000.times{|i|
    data << {:type => 0, :gem_id => i, :date => Date.new(1986, 12, 1), :value => 1234}
  }
  Value.multi_insert(data)
end
puts result.to_s
~~~~

### 結果

~~~~
1.068728127
~~~~

## 4. トランザクションを使ってINSERT文1回で10000件のレコードを挿入する

### テストコード

~~~~
require 'benchmark'

result = Benchmark.realtime do
  DB.transaction do
    data = []
    10000.times{|i|
      data << {:type => 0, :gem_id => i, :date => Date.new(1986, 12, 1), :value => 1234}
    }
    Value.multi_insert(data)
  end
end
puts result.to_s
~~~~

### 実行結果

~~~~
1.234780151
~~~~

# ベンチマーク結果

結果をまとめると以下のようになった。

|テストケース|実行時間(秒)|
|:=|=:|
|1. 単純にINSERT文を10000回発行する|49.344850867|
|2. トランザクションを使って単純にINSERT文を10000回発行する|9.331421286|
|3. INSERT文1回で10000件のレコードを挿入する|1.068728127|
|4. トランザクションを使ってINSERT文1回で10000件のレコードを挿入する|1.234780151|
{: .table .table-striped}

この結果のポイントは以下。

- 最も高速なのは*3.*で約1秒で完了した
- 最も低速なのは*1.*で約49秒を要した
- 最も高速な*3.*と低速な*1.*ではおよそ50倍の性能差があった
- トランザクションを使った*2.*は9秒で*1.*より5倍高速だった
- トランザクションを使った*4.*は1.2秒で*3.*の1.0秒よりやや低速だった
- トランザクションが高速化に効果を発揮するのは大量のSQLを発行する場合のみ

*3.*と*4.*は意外な結果だったため、誤差かと思った。
追加でレコード数を50000件に増やして*3.*と*4.*をテストしたところ、*3.*は6秒、*4.*は14秒かかった。
やはりトランザクションを使用した*4.*の方が遅い結果となった。

# 結論

PostgreSQLで大量のレコードをINSERTする場合は

- 一括INSERTでSQLの発行回数を抑える
- トランザクションを使わない

のが最も高速という結果になった。
