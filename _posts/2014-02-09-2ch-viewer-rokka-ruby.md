---
layout: blog
title: 2chビューア●の現状と過去ログ閲覧用新システム「Rokkaシステム」およびofflaw2について
tag: x2ch
---

# 2chビューア●の現状と過去ログ閲覧用新システム「Rokkaシステム」およびofflaw2について

## はじめに

2013年8月、2chビューア●の個人情報が流出する事件があった。
2chビューア●は、規制を回避して掲示板に書き込む機能と、過去ログを自由に閲覧できる過去ログ閲覧機能を提供していが、事件を発端に2chビューア●の機能はすべて停止された。

しかし、2013年9月に突如「Rokkaシステム」なるものが発表され、現在一部の掲示板の過去ログ取得が可能になっている。
さらに、2013年10月には従来のofflawに代わり、offlaw2が暫定的に公開され、2chビューア●なしで2chの過去ログが閲覧可能になった。

2014年2月現在の状況を整理すると以下のようになる。

- ●による規制回避書き込み不可
- 従来の方法では2ch / BBSPINKの過去ログ閲覧も不可
- 「Rokkaシステム」によりBBSPINKの過去ログ閲覧が可能
- offlaw2で2chの過去ログ閲覧が可能(2chビューア●不要)

[x2ch](https://github.com/xmisao/x2ch)を開発している都合上、技術的な部分が気になるので、Rokkaシステムとofflaw2による過去ログ取得を試してみた。
このエントリーで記録を残しておきたいと思う。

## Rokkaシステムを使ったBBSPINKの過去ログ取得

実際に2chビューア●でRokkaシステムにアクセスし、BBSPINKの過去ログを取得してみたいと思う。
以下にRokkaシステムの公式(?)なドキュメント、Rokkaシステムに関して議論しているスレッド、Rokkaシステムのソースコードリポジトリを示す。

- [http://stream.bbspink.com/update.txt](http://stream.bbspink.com/update.txt)
- [Rokka System](http://pele.bbspink.com/test/read.cgi/erobbs/1379086553/)
- [Cipherwraith / Rokka](https://github.com/Cipherwraith/Rokka)

公式のドキュメントから重要な部分を抜粋して引用する。

~~~~
> New method:
>    Login and password -> futen.cgi
>    futen.cgi -> SID
>    sid -> rokka.bbspink.com / rokka.2ch.net
>    rokka.bbspink.com -> archived data
>Example of new method:
>    https://2chv.tora3.net/futen.cgi?ID=example@email.com&PW=password
> 
>    http://rokka.bbspink.com/pele/erobbs/1285357421/l20?sid=Monazilla/2.00:4373298c8948y4671k0168w7303a9434p5474w1299s9683N7819o8487t63934i03706s0346y40494k1660P9509C7891q86296i5017j76441I4435I6218N8902O7343v3629G0551A4520100z3111c7334y0675t5359e8939m0
>    http://rokka.<SITENAME>.<COM or NET>/<SERVER NAME>/<BOARD NAME>/<DAT NUMBER>/<OPTIONS>?sid=<SID>
>
>Sid length = 192 characters
~~~~

まずNew methodとして記載されているRokkaシステムの認証のシーケンスについて。
わかりにくいが、これは次のように読み解ける。

1. IDとパスワードをfuten.cgiに送る
2. futen.cgiからセッションIDが返る
3. セッションID付きでrokka.bbspink.comまたはrokka.2ch.netにアクセスする
4. rokka.bbspink.com / rokka.2ch.netから過去ログのデータが返る

Example of new methodに記載のようにIDとPWをつけて2chビューア●の認証を行う。
実際にアクセスしてみると、このアクセスでは以下のようなSESSION IDが返る。(末尾に改行が2つ付加されている、それは\nで表記した)
`SESSION-ID=`以降がセッションIDで、セッションIDは192バイトの文字列となっている。

~~~~
https://2chv.tora3.net/futen.cgi?ID=example@email.com&PW=password
~~~~

~~~~
SESSION-ID=Monazilla/2.00:5786390n2278I82041X9424T46550K08746m53379k15463h8951j8412T75283O624x90412K44612U8260M91511f2269n82527f7745m77920X88123E58190d42573f1882e55127C3553Z75055V3139573m3777h35244g1231x\n\n
~~~~

セッションIDが手に入ったので、過去ログの取得を行う。
過去ログ取得時のアクセス先は以下である。

~~~~
http://rokka.<サーバ>/<ホスト名>/<板名>/<スレッド番号>/<オプション>?sid=<セッションID>
~~~~

BBSPINKのpink秘密基地板の「言いたいことだけ言って立ち去るスレッドPART10」の過去ログを取得すると仮定してパラメータを埋めてみる。
スレッドのURLは以下である。

- [http://pele.bbspink.com/test/read.cgi/erobbs/1285357421/](http://pele.bbspink.com/test/read.cgi/erobbs/1285357421/)

- <サーバ> -- BBSPINKなので`bbspink.com`
- <ホスト名> -- ドメインが`pele.bbspink.com`なので`pele`
- <板名> -- pink秘密基地板なので`/read.cgi/`以下の`erobbs`
- <スレッド番号> -- 末尾のスレッド番号`1285357421`
- <オプション> -- 過去ログの全件取得であれば空白で良い
- <セッションID> -- 前述のセッションID

これで以下のURLが得られる。

~~~~
http://rokka.bbspink.com/pele/erobbs/1285357421/?sid=Monazilla/2.00:5786390n2278I82041X9424T46550K08746m53379k15463h8951j8412T75283O624x90412K44612U8260M91511f2269n82527f7745m77920X88123E58190d42573f1882e55127C3553Z75055V3139573m3777h35244g1231x
~~~~

以下がそのアクセス結果の冒頭である。

~~~~
Success Archive
名無し編集部員<><>2010/09/25(土) 04:43:41 ID:nzNo+Tzc<> 何でもいいから、あなたの言いたいことを好きなだけ言って立ち去って下さい。 <br>  <br> 前スレ <br> 言いたいことだけ言って立ち去るスレッドPART9 <br> http://set.bbspink.com/test/read.cgi/erobbs/1261984639/ <>言いたいことだけ言って立ち去るスレッドPART10
名無し編集部員<>sage<>2010/09/25(土) 05:12:35 ID:uvJXG+6+<> みかんさん、元気になれ！ <>
名無し編集部員<>sage<>2010/09/25(土) 18:27:18 ID:TpGAFvDf<> 分裂の頃yumeさんやPOEさん某770さん、雪帽子さん、トオルさん、IZUMI姐さん、SELENさん、 <br> 今はまだ無い。さん、コロさんなどと深く話していた風俗スレのルールが崩れていく、、、、、 <>
...
~~~~

以上で動作の確認ができたので、Rokkaシステムで過去ログを取得するRubyスクリプトを作成してみた。
実際にはRokkaシステムの認証は1度行えばセッションIDを使いまわせる。

~~~~
require 'open-uri'
require 'kconv'

# Rokkaシステム認証
id = "example@email.com"
pw = "password"

response = open("https://2chv.tora3.net/futen.cgi?ID=#{id}&PW=#{pw}"){|f| f.read}
sid = response.strip.match(/SESSION-ID=(.+)/).to_a[1]

# Rokkaシステム過去ログ取得

server = "bbspink.com"
host = "pele"
board = "erobbs"
thread_id = "1285357421"
opts = ""

puts open("http://rokka.#{server}/#{host}/#{board}/#{thread_id}/#{opts}?sid=#{sid}"){|f| f.read.toutf8}
~~~~

## offlow2を使った2chの過去ログ取得

offlow2については公式のドキュメントが無いがmonazillaの以下のドキュメントが参考になる。

- [offlaw2の仕様](http://www.monazilla.org/index.php?e=348)

要求メッセージの例を抜粋して引用する。

~~~~
> 要求メッセージの一例
> GET /test/offlaw2.so?shiro=kuma&sid=ERROR&bbs=[板名]&key=[スレッド番号] HTTP/1.1
> Accept-Encoding: gzip
> Host: [サーバー]
> Accept: */*
> Referer: http://[サーバー]/test/read.cgi/[板名]/[スレッド番号]/
> Accept-Language: ja
> User-Agent: Monazilla/1.00 (ブラウザ名/バージョン)
> Connection: close
~~~~

例から以下のURLにアクセスすれば良いことがわかる。
パラメータの`sid=ERROR`は不要である。

~~~~
http://<サーバ>/test/offlaw2.so?shiro=kuma&bbs=<板名>&key=<スレッド番号>
~~~~

試しに2chのアクアリウム板の「【繁殖】グッピー初心者専用スレ2匹目【入門種】」スレッドの過去ログを取得すると仮定して、パラメータを埋めてみる。
このスレッドのURLは以下である。

- [http://awabi.2ch.net/test/read.cgi/aquarium/1329895650/](http://awabi.2ch.net/test/read.cgi/aquarium/1329895650/)

- <サーバ> -- ドメイン全体の`awabi.2ch.net`
- <板名> -- `/test/read.cgi/`以下の`aquarium`
- <スレッド番号> -- 末尾の`1329895650`

これで以下のURLが得られる。
一見無意味な`shiro=kuma`というパラメータは必須の模様。

~~~~
http://awabi.2ch.net/test/offlaw2.so?shiro=kuma&bbs=aquarium&key=1329895650
~~~~

以下がそのアクセス結果の冒頭である。

~~~~
pH7.74<><>2012/02/22(水) 16:27:30.68 ID:J0zt9CJQ<> 前スレが<a href="../test/read.cgi/aquarium/1329895650/1000" target="_blank">&gt;&gt;1000</a>後に落ちたままだったので立てました。 <br> グッピーについて語りましょう。初心者大歓迎です！ <br> 初歩的な話や他では聞けないような質問はここで。 <br> 荒らしは徹底スルーでお願いします。 <br>  <br> 関連スレ <br> グッピー総合スレッド F32 <br> http://awabi.2ch.net/test/read.cgi/aquarium/1325173467/ <br> グッピーっ同じ水槽で <br> http://awabi.2ch.net/test/read.cgi/aquarium/1286929364/ <>【繁殖】グッピー初心者専用スレ2匹目【入門種】
pH7.74<>sage<>2012/02/22(水) 16:28:04.32 ID:J0zt9CJQ<> 前スレ <br> 【繁殖】グッピー初心者専用スレ【入門種】 <br> http://toki.2ch.net/test/read.cgi/aquarium/1297074140/ <>
pH7.74<>sage<>2012/02/22(水) 19:39:18.52 ID:CbRmxZaq<> オールドファションブルーモザイクのペアから  <br> オールドファッションレッドモザイクの♂と全身真っ黒の♀が産まれたんだけど  <br> 真っ黒の♀から再び綺麗なブルーモザイクって遺伝してくる？？  <br>  <br> ブルーグラス♂と×てるんだけどー  <br> それとオールドファッションって何でレッドが出てくるんだろうか？  <br>  <>
...
~~~~

以上で動作の確認ができたので、こちらも過去ログを取得するRubyスクリプトを作成してみた。

~~~~
require 'open-uri'
require 'kconv'

server = "awabi.2ch.net"
board = "aquarium"
thread_id = "1329895650"

puts open("http://#{server}/test/offlaw2.so?shiro=kuma&bbs=#{board}&key=#{thread_id}"){|f| f.read.toutf8 }
~~~~

## おわりに

本エントリでは情報流出事件後の2chビューア●の現状について整理した。続いてBBSPINKと2chについて過去ログの取得方法を調べ、Rubyで過去ログを取得するスクリプトを紹介した。

正直なところ情報流出後の2chの運営はさんざんであり、ライブラリ作者としてはどのタイミングで対応すれば良いのか判断がつきかねる。offlaw2による2ch過去ログ公開がいつまで継続されるのか、Rokkaシステムが将来2chにも対応するのか、今後も状況を注視してゆきたい。
