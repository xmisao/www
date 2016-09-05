---
layout: blog
title: RMagickによるオンメモリの画像処理
tag: ['ruby', 'programming']
---



RMagickはImageMagickをRubyで使えるようにしたラッパーである。

今回このRMagickでファイルを介さずオンメモリで画像処理を行いたい要件があったのだが、ざっと調べてもオンメモリでRMagickを使用する例が見当たらなかった。ImageMagickは基本的にファイルを別のファイルに変換する使い方をするためだろう。

そこでRMagickとImageMagickのAPIを眺めていたら、`from_blob`と`to_blob`というAPIを使えばオンメモリで処理が可能だとわかったので、これらのAPIの使い方を書き残しておこうと思う。

この方法は、変換元の画像がリモートに存在する場合や、出力先がファイルではなくデータベースである場合などで、中間ファイルを生成せずにRMagickによる画像処理を行う際に利用できる。

# 画像の入力

`ImageList`のインスタンスが欲しい場合は、いったん空の`ImageList`を生成してから、`ImageList#from_blob`を呼ぶ。変数`data`には事前に読み込んだ画像のバイナリデータが格納されているものとする。

~~~~
imagelist = RMagick::ImageList.new
imagelist.from_blob(data)
~~~~

`ImageList`ではなく`Image`が欲しい場合は、`Image.from_blob`で直接`Image`インスタンスの配列を得ることもできる。画像が複数枚で構成されるケースがあるので、このメソッドの返却値は`Image`ではなく配列であることに注意しよう。画像のバイナリデータから最初の`Image`インスタンスを取得する例を以下に示す。

~~~~
image = RMagick::Image.from_blob(data)[0]
~~~~

# 画像の出力

`Image`または`ImageList`の画像のバイナリデータを得るには`to_blob`メソッドを使う。以下の例は変数`data`に画像`image`のバイナリデータを保存する例である。

~~~~
data = image.to_blob
~~~~

`to_blob`メソッドはブロックでオプションを指定することができる。オプションには出力する画像の形式や品質を指定できる。以下は`image`の画像を品質60のJPEG画像に変換して、そのバイナリデータを得る例である。

~~~~
data = image.to_blob do
	self.format = "JPG"
	self.quality = 60
end
~~~~
