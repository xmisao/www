---
layout: blog
title: uim-ximの使い方、およびxtermの日本語関連設定
tag: linux
---



ターミナルエミュレータは古風にxtermを愛用している。デフォルトで入っているのが良い。
ただしxtermはいかんせん古く、日本語の扱いにひと工夫必要だ。
散漫な内容になるが、Tipsをメモとしてまとめておこうと思う。

# xtermで日本語入力する

xtermは日本語の入力に古いインプットメソッドであるXIMを使う。
そのため、現代的なインプットメソッドで日本語の入力を行うには、XIMのブリッジが必要になる。

例えばDebianでUIMの場合は、uim-ximパッケージがそのブリッジだ。
以下でインストールできる。

    apt-get install uim-xim

xtermで日本語の入力を行うために、uim-ximを起動しよう。

    uim-xim

以下のように、環境変数XMODIFIERSをUIMに設定し、xtermを起動すればUIMで日本語が入力ができるようになる。

    XMODIFIERS=@im=uim

このあたりは、今時の環境なら勝手にやってくれる事が多い。

# 日本語入力中のフォント設定

上記で晴れてxtermに日本語入力ができるようになるが、xtermで日本語が文字化けしてしまう場合がある。

## エンコーディング

日本語が化ける場合は、ロケールにあわせたエンコーディングが指定されていないかも知れない。
xtermの-lcオプションでロケールに合わせたエンコーディングで起動させよう。

    xterm -lc

ロケールではなく明示的にエンコーディングを指定することもできる。
例えばUTF-8を指定する場合は、xtermの-enオプションを使って以下のようにする。

    xterm -en UTF-8

リソースファイルで-lcや-en相当の指定するには、それぞれlocaleリソースを設定すれば良い。

    xterm*locale: true

または

    xterm*locale: UTF-8

## 変換中の日本語の文字化け対策

エンコーディングの設定をしてもなお、xtermの変換中の日本語が文字化けすることがある。
これはUIM-XIMで変換中の文字列のエンコードが、フォントのエンコードと異なるため発生するようだ。

jisx0208.1983のフォントを指定すれば、変換中も正しく日本語が表示される。
例えば14ドットのfixedフォントを使う場合は、xtermの-fxオプションで以下のようにする。

    xterm -fx "-misc-fixed-medium-r-normal--14-130-75-75-c-140-jisx0208.1983-0"

リソースファイルで指定する場合は、ximFontリソースを設定する。

    xterm*ximFont: -misc-fixed-medium-r-normal--14-130-75-75-c-140-jisx0208.1983-0

## 全角ボールドの文字の文字化け対策

日本語は表示できるが、全角文字のボールドだけ文字化けする場合がある。
これはフォントにボールドの字形が存在しないのが原因で化けている。
全角ボールドが入ったフォントを使う以外に、根本的な対策はない。

ボールドが効かなくなっても良いなら、xtermの-fwbオプションで適当なフォントを指定すれば一応回避できる。

    xterm -fwb fixed

リソースファイルではwideBoldFontリソースで設定できる。

    xterm*wideBoldFont: fixed

## xtermのフォント指定メモ

良く忘れるので、xtermのフォント指定オプションとリソースの一覧を表にまとめてみた。

<table class="table table-striped">
<tr><th>フォントの種類</th><th>xtermオプション</th><th>Xリソース</th><th>意味</th></tr>
<tr><td rowspan="4">ビットマップ</td><td>-fn</td><td>xterm*font</td><td>半角文字のフォント</td></tr>
<tr><td>-fb</td><td>xterm*boldFont</td><td>半角ボールド文字のフォント</td></tr>
<tr><td>-fw</td><td>xterm*wideFont</td><td>全角文字のフォント</td></tr>
<tr><td>-fwb</td><td>xterm*wideBoldFont</td><td>全角ボールド文字のフォント</td></tr>
<tr><td rowspan="3">FreeType</td><td>-fa</td><td>xterm*faceName</td><td>半角文字のフォント</td></tr>
<tr><td>-fb</td><td>xterm*faceNameDoublesize</td><td>全角文字のフォント</td></tr>
<tr><td>-fs</td><td>xterm*faceSize</td><td>フォントサイズ</td></tr>
<tr><td>-</td><td>-fx</td><td>xterm*ximFont</td><td>インプットメソッドの変換中テキストのフォント</td></tr>
</table>
