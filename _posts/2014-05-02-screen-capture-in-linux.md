---
layout: blog
title: Linuxでなんちゃって動画スクリーンキャプチャ
tag: linux
---

# Linuxでなんちゃって動画スクリーンキャプチャ

Linuxでデスクトップを動画でスクリーンキャプチャするには[recordmydesktop](http://recordmydesktop.sourceforge.net/about.php)などのツールを使う方法がある。
しかし、このような本格的なツールを使わずとも、`xwd`と`convert`それにちょっとしたスクリプトを使えば、`xwd`でスクリーンショットを連続で撮影し、後からそれらを結合する方法で、スクリーンキャプチャの動画を作ることができる。

このエントリで紹介する手順は以下のとおり。

1. `xwininfo`でキャプチャ対象のウィンドウIDを調べる
2. 調べたウィンドウIDを`cap.rb`スクリプトの引数にして実行する
3. キャプチャ対象のウィンドウを操作する
4. `cap.rb`スクリプトをCtrl + cで停止する
5. `convert`で画像をアニメーションGIFに結合する

## 1. `xwininfo`でキャプチャ対象のウィンドウIDを調べる

`xwininfo`はXのウィンドウの情報を表示するためのツールだ。
以下のように実行すると、カーソルが+マークになり、クリックしたウィンドウの情報が表示される。
結果は長いが重要なのは`Window id`の行であり、この値をメモっておく。

~~~~
xwininfo
~~~~

~~~~
xwininfo: Please select the window about which you
          would like information by clicking the
          mouse in that window.

xwininfo: Window id: 0x180000d "xmisao@xmisao: ~"

  Absolute upper-left X:  960
  Absolute upper-left Y:  19
  Relative upper-left X:  960
  Relative upper-left Y:  19
  Width: 958
  Height: 524
  Depth: 24
  Visual: 0x21
  Visual Class: TrueColor
  Border width: 1
  Class: InputOutput
  Colormap: 0x20 (installed)
  Bit Gravity State: NorthWestGravity
  Window Gravity State: NorthWestGravity
  Backing Store State: NotUseful
  Save Under State: no
  Map State: IsViewable
  Override Redirect State: no
  Corners:  +960+19  -0+19  -0-535  +960-535
  -geometry 159x40-0+19
~~~~

## 2. 調べたウィンドウIDを`cap.rb`スクリプトの引数にして実行する

`cap.rb`は以下のようなちょっとしたRubyスクリプトだ。
このスクリプトは0.1秒ごとに`xwd`と`convert`を実行し、連番のGIFファイルとしてスクリーンショットを保存する。

~~~~
#! /usr/bin/env ruby
id = ARGV[0]
9999.times{|i|
  fname = "cap_#{sprintf("%04d", i)}.gif"
  puts fname
  `xwd -id #{id} | convert - #{fname}`
  sleep 0.1
}
~~~~

このスクリプトに先ほど調べたウィンドウIDを渡して実行する。
これでウィンドウのキャプチャが開始され、カレントディレクトリに`cap_0000.gif`、`cap_0001.gif`、…、が順に出力される。

~~~~
ruby cap.rb 0x180000d
~~~~

## 3. キャプチャ対象のウィンドウを操作する

これは文字通り。
キャプチャ対象のウィンドウで、記録を取りたい操作をする。

## 4. `cap.rb`スクリプトをCtrl + cで停止する

`cap.rb`は999秒まで停止しないため、ウィンドウを操作し終わったらCtrl + cで終了させる。

この際、運悪く`convert`の実行中だと、ゴミファイルが残る場合がある。
次の手順でもしエラーが発生したら、最後の1枚の画像を削除してやると良い。

## 5. `convert`で画像をアニメーションGIFに結合する

`convert`は以下のようにすると引数で与えた画像をアニメーションGIFとして出力できる。

~~~~
convert 0.gif 1.gif 2.gif anime.gif
~~~~

アニメーションGIFを作る時のオプションとして`-loop`と`-delay`がある。
`-loop`でアニメーションのループ回数を指定でき、0を指定すると無限ループとなる。
また`-delay`で1フレームの時間を10msec単位で指定することができる。

以下は1フレーム100msecで、無限ループするアニメーションGIFを出力する例である。

~~~~
convert -loop 0 -delay 10 0.gif 1.gif 2.gif anime.gif
~~~~

`cap.rb`が出力した画像を結合するには、以下のようにすれば良いだろう。

~~~~
convert -loop 0 -delay 10 cap_*.gif anime.gif
~~~~

## おわりに

以上、`xwd`と`convert`を使って、簡易的なスクリーンキャプチャを行う方法を紹介した。
実際にやってみると、これだけでも十分に実用できる。
このように基本的なツールを組み合わせれば色々とやりようがあるのがLinuxの良いところだ。
