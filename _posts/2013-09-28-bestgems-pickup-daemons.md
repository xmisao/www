---
layout: blog
title: BestGems Pickup! 第6回 「daemons」
tag: bestgems_pickup
---



拙作の[BestGems](http://bestgems.org/)から注目のGemを紹介するエントリー。第6回は「[daemons](http://daemons.rubyforge.org/)」を取り上げる。

# 概要

daemonsはrubyスクリプトをデーモン化し、外部からコントロール(start, stop等)できるようにするライブラリだ。

daemonsは今日現在、合計ダウンロードランキング46位、デイリーダウンロードランキング66位につけている。

# インストール

    gem install daemons

# 使用例

damonesの使い方で一番オーソドックスなのは、制御スクリプトを書いてアプリケーションをデーモン化する方法だ。

アプリケーション`myserver.rb`を以下の内容とする。

~~~~
loop do
	sleep(5)
end
~~~~

続いて制御スクリプト`myserver_control.rb`を以下のように書く。

~~~~
require 'daemons'

Daemons.run('myserver.rb')
~~~~

これだけで、`myserver.rb`をデーモン化し、`myserver_control.rb`を通じてコントロールできるようになる。

まずアプリケーションを起動するには`start`だ。これでバックグラウンドでアプリケーションが実行される。

~~~~
ruby myserver_control.rb start
~~~~

daemonsでは、通常はアプリケーションを重複起動できないようになっており、再度`start`するとエラーメッセージが出る。

~~~~
ruby myserver_control.rb start
~~~~

~~~~
ERROR: there is already one or more instance(s) of the program running
~~~~

アプリケーションの状態を表示するには`status`を使う。動作状況とPIDが表示される。

~~~~
ruby myserver_control.rb status
~~~~

~~~~
myserver.rb: running [pid 16924]
~~~~

起動しているアプリケーションを停止するには`stop`だ。

~~~~
ruby myserver_control.rb stop
~~~~

さて、上記の例ではアプリケーションと制御スクリプトを別のスクリプトにしていた。もしアプリケーションに少し手を加えて良いなら、制御スクリプトを分けない書き方もできる。

以下の内容を`myproc_control.rb`とする。

~~~~
require 'daemons'

Daemons.run_proc('foo') do
	loop do
		sleep(5)
	end
end
~~~~

`Daemons.run_proc()`はブロックの中身をデーモンとして実行するメソッドだ。引数に与えるのは識別子なので何でもかまわない。

このスクリプトも最初の例と同じように`start`や`stop`で制御することができる。

~~~~
ruby myproc_control.rb start
~~~~

~~~~
ruby myproc_control.rb stop
~~~~

# 解説

daemonsを使えば、自分のrubyスクリプトを、わずか2行でデーモン化することが可能だ。自分でrubyでデーモンを書いたことがある人ならありがたみがわかるだろう。サーバや常時起動するアプリケーションを自分で書く機会があるなら、ぜひ抑えておきたいgemである。

補足として、daemonsで可能な操作を以下の表にまとめた。デーモンを操作するための、ひと通りの機能が揃っていることがわかる。

アプリケーションのインスタンス、という遠まわしの表現なのは、アプリケーションを複数起動させることもできるためだ。

|操作|意味|
|:-|:-|
|start|アプリケーションのインスタンスを起動する|
|stop|アプリケーションのインスタンスをすべて停止する|
|restart|アプリケーションのインスタンスをすべて停止し、その後に起動させる|
|reload|アプリケーションのインスタンスすべてにSIGHUPを送信する|
|run|アプリケーションをフォアグラウンドで起動する|
|zap|アプリケーションを停止した状態にする|
|status|アプリケーションのインスタンスのPIDを表示する|
{: .table .table-striped}

使用例では取り上げなかった機能もある。`Daemons.call`でRubyスクリプトからデーモンを操作することもできる。また`Daemons.daemonize`で実行中のプロセスをデーモン化することも可能だ。詳しくはドキュメントとソースを見てほしい。
