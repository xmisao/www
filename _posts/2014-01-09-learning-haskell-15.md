---
layout: blog
title: もしRubyistがHaskellを学んだら(15)
tag: learning_haskell
---

# もしRubyistがHaskellを学んだら(15)

今日は少し嗜好を変えて、Haskellを勉強する時に便利な、GHCiの使い方について少し整理してみることにする。

GHCiはRubyでいうとirbに相当するGHCのインタラクティブなインタフェースである。随時プログラムを入力しながら、その挙動を確認することができる。

まずGHCiの起動は`ghci`コマンドで行う。基本的なパッケージがロードされ、プロンプトがPrelude>に代わる。

~~~~
$ ghci
GHCi, version 7.4.1: http://www.haskell.org/ghc/  :? for help
Loading package ghc-prim ... linking ... done.
Loading package integer-gmp ... linking ... done.
Loading package base ... linking ... done.
Prelude>
~~~~

ここにHaskellのプログラムを入力すると、評価結果が出力される。例えばリスト内包表記で、1から10のリストを作ると、確かに評価結果が`[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]`だということがわかる。

~~~~
Prelude> [x | x <- [1..10]]
[1,2,3,4,5,6,7,8,9,10]
~~~~

GHCiへの指示は`:`から始まるコマンドを利用する。全コマンドの一覧は`:?`で参照することができる。

~~~~
Prelude> :?
 Commands available from the prompt:

   <statement>                 evaluate/run <statement>
   :                           repeat last command
   :{\n ..lines.. \n:}\n       multiline command
...
~~~~

代表的なコマンドの使い方を確認してみよう。

GHCiでは外部のHaskellプログラムをロードして、使うことができる。外部のプログラムをロードするには`:load`を使う。これは`:l`として省略することができる。`myfunc.hs`には関数`myfunc`が定義されているものとして、これをロードして呼び出してみよう。

~~~~
myfunc = "My Function"
~~~~

~~~~
Prelude> :l myfunc.hs
[1 of 1] Compiling Main             ( myfunc.hs, interpreted )
Ok, modules loaded: Main.
*Main> myfunc
"My Function"
~~~~

外部ファイルを使わずにGHCiでインタラクティブに関数を定義することもできる。その際は`let`を使って以下のようにする。

~~~~
*Main> let hoge = "hoge"
*Main> hoge
"hoge"
~~~~

モジュールをリロードして環境を初期状態に戻すには`:reload`または`:r`を使う。これで`Main`で定義した関数`hoge`は無かったことになり、ロードした`myfunc`だけが残る。

~~~~
*Main> :r
Ok, modules loaded: Main.
*Main> hoge

<interactive>:7:1: Not in scope: `hoge'
*Main> myfunc
"My Function"
~~~~

GHCiで便利な機能に、式の型を確認する`:type`がある。これは`:t`と省略して呼び出すこともできる。試しに`myfunc`や、Haskellの組み込み関数である`head`の型を確認してみよう。

~~~~
*Main> :t myfunc
myfunc :: [Char]
*Main> :t head
head :: [a] -> a
~~~~

最後に、GHCiを終了するには`:quit`もしくは`:q`を使う。恥ずかしい話だが、はじめてGHCiを起動した時はこれがわからず、killしてしまった。ちゃんと終了させよう。

~~~~
Prelude> :q
Leaving GHCi.
$
~~~~

これでHaskellの勉強がさらに捗るはずである。

ところで、これまで参考書として"プログラミングHaskell"を使っていたが、"すごいHaskellたのしく学ぼう!"という本がわかりやすいという情報を得たので買ってみた。

まだ1, 2割しか読んでいないが、堅苦しさのない親しみやすい内容でありながら、Haskellを勉強するポイントがしっかり抑えられており、かなり良い入門書と言える。はじめてHaskellを勉強する人はこれを買えば良いと思う。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4274068854/xmisao-22/ref=nosim/" name="amazletlink" target="_blank"><img src="http://ecx.images-amazon.com/images/I/51P6NdS4IGL._SL160_.jpg" alt="すごいHaskellたのしく学ぼう!" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4274068854/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">すごいHaskellたのしく学ぼう!</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 14.01.09</div></div><div class="amazlet-detail">Miran Lipovača <br />オーム社 <br />売り上げランキング: 126,678<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4274068854/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>
