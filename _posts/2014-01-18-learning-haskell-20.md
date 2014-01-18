---
layout: blog
title: もしRubyistがHaskellを学んだら(20) Data.Mapによる連想配列
tag: learning_haskell
---

# もしRubyistがHaskellを学んだら(20) Data.Mapによる連想配列

Rubyには連想配列を表す`Hash`クラスが用意されており、文法上もHashを定義するリテラルが存在するなど手厚いサポートがされている。ではHaskellはどうか。Haskellでは連想配列は`Data.Map`モジュールで提供されている。今日はRubyの`Hash`と、Haskellの`Data.Map`の使い方を以下のRubyのコードを元に比較してゆきたい。

~~~~
phoneBook = {"alice" => "1234-5678", "bob" => "2345-6789", "carol" => "3456-7890"}
p phoneBook["alice"] # => "1234-5678"
phoneBook.store("carol", "3456-7890")
p phoneBook["carol"] # => "3456-7890"
phoneBook.delete("bob")
p phoneBook["bob"] # => nil
~~~~

このRubyのコードは、電話帳を操作するものだ。電話帳は`Hash`のインスタンスで表現し、名前をキーに、電話番号を値とする連想配列とする。まず電話帳を初期化し、それに対して電話帳の項目の追加、削除と名前から電話番号の検索を行う。これをHaskellで実装してみることにする。

~~~~
import qualified Data.Map as Map
phoneBook :: Map.Map String String
phoneBook = Map.fromList [("alice", "1234-5678"), ("bob", "2345-6789")]
main = do 
	print $ Map.lookup "alice" phoneBook -- => Just "1234-5678"
	let phoneBook2 = Map.insert "carol" "3456-7890" phoneBook 
	print $ Map.lookup "carol" phoneBook2 -- => Just "3456-7890"
	let phoneBook3 = Map.delete "bob" phoneBook2
	print $ Map.lookup "bob" phoneBook3 -- => Nothing
~~~~

Haskellではまず`Data.Map`モジュールを使用するためにこれを修飾つきで`impomt`する。これは`Prelude`の関数と`Data.Map`の関数が一部重複するため、明示的に`Map`を指定しなければ`Data.Map`の関数を呼び出せない形でインポートするためである。Rubyの`Hash`とHaskellの`Data.Map`の基本的なメソッドの対応は以下のとおり。

|Ruby|Data.Map|意味|
|:-|:-|:-|
|\{\}リテラル|Data.Map.fromList|連想配列を初期化する|
|[]|Data.Map.lookup|キーに対応する値を取得する|
|store|Data.Map.insert|キーに対応する値を設定する|
|delete|Data.Map.delete|キーとその値を削除する|
{: .table .table-striped}

Haskellでは`fromLinst`を使ってタプル(ペア)のリストから連想配列を初期化できる。
Haskellの関数はいずれも連想配列自体は変更せずに、新しい連想配列を返すようになっている。
そのため`insert`や`delete`毎に新しい連想配列を変数に束縛している。
これはちょっと不恰好に見えるのだが、直接連想配列を操作する方法は見当たらなかった。

注目すべきは`lookup`関数の型である。これをGHCiで調べてみると以下のように`Maybe`がついた特別な型が返ることがわかる。これはその型の値か、Nothingが返ることを意味している。実際、電話帳から`bob`の項目を削除したあとで`bob`を検索すると`Nothing`が返ってくることがわかる。

~~~~
*Main> :t Map.lookup
Map.lookup :: Ord k => k -> Map.Map k a -> Maybe a
~~~~

なおHaskellのプログラムで頻出している`$`、`$`に続く関数の評価を優先して行うためのシンタックスシュガーである。`print`の例では`print $ 1 + 1`と`print (1 + 1)`が等価である。`$`以降がすべて括弧で囲われているものと思えば良い。

電話帳を題材にした`Data.Map`の使い方については、"すごいHaskellたのしく学ぼう!"の6章を参考にした。本書ではまず自力でタプルとリストを使った連想リストを実装したあとに、`Data.Map`を導入する流れとなっており、良い勉強になる。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4274068854/xmisao-22/ref=nosim/" name="amazletlink" target="_blank"><img src="http://ecx.images-amazon.com/images/I/51P6NdS4IGL._SL160_.jpg" alt="すごいHaskellたのしく学ぼう!" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4274068854/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">すごいHaskellたのしく学ぼう!</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 14.01.09</div></div><div class="amazlet-detail">Miran Lipovača <br />オーム社 <br />売り上げランキング: 126,678<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4274068854/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>
