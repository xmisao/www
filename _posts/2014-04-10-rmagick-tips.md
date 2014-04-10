---
layout: blog
title: RMagickによる画像生成と文字の描画など
tag: ruby
---

# RMagickによる画像生成と文字の描画など

お遊びで[よく使うハンドサイン画像ジェネレータ](http://handsign.xmisao.com/)を作った時に覚えたRMagickの使い方をメモする。

なお以下のソースコードはすべて事前に`require 'RMagick'`して`include Magick`されているものとする。

## 画像の読み込みと生成

画像をRMagickで読み込むには`ImageList.new`を使う。引数にはパスを指定する。

~~~~
imagelist = ImageList.new('foo.jpg')
~~~~

空白の画像を新たに生成するには`Image.new`を使う。引数には幅と高さを指定する。

~~~~
image = Image.new(640, 480)
~~~~

`ImageList`は`Image`の集合体である。
複数のファイルを同時に読み込む場合があることや、GIFやTIFFなど1ファイルに複数の画像を含む画像フォーマットがあるため、このような仕組みになっている。

さらに補足となるが、`ImageList`から`Image`を取り出すには、`ImageList#cur_image`を使う。このメソッドは`ImageList#scene`が示すインデックスの画像を`Image`オブジェクトで返す。

## 文字の描画

画像に線や文字を描画するには`Draw`オブジェクトを使う。`Draw`オブジェクトは描画時の各種プロパティを保持し、`Draw`オブジェクトのメソッド呼び出しで実際に描画を行う際はそのプロパティに従って描画される。

文字を描画するにあたって重要なのはフォントの指定である。デフォルトでは英語のフォントしか使えないため、日本語を描画しようとすると正しく描画されない。フォントの指定は`Draw#font=`でフォントやフォントファイルのパスを指定する。

~~~~
draw = Draw.new
draw.font = 'mplus-1c-regular.ttf' # カレントディレクトリのフォントファイルを指定する例
~~~~

文字の描画に関わる他のプロパティとして、文字のフォントサイズを指定する`Draw#pointsize`や、文字の描画位置を指定する`Draw#gravity`がある。以下はフォントサイズを16ptに、文字を上下左右に中央寄せで描画するように指定する例である。

~~~~
draw.pointsize = 16
draw.gravity = CenterGravity
~~~~

## 画像の描画

ある画像の内容をそのまま別の画像に描画するには、`Image#composite`を利用する。メソッドのレシーバになる画像に、引数で与えた画像の内容が描画される。引数には画像と描画するX座標とY座標、オプションを与える。画像は`Image`でも`ImageList`でも構わない。オプション`Magick::OverCompositeOp`は画像を上書き描画する指定である。

~~~~
dest.compoiste(src, 100, 200, OverCompositeOp)
~~~~

## 画像の表示

画像を画面で確認するには`Image#display`または`ImageList#display`を使う。この命令が実行されるとウィンドウがポップアップして画像が表示される。ウィンドウが閉じられるまで処理はブロックするので、あくまでデバッグ用である。

~~~~
image.display
~~~~

## 画像の保存

画像の保存は`Image#write`または`ImageList#write`で行う。
引数にはファイルのパスを指定する。
画像のフォーマットはパスで指定した拡張子に応じて自動的に決まる仕組みである。

~~~~
image.write('foo.jpg')
~~~~
