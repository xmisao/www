---
layout: blog
title: Gnuplotのイケてるカラーセット
tag: gnuplot
---



![Awesome Graph]({{ site.url }}/assets/2013_09_09_awesome_graph.png)

大学を出て久しく、Gnuplotを使う機会もほぼ無くなった。Gnuplotには何かと苦労させられた思い出があるが、とりわけデフォルトの配色ーーあの原色で目が痛くなるやつーーが、初心者の恐怖をことさら煽っていると思う。あの配色さえマシになれば、世の大学生の幸福度が1%は上がるに違いない。

残念ながらGnuplotにカラースキームやテーマといった機能はない。ただし、`set linetype`で線の色を指定することはできる。ネットを漁っていたら、イケてる配色のセットを見つけた。*nixであれば、以下を~/.gnuplotに書いておけば、一発でセンスの良いグラフが描けるようになる。冒頭の画像は、この配色の設定で描画したサンプルだ。

~~~~
set linetype  1 lc rgb "dark-violet" lw 1
set linetype  2 lc rgb "#009e73" lw 1
set linetype  3 lc rgb "#56b4e9" lw 1
set linetype  4 lc rgb "#e69f00" lw 1
set linetype  5 lc rgb "#f0e442" lw 1
set linetype  6 lc rgb "#0072b2" lw 1
set linetype  7 lc rgb "#e51e10" lw 1
set linetype  8 lc rgb "black"   lw 1
set linetype  9 lc rgb "gray50"  lw 1
set linetype cycle  9
~~~~

なお描画に使うターミナルドライバは、画像出力用ならpngcairoが最近の流行りのようだ。pngと比較してアンチエイリアスがかかった美しいグラフが出力できる。お試しあれ。

参考:  

- [Demo scripts for gnuplot version 4.6](http://gnuplot.sourceforge.net/demo_4.6/)
- [Default colour set on Gnuplot website](http://stackoverflow.com/questions/17120363/default-colour-set-on-gnuplot-website)
