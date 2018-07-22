---
layout: blog
title: Rubyで並列処理を行うparallel gemの使い方と勘所
tag: ['ruby', 'parallel']
---

[parallel](https://github.com/grosser/parallel)を使うと`Kenrel#fork`や`Thread`を駆使するのと比べて簡単に並列処理を書くことができます。parallelは拙作の[BestGems.org](http://bestgems.org/gems/parallel)によると、合計ダウンロード数で151位、デイリーダウンロード数は100位前後で、現時点で非常にメジャーなGemとなっています。

この記事ではparallelの基本的な使い方と、実際に使ってみて感じた注意点をTipsとして整理したいと思います。

parallelは[README.md](https://github.com/grosser/parallel/blob/master/lib/parallel.rb)が親切に書かれています。
加えて[主要な部分](https://github.com/grosser/parallel/blob/master/lib/parallel.rb)は500行程度の小さなGemです。
利用する場合は公式のドキュメントとソースコードを確認されることをおすすめします。

## 前提ソフトウェア 

|ソフトウェア          |バージョン    |備考                                                   |
|:-                    |:-            |:-                                                     |
|ruby                  |2.5.1         |-                                                      |
|parallel              |1.12.1        |-                                                      |
|rails                 |5.0           |-                                                      |

# 使い方

## インストール

`gem install parallel`するか`Gemfile`に以下の1行を追加して`bundle install`して下さい。

```ruby
gem 'parallel'
```

明示的にロードする場合はparallelを利用するRubyのプログラムで`require 'parallel'`して下さい。
以降のサンプルコードではこの記述は省略しています。

## できること

parallelにはRubyのeachやmapに相当する操作を並列処理するための以下のメソッドがあります。

|Rubyのメソッド|対応するparallelのメソッド|
|:---|:---|
|`Enumerable#each`|`Parallel.each`|
|`Enumerable#map`|`Parallel.map`|
|`Enumerable#any?`|`Parallel.any?`|
|`Enumerable#all?`|`Parallel.all?`|
|`Enumerable#each_with_index`|`Parallel.each_with_index`|
|`Enumerable#map`, `Enumerator#with_index`|`Parallel.map_with_index`|

### each

`Parallel.each`はブロックが並列に実行される`each`です。
並列に処理しているためブロックの実行が完了する順序はバラバラです。
戻り値は`Parallel.each`の引数が返ります。

```ruby
result = Parallel.each(1..10) do |item|
  # 普通のeachのようだがブロックは並列に実行される
  p item ** 2
end

p result
```

以下はこのコードの出力の例です。

```
1
9
16
4
25
64
36
100
49
81
1..10
```

### map

`Parallel.map`はブロックが並列に実行される`map`です。
並列に処理しているためブロックの実行が完了する順序はバラバラです。
戻り値は`map`と同様に入力した各要素に対応した値の配列が返ります。

```ruby
result = Parallel.map(1..10) do |item|
  # 普通のmapのようだがブロックは並列に実行される
  p item ** 2
end

p result
```

以下はこのコードの出力の例です。

```
1
4
9
16
25
36
49
64
100
81
[1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
```

### ワーカー番号の取得

上記のメソッド以外の機能もあります。
ブロック内で`Parallel.worker_number`を呼ぶとワーカースレッド/プロセスの番号を取得できます。
デバッグやロギングで利用できます。

```ruby
require 'parallel'

result = Parallel.map(1..10) do |item|
  p [item ** 2, Parallel.worker_number]
end

p result
```

以下はこのプログラムの出力の例です。

```
[1, 0]
[4, 1]
[9, 0]
[16, 3]
[25, 4]
[81, 1]
[36, 5]
[49, 6]
[100, 1]
[64, 7]
[[1, 0], [4, 1], [9, 0], [16, 3], [25, 4], [36, 5], [49, 6], [64, 7], [81, 1], [100, 1]]
```

## スレッドとプロセス

parallelのメソッドはオプションでプロセスで処理(`in_processes`)するかスレッドで処理(`in_threads`)するかを切り替えることができます。

### プロセスで処理する場合

CRubyで何もオプションを指定しなければプロセスによる並列処理になります。
並列数はparallel内部の`Parallel::ProcessorCount.count`が返す論理コア数になります。

`in_processes: 並列数`を指定すると指定したプロセス数で並列化して実行できます。

```ruby
Paralell.each(1..10, in_processes: 10); end
```

parallelの内部で`fork`して作られたワーカープロセスはメソッド呼び出しが完了するまで使い回されます。
1回のブロックの実行毎に`fork`させたい場合は`isolation: true`を指定することもできます。

```ruby
Paralell.each(1..10, in_processes: 10, isolation: true); end
```

### スレッドで処理する場合

JRubyで何もオプションを指定しなければスレッドによる並列処理になります。
並列数はparallel内部の`Parallel::ProcessorCount.count`が返す論理コア数になります。

`in_threads: 並列数`を指定すると指定したスレッド数で並列化して実行できます。

```ruby
Paralell.each(1..10, in_threads: 10) do; end
```

# Tips

parallelを使ってわかった勘所をまとめます。

## 第1引数について

`each`や`map`の第1引数はどんなオブジェクトを渡すかによってparallelの挙動は異なります。

基本的に第1引数は`to_a`されてparallelの内部で配列になります。
この挙動を知らないとparallelの呼び出し元で意図せずしてメモリ使用量が増大することがあります。
例外的に`Proc`と`Thread::Queue`を第1引数とした場合に、配列にはされずに処理します。

|第一引数|parallelによる判定条件|挙動|
|:---|:---|:---|
|`Proc`オブジェクト|`.call`できること|ブロックの実行ごとに`.call`します。`.call`で`Parallel::Stop`を返すと処理を完了します。|
|`Thread::Queue`オブジェクト|`num_waiting`および`pop`できること|ブロックの実行ごとに`.pop`します。|
|その他|上記以外|まず`to_a`して配列にします。ブロックの実行ごとに先頭から要素を処理します。|

詳細はparallelの`JobFactory`クラスのソースを見て下さい。

[https://github.com/grosser/parallel/blob/v1.12.1/lib/parallel.rb#L89-L145](https://github.com/grosser/parallel/blob/v1.12.1/lib/parallel.rb#L89-L145)

`Range`や他の`Enumerable`を渡しても動作しますが、呼び出し元で`Array`, `Proc`, `Thread::Queue`のいずれかを渡した方が、誤解を招かないコードになると思います。

## ワーカープロセスとの通信について

parallelはワーカープロセスとの通信を`IO.pipe`で生成したパイプの入出力で行います。
ワーカープロセスとのオブジェクトの受け渡しは`Marshal.dump`, `Marshal.load`を使います。
このため`Marshal`でシリアライズできないオブジェクトをワーカープロセスと受け渡すことはできません。

## オプションについての注意点

実装上parallelのメソッドのオプションは、パラメータ引数にはなっておらず、キー名のチェックもされません。
このためtypoしたオプションは無視されます。

例えば以下のコードは10プロセスで並列化することを意図しています。
しかし`in_processes`を誤って`in_process`とtypoしているため、デフォルトどおり論理コア数のプロセスで並列化されてしまいます。

```ruby
Parallel.each(1..10, in_process: 10) do; end
```

parallelの呼び出し時にはオプションをtypoしないよう細心の注意を払いましょう。

## ブロック内での例外の発生やreturnについて

ブロック内で例外(`Parallel::Break`, `Parallel::Kill`を除く)を発生させたり`return`したりするとparallelの呼び出しは例外を発生させます。
この時にparallelの呼び出し元で`rescue`できる例外は、並列処理がスレッドとプロセスどちらか、発生した例外がStandarErrorのサブクラスかそれ以外か、により様々です。

以下はparallelのブロック内で何かまずいことが起こった時にparallelの呼び出し元でどのような例外が発生するかの例です。
parallelのソースを読めばなぜこうなるのかわかりますが、仕組みを理解していないと挙動を推し量ることは難しいかも知れません。

```ruby
begin
  Parallel.each([1, 2, 3], in_threads: 2){ raise StandardError }
rescue Exception => e
  p e.class #=> StandardError
end

begin
  Parallel.each([1, 2, 3], in_processes: 2){ raise StandardError }
rescue Exception => e
  p e.class #=> StandardError
end

begin
  Parallel.each([1, 2, 3], in_threads: 2){ raise Exception }
rescue Exception => e
  p e.class #=> Exception
end

begin
  Parallel.each([1, 2, 3], in_processes: 2){ raise Exception }
rescue Exception => e
  p e.class #=> Parallel::DeadWorker
end

begin
  Parallel.each([1, 2, 3], in_threads: 2){ return }
rescue => e
  p e.class #=> LocalJupError
end

begin
  Parallel.each([1, 2, 3], in_processes: 2){ return }
rescue => e
  p e.class #=> Parallel::DeadWorker
end
```

## 例外以外の出力について

アプリケーションが出力するログではparallelで落ちる原因がわからない場合があるかも知れません。
その場合はRubyプロセスが何か出力していないかも確認して下さい。
例外やバックトレースからはわからない情報が出力されていることがあります。

## `Parallel::DeadWorker`について

一番厄介なのはプロセスによる並列処理で発生する`Parallel::DeadWorker`です。

もし例外が発生するコードや意図せずブロックを抜ける箇所も存在しないのに`Parallel::DeadWorker`が発生する場合は、ワーカープロセスのメモリ使用量が増加したことでメモリ不足に陥ったことも疑って下さい。
`NoMemoryError`(`Exception`のサブクラス)がブロック内で発生して`Parallel::DeadWorker`となっている可能性があります。

# Railsでparallelを利用する

Railsでparallelを利用する場合のTipsです。

## ActiveRecordのコネクションについて

parallelに限らずアプリケーションのコードでプロセスやスレッドを作ってActiveRecordを使う際にはコネクションをケアしなければならない時があります。
ActiveRecordのコネクションプールには明るくないため詳しくは説明しません。
対処法は[parallelのREADME.md](https://github.com/grosser/parallel#activerecord)に記載がありますので参考にして下さい。

```ruby
# reproducibly fixes things (spec/cases/map_with_ar.rb)
Parallel.each(User.all, in_processes: 8) do |user|
  user.update_attribute(:some_attribute, some_value)
end
User.connection.reconnect!

# maybe helps: explicitly use connection pool
Parallel.each(User.all, in_threads: 8) do |user|
  ActiveRecord::Base.connection_pool.with_connection do
    user.update_attribute(:some_attribute, some_value)
  end
end

# maybe helps: reconnect once inside every fork
Parallel.each(User.all, in_processes: 8) do |user|
  @reconnected ||= User.connection.reconnect! || true
  user.update_attribute(:some_attribute, some_value)
end
```

どうやってparallelを使うかによっても様々だと思いますが、基本的にはブロック内およびparallelの呼び出し直後で`reconnect!`でコネクションを取得し直すようにすれば、ActiveRecord絡みのエラーは起こらなくなるはずです。

## 大きなテーブルの中身を並列処理したい場合

parallelは使っていますが普通のRailsアプリケーションで大きなテーブルを扱う時の書き方と変わりません。
`find_in_batches`や`in_batches`を使ってちょっとずつテーブルから読んで処理すると良いです。

```ruby
SomeModel.find_in_batches do |some_models|
  Parallel.each(some_models) do |some_model|
    # 処理
  end
end
```

parallelのREADME.mdにあるようにparallelのメソッドに`SomeModel.all`を渡す際は注意して下さい。
テーブルの中身をすべて読み込んでRubyのオブジェクトとしてメモリに乗ってしまいます。

`SomeModel.all`の戻り値は`SomeModel::ActiveRecord_Relation`です。
このオブジェクトは`.call`も`.num_waiting`, `.pop`もできません。
第1引数の注意点として説明したとおり、このような引数を渡すとparallelの内部で`to_a`されるため、テーブルの全ての内容を一気に読み込むことになります。
