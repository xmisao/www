---
layout: blog
title: Gnuplotの基本チートシート
tag: gnuplot
---



![Gnuplot Cheatsheet](/assets/2013_09_11_gnuplot_cheatsheet.png)

Gnuplotを使い始めた時の「ここを変えたい!」を一目で確認できるチートシートのようなものを書いた。これだけ知っておけば、ひとまずグラフを書くことはできる。内容はもっと拡充したいな…。

# ①タイトル

    set title 'trigonometric function'

# ②凡例

    set key box

# ③座標軸

    set zeroaxis

# ④x軸ラベル

    set xlabel 'x->'

# ⑤y軸ラベル

    set ylabel 'y->'

# ⑥x軸範囲

    set xrange [-3.14 : 3.14]

# ⑦y軸範囲

    set yrange [-2 : 2]

# プロットと画像出力

## プロット

    plot sin(x), cos(x), tan(x)

## 画像出力(png)

    set terminal pngcairo
    set output 'trigonometric_function.png'
    plot sin(x), cos(x), tan(x)
