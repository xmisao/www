---
layout: blog
title: Rubyでflockを使ってファイルのロックを取得する
tag: ruby
---

# Rubyでflockを使ってファイルのロックを取得する

Rubyの`File#flock`メソッドを使えば、`flock`システムコールを利用して、ファイルのロックを取得することができる。以下2つのプログラムを用意して、挙動を確認してみよう。

## プログラム

## lock_blocking.rb

これは、ファイル`LOCK`をロックし、入力を受け付けるまでロックし続けるプログラムである。もし既にロックが取得されていれば、ロックが取得できるまでブロックする。

~~~~
open('LOCK', 'w'){|f|
	puts 'trying to lock.'
	f.flock(File::LOCK_EX)
	puts 'lock succeed.'
	gets
}
~~~~

## lock_nonblocking.rb

これも`LOCk`をロックするが、`File::LOCK_NB`を指定して、ノンブロックモードでロックしている。ロックが取得できたらロック成功として、入力があるまでロックを取得し続ける。もし既にロックが取得されていたら、`flock`は`false`を返し、ロック失敗となる。

~~~~
open('LOCK', 'w'){|f|
	puts 'trying to lock.'
	if f.flock(File::LOCK_EX | File::LOCK_NB)
		puts 'lock succeed.'
		gets
	else
		puts 'lock failed.'
	end
}
~~~~

## 実験

コンソールを2つ立ちあげて、以下の組み合わせでプログラムを同時に実行させてみよう。

|パターン|最初に実行|次に実行|
|-:|:-|:-|
|1|lock_blocking.rb|lock_blocking.rb|
|2|lock_blocking.rb|lock_nonblocking.rb|
|3|lock_nonblocking.rb|lock_blocking.rb|
|4|lock_nonblocking.rb|lock_nonblocking.rb|
{: .table .table-striped}

### パターン1

`lock_blocking.rb`に続けて`lock_blocking.rb`を実行する。

最初に実行したプログラムは、以下を出力してロックを取得し入力待ちとなる。

~~~~
# 最初に実行したプログラムの出力
trying to lock.
lock succeed.
~~~~

次に実行したプログラムは、以下を出力して停止する。

~~~~
# 次に実行したプログラムの出力
trying to lock.
~~~~

最初のプログラムに入力を与えて処理を進めた瞬間、次に実行したプログラムでロックが成功する。

~~~~
# 次に実行したプログラムの出力
trying to lock.
lock succeed.
~~~~

### パターン2

`lock_blocking.rb`に続けて`lock_nonblocking.rb`を実行する。

最初に実行したプログラムは、以下を出力してロックを取得し入力待ちとなる。

~~~~
# 最初に実行したプログラムの出力
trying to lock.
lock succeed.
~~~~

次に実行したプログラムは、ロック取得を待たずに即座に以下を出力して終了する。

~~~~
# 次に実行したプログラムの出力
trying to lock.
lock failed.
~~~~

### パターン3

`lock_nonblocking.rb`に続けて`lock_blocking.rb`を実行する。

最初に実行したプログラムは、以下を出力してロックを取得し入力待ちとなる。

~~~~
# 最初に実行したプログラムの出力
trying to lock.
lock succeed.
~~~~

次に実行したプログラムは以下を出力し、ロックを取得できるまで停止する。

~~~~
# 次に実行したプログラムの出力
trying to lock.
~~~~

最初のプログラムに入力を与え処理を進めると、その瞬間次に実行したプログラムが以下を出力して入力待ちとなる。

~~~~
# 次に実行したプログラムの出力
trying to lock.
lock succeed.
~~~~

### パターン4

`lock_nonblocking.rb`に続けて`lock_nonblocking.rb`を実行する。

最初に実行したプログラムは、以下を出力してロックを取得し入力待ちとなる。

~~~~
# 最初に実行したプログラムの出力
trying to lock.
lock succeed.
~~~~

次に実行したプログラムは、ロック取得を待たずに即座に以下を出力して終了する。

~~~~
# 次に実行したプログラムの出力
trying to lock.
lock failed.
~~~~

## まとめ

ロックにはブロックとノンブロックがある。ブロックの場合は、ロックが取得できるまでブロックする。ノンブロックの場合は、ロックが取得できなければ失敗となる。

またブロックしている場合、ロックが解放されると(アンロックされるか、ファイルが閉じられると)、ブロックしていた処理が動き出すことが確認できた。

このエントリでは`File::LOCK_EX`と`File::LOCK_NB`のみ扱ったが、`flock`では以下のフラグが指定可能になっている。`flock`を使いこなせば、ファイルオープン中のロックの解放や、共有ロックなどより複雑な制御が可能である。

|定数|意味|
|:-|:-|
|File::LOCK_EX|排他ロックする。|
|File::LOCK_SH|共有ロックする。|
|File::LOCK_NB|ノンブロックでロックする。他のフラグと`|`組み合わせて指定する。|
|File::LOCK_UN|アンロックする。|
{: .table .table-striped}
