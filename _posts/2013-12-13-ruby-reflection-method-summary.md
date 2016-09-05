---
layout: blog
title: Rubyのリフレクションプログラミングまとめ
tag: ruby
---



Rubyは強力なリフレクション機能を持った言語であり、多様なリフレクション用メソッドが存在する。
このエントリではRubyでリフレクションプログラミングを行うためのメソッドを整理してみることにする。

# オブジェクトに対する操作

## インスタンス変数に関連する操作

インスタンス変数に対する操作には以下がある。

|#|メソッド|機能|
|:-|:-|:-|
|1|instance_variables|一覧を取得する|
|2|instance_variable_defined?|定義の有無を確認する|
|3|instance_variable_get|値を参照する|
|4|instance_variable_set|値を設定する|
{: .table .table-striped}

## メソッドに関連する操作

メソッドの一覧を表示する。取得するメソッドの種類毎に以下のメソッドがある。

|#|メソッド|取得するメソッドの種類|
|:-|:-|:-|
|1|methods|privateメソッド以外|
|2|public_methods|publicメソッド|
|3|protected_methods|protectedメソッド|
|4|private_methods|privateメソッド|
|5|singleton_methods|特異メソッド|
{: .table .table-striped}

ある名前のメソッドが存在するかは`respond_to?`で確認できる。

|#|メソッド|機能|
|:-|:-|:-|
|1|respond_to?|メソッドの有無を確認する|
{: .table .table-striped}

ある名前のメソッドを呼び出すには`send`または`__send__`が利用できる。

|#|メソッド|機能|
|:-|:-|:-|
|1|send|メソッドの呼出|
|2|__send__|同上|
{: .table .table-striped}

# クラス/モジュールに対する操作

## クラス変数に関連する操作

クラス変数に対する操作には以下がある。

|#|メソッド|機能|
|:-|:-|:-|
|1|class_variables|一覧を取得する|
|2|class_variable_defined?|定義の有無を確認する|
|3|class_variable_get|値を参照する|
|4|class_variable_set|値を設定する|
{: .table .table-striped}

## 定数に関連する操作

定数に対する操作には以下がある。

|#|メソッド|機能|
|:-|:-|:-|
|1|constants|一覧を取得する|
|2|const_get|定数を参照する|
|3|const_set|新たな定数を追加する|
{: .table .table-striped}

## メソッドに関連する操作

メソッドの一覧を表示する。取得するメソッドの種類毎に以下のメソッドがある。

|#|メソッド|取得するメソッドの種類|
|:-|:-|:-|
|1|methods|クラスメソッド|
|2|instance_methods|インスタンスメソッド|
|3|public_instance_methods|publicインスタンスメソッド|
|4|protected_instance_methods|protectedインスタンスメソッド|
|5|private_instance_methods|privateインスタンスメソッド|
{: .table .table-striped}

ある名前のメソッドの定義の有無を確認する。確認するメソッドの種類毎に以下のメソッドがある。

|#|メソッド|確認するメソッドの種類|
|:-|:-|:-|
|1|method_defined?|privateメソッド以外|
|2|public_method_defined?|publicメソッド|
|3|protected_method_defined?|protectedメソッド|
|4|private_method_defined?|privateメソッド|
{: .table .table-striped}

クラスやモジュールのインスタンスメソッドを削除または未定義化する以下のメソッドがある。

|#|メソッド|機能|
|:-|:-|:-|
|1|remove_method|メソッドを削除する|
|2|undef_method|メソッドを未定義にする|
{: .table .table-striped}

## 継承に関連する操作

クラスの継承やincludeの情報を取得するメソッドには以下がある。

|#|メソッド|機能|
|:-|:-|:-|
|1|ancestors|メソッド探索の順序を取得する|
|2|superclass|親クラスを取得する|
|3|included_modules|includeしているモジュールを取得する|
{: .table .table-striped}

クラス内で定義されたクラスのネスト構造は`nesting`で取得できる。

|#|メソッド|機能|
|:-|:-|:-|
|1|nesting|ネスト構造を深い方から浅い方の順で取得する|
{: .table .table-striped}

なおRubyのリフレクション機能については、パーフェクトRubyの10章に具体的な説明がある。
本エントリもパーフェクトRubyの10章を参考にまとめたものだ。
例を交えて非常にわかりやすく解説されているので、詳しく知りたい人はぜひ参照して欲しい。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4774158798/xmisao-22/ref=nosim/" name="amazletlink" target="_blank"><img src="http://ecx.images-amazon.com/images/I/51K0jUf%2BiEL._SL160_.jpg" alt="パーフェクトRuby (PERFECT SERIES 6)" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4774158798/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">パーフェクトRuby (PERFECT SERIES 6)</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 13.12.01</div></div><div class="amazlet-detail">Rubyサポーターズ すがわら まさのり 寺田 玄太郎 三村 益隆 近藤 宇智朗 橋立 友宏 関口 亮一 <br />技術評論社 <br />売り上げランキング: 10,788<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4774158798/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>
