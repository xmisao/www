---
layout: blog
title: TokyoCabinetで超高速・超省メモリのハッシュをRubyで体験しよう
tag: programming
---

# TokyoCabinetで超高速・超省メモリのハッシュをRubyで体験しよう

[TokyoCabinetのオンメモリハッシュデータベースをRubyで利用する](http://www.xmisao.com/2013/10/03/ruby-tokyocabinet.html)では、TokyoCabinetをRubyから活用する方法を簡単に紹介した。ここで気になるのは、TokyoCabinetはどれほどHashより効率的なのか?という事だ。結論を書くと、TokyoCabinetのオンメモリハッシュデータベースはRubyのHashより省メモリかつ高速である。

比較のため以下のコードで、メモリ使用量と処理時間のベンチマークを行った。16文字のキーに対して16文字の値を要素に持つハッシュを作り、要素の数を10万、100万、1000万と順に増やして計測した。

*Hashのベンチマーク*

~~~~
require 'time'
start = Time.now
hash = {}
(1000 * ARGV[0].to_i).times{|i|
        hash[sprintf("%016d", i)] = sprintf("%016d", i)
}
puts `ps -o rss= -p #{Process.pid}`.to_i
puts Time.now - start
~~~~

*TokyoCabinetのベンチマーク*

~~~~
require 'time'
require 'tokyocabinet'
include TokyoCabinet

start = Time.now
db = ADB::new
db.open('*')
(1000 * ARGV[0].to_i).times{|i|
        db[sprintf("%016d", i)] = sprintf("%016d", i)
}
puts `ps -o rss= -p #{Process.pid}`.to_i
puts Time.now - start
~~~~

メモリ使用量の計測結果は以下のとおり。
要素数を増やしても一貫してTokyoCabinetはHashの2/3のメモリしか消費しない。

|要素数|Hash|TokyoCabinet|
|-:|-:|-:|
|10万|23MB|14MB|
|100万|149MB|99MB|
|1000万|1440MB|942MB|
{: .table .table-striped}

処理時間の計測結果は以下のとおり。
Hashは要素数の増加に伴って急激に処理時間が増加する。
一方TokyoCabinetの処理時間は線形に増加し急激な増加は見られない。

|要素数|Hash|TokyoCabinet|
|-:|-:|-:|
|10万|0.2秒|0.2秒|
|100万|5.6秒|2.2秒|
|1000万|189.7秒|25.7秒|
{: .table .table-striped}

Rubyで巨大なハッシュを扱っていて、使用メモリ量や処理速度の問題を抱えているのなら、TokyoCabinetのオンメモリハッシュデータベースを活用することで、問題が解決できるかも知れない。
