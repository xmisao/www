---
layout: blog
title: RubyのMarshalによる配列やハッシュのディープコピー
tag: ruby
---



Rubyでmarshalライブラリの`Marshal.dump`と`Marshal.load`を使えば、Rubyの配列やハッシュを簡単にディープコピーすることができる。以下はそのサンプルコード。

~~~~
a = ['foo', 'bar', 'baz']
b = Marshal.load(Marshal.dump(a)) # Marshalによるディープコピー

a.map!{|i| i.upcase } # 元の配列を破壊的に変更

p a #=> ["FOO", "BAR", "BAZ"]
p b #=> ["foo", "bar", "baz"]
~~~~

複雑に組み合わさった配列やハッシュでも全く同じ方法でディープコピーできるため、自力でディープコピーの処理を実装するよりかなり簡単である。

もともとシリアライズの機能を提供するmarshalライブラリをこんな形で使うというのは少々トリッキーではあるが、テクニックといえばテクニックかも知れない。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4797359986/xmisao-22/ref=nosim/" name="amazletlink" target="_blank"><img src="https://images-fe.ssl-images-amazon.com/images/I/413L9xSXxvL._SL160_.jpg" alt="Rubyレシピブック 第3版 303の技" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4797359986/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Rubyレシピブック 第3版 303の技</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 14.05.18</div></div><div class="amazlet-detail">青木 峰郎 後藤 裕蔵 高橋 征義 <br />ソフトバンククリエイティブ <br />売り上げランキング: 284,046<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4797359986/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>

