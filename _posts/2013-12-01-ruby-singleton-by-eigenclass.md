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

<iframe src="http://rcm-fe.amazon-adsystem.com/e/cm?t=xmisao-22&o=9&p=8&l=as1&asins=4774158798&ref=tf_til&fc1=000000&IS2=1&lt1=_blank&m=amazon&lc1=0000FF&bc1=000000&bg1=FFFFFF&f=ifr" style="width:120px;height:240px;" scrolling="no" marginwidth="0" marginheight="0" frameborder="0"></iframe>
