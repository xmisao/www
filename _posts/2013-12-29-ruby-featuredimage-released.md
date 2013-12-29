---
layout: blog
title: Webページから目を引く画像を抽出してサムネイル化するFeaturedImageというGemを作った
tag: ruby
---

# Webページから目を引く画像を抽出してサムネイル化するFeaturedImageというGemを作った

![FeaturedImage]({{ site.url }}/assets/2013_12_29_featuredimage.jpg)

はてなブックマークの一覧ページは、ブックマーク先のサイトの画像をサムネイルとして使って、利用者の目を引くようにデザインされている。任意のWebページに対して、あれに近いことを自分でもやりたいと思った。

ブログでいういわゆるアイキャッチ画像(※)を抽出して、いい感じのサムネイルを生成したい。ここ何日かごにょごにょしていたらそれなりに動くものができたので、思い切ってオープンソースにすることにした。その成果がFeaturedImageというGemである。

(※)ちょっと調べたところアイキャッチは和製英語だそうで、英語ではFeatured Imageなどと呼ぶ、らしい。実はこれも自信なし。

## FeaturedImageとは

- [FeaturedImage](https://github.com/xmisao/featuredimage)

FeaturedImageはWebページから目を引く画像(以下、注目画像)を抽出するGemである。

抽出機能では、MechanizeでWebページを解析し、IMGタグを見つけて画像をダウンロード、RMagickで画像の大きさを測って注目画像を決定する。

さらにFeaturedImageは注目画像の中央付近を切り抜いて任意のサイズにリサイズするサムネイル生成機能も備えている。

## インストール

~~~~
gem install featuredimage
~~~~

## 使用例

この例が本エントリ冒頭の画像である。
Wikipediaのレナのページから、注目画像を抽出して、サムネイルを生成している。結果、レナの顔付近のサムネイルが生成される。

~~~~
require 'featuredimage'

# Webページから最初の注目画像を見つける
featuredimage = FeaturedImage::Finder.first('http://en.wikipedia.org/wiki/Lenna')

# 注目画像をサムネイルに変換する
thumbnail = FeaturedImage::Converter.convert(featuredimage, 180, 120) # バイナリデータ文字列を返す

# バイナリデータをファイルに保存する
open('thumbnail.jpg', 'w'){|f| f.write thmbnail}
~~~~

## APIリファレンス

### 基本的なAPI

基本的なAPIは注目画像を抽出する3つのAPIと、注目画像からサムネイルを生成する1つのAPI、合計4つのAPIを用意した。

|API|解説|
|:-|:-|
|FeaturedImage::Finder.first|指定した条件に合致する最初に見つけた注目画像を返す。返却値はMagick::ImageListか、注目画像が見つからなければnilを返す。|
|FeaturedImage::Finder.biggest|指定した条件に合致する注目画像のうちサイズが最大のものを返す。返却値はMagick::ImageListか、注目画像が見つからなければnilを返す。|
|FeaturedImage::Finder.all|指定した条件に合致するすべての注目画像をMagick::ImageListのArrayにして返す。注目画像が見つからなければ空のArrayを返す。|
|FeaturedImage::Converter.convert|画像を任意のサイズのサムネイルに変換してバイナリデータの文字列として返す。デフォルトのフォーマットは圧縮品質60のJPEGである。|
{: .table .table-striped}

上記のAPIに従わずに、`FeaturedImage::Finder`や`FeaturedImage::Converter`のインスタンスを直接生成して利用することもできるが、ここでは解説しない。

### 検索条件

`FeaturedImage::Finder`のAPIは注目画像とみなす画像の条件を、検索条件としてさまざまな形で指定できる。以下はその例である。

検索条件を指定しない。サイズやアスペクト比に関わらず、すべての画像が注目画像とみなされる。

~~~~
FeaturedImage::Finder.first URL
~~~~

アスペクト比指定の検索条件。アスペクト比が4:3から16:9の画像のみ注目画像とみなす。アスペクト比の扱いについては_アスペクト比_の項目を参照。

~~~~
FeaturedImage::Finder.first URL 1.2..1.8
~~~~

最小サイズ指定の検索条件。320x240ピクセル以上のサイズの画像を注目画像とみなす。

~~~~
FeaturedImage::Finder.first URL 320 240
~~~~

アスペクト比つき最小サイズ指定の検索条件。320x240ピクセル以上かつアスペクト比が4:3から16:9の画像を注目画像とみなす。

~~~~
FeaturedImage::Finder.first URL 320 240 1.2..1.8
~~~~

最大・最小サイズ指定の検索条件。320x240ピクセル以上かつ1024x768px以下のサイズの画像を注目画像とみなす。

~~~~
FeaturedImage::Finder.first URL 320 240 1024 768
~~~~

最も厳しい検索条件。320x240ピクセル以上かつ1024x768ピクセル以下かつアスペクト比が3:4から16:9の画像を注目画像とみなす。

~~~~
FeaturedImage::Finder.first URL 320 240 1024 768 1.2..1.8
~~~~

### アスペクト比

FeaturedImageではアスペクト比を幅 / 高さと定義する。以下に例を示す。

- アスペクト比 1.0 -- 正方形。幅と高さが等しい。
- アスペクト比 0.5 -- 縦長の長方形、高さは幅の倍である。
- アスペクト比 2.0 -- 横長の長方形、幅は高さの倍である。

## まとめ

以上、Webページから目を引く画像を抽出して、サムネイルを生成するプログラムについて説明した。単純な抽出しかしていない割に、意外とそれっぽいサムネイルを生成することができる。実装行数も200行程度とコンパクトだ。リンク先を華やかに紹介したい場合に、ブログかWebサービスか何かに組み込んで利用できる、と思う。多分。
