---
layout: blog
title: BestGems Pickup! 第5回 「formatador」
tag: bestgems_pickup
---

# BestGems Pickup! 第5回 「formatador」

拙作の[BestGems](http://bestgems.org/)から注目のGemを紹介するエントリー。第5回は「[formatador](https://github.com/geemus/formatador)」を取り上げる。

## 概要

formatadorは標準出力にテキストを整形して出力するライブラリだ。手動では煩わしいテキストの色付けや、テキストによる表組み、プログレスバーの実装まで可能だ。

formatadorは今日現在、合計ダウンロードランキング115位、デイリーダウンロードランキング77位につけている。

## インストール

    gem install formatador

## 使用例

### テキストの出力と装飾

formatadorの機能は、すべてFormatadorクラスのクラスメソッド呼び出しで利用できる。もちろんインスタンスを生成しても良い。

例えば、以下のコードは、標準出力にHello, World!を出力する。

~~~~
Formatador.display_line('Hello, World!')
~~~~

~~~~
  Hello, World!
~~~~

Formatadorには、以下4つの基本的なメソッドがある。引数はいずれも文字列だ。

|メソッド|機能|
|:=|:=|
|format|STDOUTが標準出力なら、文字列にカラーコードを追加して返す|
|display|文字列をformatすると共に、出力する|
|display_line|文字列に改行を加えてdisplayする|
|redisplay|最後の行に上書きして、文字列をdisplayする|
{: .table .table-striped}

文字列はHTMLライクなタグを使って、カラーコードで装飾できる。例えば以下のコードでは、緑色のHello, World!を表示する。

~~~~
Formatador.display_line('[green]Hello, World![/]')
~~~~

タグは以下3種類がある。

|タグ|意味|
|:=|:=|
|\[スタイル\]|テキストのスタイルを変更する|
|\[\_スタイル\_\]|テキストの背景色を変更する|
|\[/]|スタイルと背景色の指定をクリアする|
{: .table .table-striped}

なおスタイルで指定できる色は以下だ。

|指定|意味|
|:=|:=|
|black|黒|
|red|赤|
|green|緑|
|yellow|黄色|
|blue|青|
|magenta|マゼンタ|
|purple|紫|
|cyan|シアン|
|white|白|
|light_black_|灰色|
|light_red|明るい赤|
|light_green|明るい緑|
|light_yellow|明るい黄色|
|light_blue|明るい青|
|light_magenta|明るいマゼンタ|
|light_purple|明るい紫|
|light_cyan|明るいシアン|
{: .table .table-striped}

色の他に以下のスタイルも指定できる。

|指定|意味|
|:=|:=|
|bold|太字|
|underline|下線|
|blink_slow|遅い点滅|
|blink_fast|早い点滅|
|negative|文字色と背景色の反転|
|normal|文字色をデフォルトに戻す|
|blink_off|点滅をなしに戻す|
|positive|文字色と背景色を元に戻す|
{: .table .table-striped}

### 表、プログレスバー、インデント

テキストの装飾が簡単にできるだけでも強力だが、Formatadorにはさらに以下の拡張メソッドがある。

|メソッド|機能|
|:=|:=|
|display_table|テーブルを表示する|
|display_compact_table|テーブルを表示する、ただし横線を省略する|
|redisplay_progressbar|プログレスバーを表示する|
|indent|インデントを深くする|
{: .table .table-striped}

`display_table`と`display_compact_table`は、いずれもハッシュの配列を表形式で表示するメソッドだ。オプションで第2引数にキーの配列を与えると、列の順序と表示/非表示を切り替えられる。サンプルは以下のとおり。

~~~~
data = [
	{:foo => '123', :bar => '456', :buz => '789'},
	{:foo => 'abc', :bar => 'def', :buz => 'ghi'},
	{:foo => 'alpha', :bar => 'beta', :buz => 'gamma'},
]

Formatador.display_table(data, [:bar, :buz])
Formatador.display_compact_table(data, [:bar, :buz])
~~~~

~~~~
  +------+-------+
  | bar  | buz   |
  +------+-------+
  | 456  | 789   |
  +------+-------+
  | def  | ghi   |
  +------+-------+
  | beta | gamma |
  +------+-------+
~~~~
~~~~
  +------+-------+
  | bar  | buz   |
  +------+-------+
  | 456  | 789   |
  | def  | ghi   |
  | beta | gamma |
  +------+-------+
~~~~

`redisplay_progressbar`はプログレスバーを表示するメソッドだ。このメソッドを適当なタイミングで呼び出すことで進捗をリアルタイムで表せる。サンプルは以下のとおり。

~~~~
started_at = Time.now - 1000
Formatador.redisplay_progressbar(42, 100, {:started_at => started_at})
~~~~

~~~~
     42/100  |*********************                             |  16:40  
~~~~

`redisplay_progressbar`の第1引数は現在の進捗、第2引数は合計、第3引数はオプションで、ハッシュで以下の要素が渡せる。

|キー|機能|
|:=|:=|
|:color|バーの色を文字列で指定する。デフォルトは白。|
|:width|バーの幅を数値で指定する。デフォルトは50。|
|:new_line|バーを出力した後に改行するかを真偽値で指定する。|
|:started_at|開始時間をTime型で与える。このオプションを指定すると、完了予想時間を表示する。|
{: .table .table-striped}

`indent`メソッドを使えば、出力をインデントできる。

~~~~
require 'formatador'

Formatador.display_line 'hoge'
Formatador.indent do
	Formatador.display_line 'piyo'
	Formatador.indent do
		Formatador.display_line 'fuga'
	end
end
~~~~

~~~~
  hoge
    piyo
      fuga
~~~~

## 解説

formatadorを使えば、美しい出力のコマンドラインツールを簡単に作ることができる。[前回のBestGems Pickup!](http://www.xmisao.com/2013/08/25/bestgems-pickup-slop.html)で取り上げたコマンドラインオプションのパーサ[Slop](https://github.com/leejarvis/slop)を併用すれば、使いやすく、見やすいツールを最小の手間で実現できるだろう。どちらも現時点では日本語の解説をほとんど見かけないが、非常に強力なGemだ。
