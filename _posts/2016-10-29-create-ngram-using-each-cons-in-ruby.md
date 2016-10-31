---
layout: blog
title: RubyのEnumerable#each_consを使ってN-gramを簡単に作る
tag: ruby
last_update: '2016-11-01'
---

# はじめに

Rubyでは`Enumerable#each_cons`を使って簡単にN-gramを作ることができます。

このエントリは[kawasaki.rb #41](http://kawasakirb.connpass.com/event/43240/)で、パーフェクトRubyの"5-5-1 Enumerableなオブジェクト"を読んだことをきっかけに書きました。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4774158798/xmisao-22/ref=nosim/" name="amazletlink" target="_blank"><img src="https://images-fe.ssl-images-amazon.com/images/I/51K0jUf%2BiEL._SL160_.jpg" alt="パーフェクトRuby (PERFECT SERIES 6)" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4774158798/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">パーフェクトRuby (PERFECT SERIES 6)</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 16.10.29</div></div><div class="amazlet-detail">Rubyサポーターズ すがわら まさのり 寺田 玄太郎 三村 益隆 近藤 宇智朗 橋立 友宏 関口 亮一 <br />技術評論社 <br />売り上げランキング: 74,779<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4774158798/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>

# N-gram

N-gramは文字列をN文字単位で区切って1要素としたものです。

N-gramは全文検索を高速に行うためのインデックスとして良く使われます。
Nが2のものをbi-gram(バイグラム)、Nが3のものをtri-gram(トライグラム)と呼びます。
Nが4以上は応用例が少なくメジャーでないためか、私は聞いたことがありません。

例えば最初の文章をbi-gramで表現して並べると以下のとおりです。
文字列の先頭からはじめて、1文字ずつずらしながら、2文字単位で1要素としていきます。

~~~~
N- -g gr ra am mは は文 文字 字列 列を をN N文 文字 字単 単位 位で で区 区切 切っ って て1 1要 要素 素と とし した たも もの ので です す。
~~~~

# Enumerable#each_cons

Rubyでは`Enumerable#each_cons`を使って、このようなN-gramを簡単に作ることができます。

Enumerable#each_consの[Rubyリファレンスマニュアル](https://docs.ruby-lang.org/ja/latest/method/Enumerable/i/each_cons.html)の解説は以下のとおりです。

> 要素を重複ありで n 要素ずつに区切り、 ブロックに渡して繰り返します。
>
> ブロックを省略した場合は重複ありで n 要素ずつ繰り返す Enumerator を返します。 

ほぼ同じメソッドに`Enumerable#each_slice`がありますが、"重複ありで"の部分がポイントです。
このメソッドは実際に使ってみないと、なかなか用途に気づきにくいかも知れません。

Enumerable#each_consはRuby 1.8.7や1.9以降では何もしなくても使えます。
Ruby 1.8.6では`enumerator`モジュールで使えるようです。

# each_consで文字列をN-gramにする例

文字列を入力にbi-gramを作ってみます。
この例ではbi-gramの各要素を2文字の文字列で表現し、それを配列にして出力することにします。

~~~~ruby
"I love Ruby!".each_char
              .each_cons(2)
              .map{|chars| chars.join }
#=> ["I ", " l", "lo", "ov", "ve", "e ", " R", "Ru", "ub", "by", "y!"]
~~~~

簡単ですね。メソッドチェーンを使えば、実質一行で書くことができます。

一応、処理を分解してみます。

まず`String#each_char`を使って、文字列中の文字を1文字つずつ取り出すEnumeratorオブジェクトを得ます。

EnumeratorオブジェクトはEnumerableの機能を提供するラッパクラスです。
よって`Enumerable#each_cons`に引数`2`を与えて使えば、2要素ごとに区切った配列を返すEnumeratorが得られます。

このEnumeratorから取り出せる値は`['a', 'b']`のような配列です。
配列の要素を`Array#join`で結合するよう、`Enumerable#map`で処理すればbi-gramの配列になります。

`Enumerable#each_slice`は引数で与えた任意の要素数で区切ってくれます。
単に引数を`3`にすれば、tri-gramも同じ要領で作れます。

~~~~ruby
"I love Ruby!".each_char
              .each_cons(3)
              .map{|chars| chars.join }
#=> ["I l", " lo", "lov", "ove", "ve ", "e R", " Ru", "Rub", "uby", "by!"]
~~~~

簡単にN-gramが作れるようにStringクラスに`to_ngram`メソッドを追加してみるとこんな感じでしょうか。

~~~~ruby
class String
  def to_ngram(n)
    self.each_char
        .each_cons(n)
        .map{|chars| chars.join }
  end
end

"I love Ruby!".to_ngram(2)
#=> ["I ", " l", "lo", "ov", "ve", "e ", " R", "Ru", "ub", "by", "y!"]

"I love Ruby!".to_ngram(3)
#=> ["I l", " lo", "lov", "ove", "ve ", "e R", " Ru", "Rub", "uby", "by!"]
~~~~

# 余談

kawasaki.rb #41では`Array#*`は引数に文字列を渡すと`Array#join`と同じ働きをするので、配列を結合してN-gramにする部分は以下のように書けるという話題もありました。

~~~~ruby
chars = ['a', 'b']

chars.join #=> "ab"

chars * '' #=> "ab"
~~~~

玄人感が高まりました。

仮に無駄なスペースを省くと、配列に`*''`の3文字を足すだけで結合でき、`.join`より2文字短くできます。
コードゴルフでは役に立ちそうですが、この例ではjoinを使った方が無難です。

# さらに良い書き方

`map`のブロック内で`join`するより`map &:join`を使うと良い、という[コメント](https://twitter.com/pink_bangbi/status/792658771797348352)をTwitterでいただきました。
ご指摘ごもっともです。この書き方で`String.to_ngram`を書き直すとすっきりしますね。

~~~~ruby
class String
  def to_ngram(n)
    self.each_char
        .each_cons(n)
        .map(&:join)
  end
end
~~~~

# おわりに

kawasaki.rbは和気あいあいとした楽しい地域Rubyコミュニティです。
次回kawasaki.rb #42は11月30日(水)にJR川崎駅徒歩3分のミューザ川崎で開催予定です。
開催が近づくと[Connpass](http://kawasakirb.connpass.com/event/)で告知が出ます。

みなさまもぜひお越しください。
