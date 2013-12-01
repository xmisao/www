---
layout: blog
title: Rubyの特異クラスによるシングルトンの実装
tag: ruby
---

# Rubyの特異クラスによるシングルトンの実装

インスタンスの生成を制限したシングルトンを、Rubyの特異クラスを使って実装してみよう。
`SingletonClass`をシングルトンクラスとする。このクラスの生成`SingletonClass.new`を不可能にして、インスタンスの取得は`SingletonClass.get_instance`でのみ可能とする。

~~~~
# シングルトン保持用の定数
SINGLETON_OBJECT = Object.new

# 特異クラス定義式による特異クラスの定義
class << SINGLETON_OBJECT
	def only_method
		:only_method
	end
end

=begin
# 注) 上記はSINGLETON_OBJECTに
#     特異メソッドを定義する以下と同様
def SINGLETON_OBJECT.only_method
	:only_method
end
=end

# シングルトンを得るための特異クラスの作成
SingletonClass = SINGLETON_OBJECT.singleton_class

# 特異クラスのクラスメソッド(クラスの特異メソッド)の定義
def SingletonClass.get_instance
	SINGLETON_OBJECT
end

# シングルトンの確認
p SINGLETON_OBJECT # => #<Object:0x000000026504f8> 
p SingletonClass # => #<Class:#<Object:0x000000026504f8>>
p SingletonClass.get_instance # => 
#<Object:0x000000026504f8>
~~~~

サンプルコードの出典は、パーフェクトRubyの6-3-8から。(一部改変)

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4774158798/xmisao-22/ref=nosim/" name="amazletlink" target="_blank"><img src="http://ecx.images-amazon.com/images/I/51K0jUf%2BiEL._SL160_.jpg" alt="パーフェクトRuby (PERFECT SERIES 6)" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4774158798/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">パーフェクトRuby (PERFECT SERIES 6)</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 13.12.01</div></div><div class="amazlet-detail">Rubyサポーターズ すがわら まさのり 寺田 玄太郎 三村 益隆 近藤 宇智朗 橋立 友宏 関口 亮一 <br />技術評論社 <br />売り上げランキング: 10,788<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4774158798/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>

