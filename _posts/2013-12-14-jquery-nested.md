---
layout: blog
title: 超簡単! jQuery Nestedによる動的グリッドレイアウト
tag: ['javascript', 'web']
---

# 超簡単! jQuery Nestedによる動的グリッドレイアウト

![Mondrian Composition]({{ site.url }}/assets/2013_12_14_nested_mondrian.png)

*jQuery Nestedで描いたモンドリアンのコンポジション*

## jQuery Nestedとは

- [jQuery Nested (github)](https://github.com/suprb/Nested)
- [jQuery Nested Demo](http://suprb.com/apps/nested/)

jQuery Nestedは動的なグリッドレイアウトを自動的に行なってくれるjQueryプラグインだ。所定の方法でマークアップしておけば、JavaScript 1行で、横幅に応じて自動的にグリッドレイアウトを行なうことができる。

## jQuery Nestedの使い方

jQuery Nestedを使うにはjQueryとjQuery NestedのJavaScriptファイルを読み込んでやる必要がある。
jQuery Nestedは1ファイルで、ダウンロードするだけでするに利用できる。
以降では、簡単なサンプルを書いたので、これを使ってjQuery Nestedの使い方を説明していく。
サンプルは、以下のディレクトリ構造でHTMLファイルとJavaScriptが配置されているものとする。

~~~~
/sample1.html
/sample2.html
/sample3.html
/mondrian.html
/js/jquery-1.10.2.min.js
/js/jquery.nested.js
~~~~

### Sample.1 マークアップとjQuery Nestedの呼び出し

![Sample.1]({{ site.url }}/assets/2013_12_14_nested_sample1.png)

- [sample1.html]({{ site.url }}/assets/samples/nested/sample1.html)

jQuery Nestedでレイアウトを行うには所定のクラス名でブロック要素を修飾してやる必要がある。
レイアウト対象となるデフォルトのクラス名は`box`だ。
さらにボックスのサイズを`sizeWH`の形式で指定してやる。
例えば`size12`は幅1で高さ2のボックスとなる。
jQuery Nestedは呼び出し時にレイアウト対象の要素を指定するので、`div`にidを付けて全体を囲ってやろう。

~~~~
<div id="content" style="width:320px; background-color:#fff">
	<div class="box size11" style="border:dashed 1px;">1x1</div>
	<div class="box size21" style="border:dashed 1px;">2x1</div>
	<div class="box size31" style="border:dashed 1px;">3x1</div>
	...
</div>
~~~~

続いてJavaScriptでjQuery Nestedの呼び出しを行う。
jQuery NestedをロードするとjQueryの要素が拡張されて`nested()`関数が利用できるようになる。
先ほどのdiv要素のidをセレクタにして、`nested()`を呼びだそう。
これだけで`content`id要素内の`box`クラスが動的グリッドレイアウトされる。

~~~~
$("#content").nested();
~~~~

### Sample.2 jQuery Nestedのオプションについて

![Sample.2]({{ site.url }}/assets/2013_12_14_nested_sample2.png)

- [sample2.html]({{ site.url }}/assets/samples/nested/sample2.html)

`nested()`関数は連想配列でオプションを受け取る。
オプションによりボックスの幅やアニメーションの挙動を設定することができる。
以下はオプションを指定して`nested()`を呼び出す例である。

~~~~
settings = {
	selector: '.box', // セレクタはboxクラス
	minWidth: 100, // ボックスの幅の単位は100px
	minColumns: 10, // 最低10単位(100px x 10単位 = 1000px)の幅のボックスをレイアウトする
	gutter: 10, // ボックス間の間隔は10px
	resizeToFit: true, // 空白より大きなボックスを空白に合うまでリサイズする
	resizeToFitOptions: {
			resizeAny: true // 空白より大きいまたは小さなボックスを空白に合うまでリサイズする
	},
	animate: true, // ボックスのレイアウトにアニメーションを使用
	animationOptions: {
			speed: 200, // 各オブジェクトのレンダリング速度は200ms
			duration: 300, // アニメーション実行間隔は300msごと
			queue: true, // オブジェクトを1つずつ順番にアニメーションさせる
			complete: function () { alert("Animation Completed."); } // アニメーション完了後にアラートを表示する
	}
};
$("#content").nested(settings);
~~~~

jQuery Nestedのオプションを以下にまとめる。
たくさんあるが主に利用するのは`minWidth`、`gutter`、`animate`あたりだろう。

|オプション||デフォルト|意味|
|:-|:-|:-|:-|
|selector||.box|レイアウトするボックスのjQueryセレクタを指定する。デフォルトはboxクラスの要素をレイアウトする。|
|minWidth||50|ボックスの幅を指定する。デフォルトは50px幅を1単位としてボックスを描画する。|
|minColumns||1|1列に最低で何単位の幅のボックスをレイアウトするか指定する。デフォルトは1で特に制限はない。|
|gutter||1|ボックスとボックスの間の間隔を指定する。デフォルトは1px幅を空ける。|
|resizeToFit||true|真偽値をとりtrueであれば、空白より大きなボックスを空白に合うようリサイズする。|
|resizeToFitOptions|resizeAny|true|真偽値をとりtrueであれば、空白より大きいまたは小さなボックスを空白に合わせてリサイズする。|
|animate||true|真偽値をとりボックスをレイアウトする際のアニメーションの有効/無効を指定する。デフォルトではアニメーションする。|
|animationOptions|speed|20|各オブジェクトをレンダリングする時間をミリ秒単位で指定する。デフォルトは20ミリ秒。|
||duration|100|アニメーションを実行する時間の間隔をミリ秒単位で指定する。デフォルトは100ミリ秒。|
||queue|true|真偽値をとりオブジェクトを順番にレイアウトするか指定する。falseとすると全オブジェクトのアニメーションが一気に実行される。|
||complete|function()|アニメーション完了時に実行する関数を指定する。デフォルトでは何も実行しない。|
{: .table .table-striped}

### Sample.3 ボックスの動的な追加と再描画

![Sample.3]({{ site.url }}/assets/2013_12_14_nested_sample3.png)

- [sample3.html]({{ site.url }}/assets/samples/nested/sample3.html)

jQuery Nestedではレイアウト対象の要素を動的に追加することができる。
要素を追加して再描画が必要になったタイミングで`nested()`を呼び出せば良い。
これで追加した要素もアニメーションが適用されて自動的にグリッドレイアウトされる。
以下は先頭と末尾に要素を追加して、再描画を行う例である。

~~~~
// 要素を末尾に追加して再描画する
function append(){
	$("#content").append(create_element());
	$("#content").nested(settings);
}

// 要素を先頭に追加して再描画する
function prepend(){
	$("#content").prepend(create_element());
	$("#content").nested(settings);
}

// 要素の生成
function create_element(){
	var w = Math.floor(Math.random() * 3) + 1;
	var h = Math.floor(Math.random() * 3) + 1;
	return '<div class="box size' + w + h + '" style="border:dashed 1px;">' + w + 'x' + h + '</div>'
}
~~~~

### おまけ モンドリアンのコンポジション

- [mondrian.html]({{ site.url }}/assets/samples/nested/mondrian.html)

jQuery Nestedでモンドリアンのコンポジション風のWebページを描画してみた。冒頭の画像がその結果だ。
簡単なHTMLとわずかなJavaScriptでこれが描けるのだから、jQuery Nestedの表現力を確認することができるだろう。
