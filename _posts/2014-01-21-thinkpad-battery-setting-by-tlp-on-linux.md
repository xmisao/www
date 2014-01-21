---
layout: blog
title: ThinkPadのバッテリの充放電閾値をLinuxから設定してバッテリーの寿命を伸ばす方法
tag: ['thinkpad', 'linux']
---

# ThinkPadのバッテリの充放電閾値をLinuxから設定してバッテリーの寿命を伸ばす方法

ThinkPadでは過剰にバッテリーが充放電された状態が続きバッテリーが劣化するのを防ぐ目的で、バッテリーを充放電する閾値を設定することができる。
例えばバッテリーがいったん60%を切るまではACアダプタを接続しても充電しないだとか、充電時に100%ではなく80%までしか充電しないようにするといった設定ができる。

この設定をLinux上から行える以下のツールを見つけたので、Debian Jessieでの導入方法とツールの使い方を説明する。

- [ThinkPad ACPI Battery Util](https://github.com/teleshoes/tpacpi-bat)

なおこの設定を検証したThinkPadはX240である。私のThinkPadはオプションの内蔵バッテリーを搭載しているので、各バッテリーにそれぞれ設定をする。

## インストール

GitHubからソースコードをcloneしてくる。
これでカレントディレクトリ以下に`tpacpi-bat`ディレクトリができる。

~~~~
$ git clone https://github.com/teleshoes/tpacpi-bat.git
~~~~

`tpacpi-bat`ディレクトリに入って、root権限で`install.pl`を実行すると`acpi_call`モジュールがダウンロード、ビルド、インストールされる。更に`/usr/local/bin`に`tpacpi-bat`コマンドが配置されてインストールが完了する。

~~~~
$ cd tpacpi-bat
# ./install.pl
~~~~

## 閾値のデフォルト値の確認

設定前に各バッテリーの`ST`(Start Threshold)と`SP`(Stop Threshold)のデフォルト値を確認しておく。
1番のバッテリーがメインバッテリー(内蔵バッテリー/Battery 1)で、2番のバッテリーがセカンダリバッテリー(リアバッテリー/Battery 0)である。
設定の確認は`tpacpi-bat -g`を使う。
なお確認だけでもroot権限が必要。
私の環境では全て0であった。

~~~~
# tpacpi-bat -g ST 1
0 (default)
# tpacpi-bat -g SP 1
0 (default)
# tpacpi-bat -g ST 2
0 (default)
# tpacpi-bat -g SP 2
0 (default)
~~~~

## 閾値の設定

設定の確認は`tpacpi-bat -s`を使う。
メインバッテリー(内蔵バッテリー)は60%まで放電してから充電を開始し、70%まで充電したら充電を完了するように設定する。
セカンダリバッテリー(内蔵バッテリー)は80%まで放電してから充電を開始し、90%まで充電したら充電を完了するように設定する。

~~~~
# tpacpi-bat -s ST 1 60
# tpacpi-bat -s SP 1 70
# tpacpi-bat -s ST 2 80
# tpacpi-bat -s SP 2 90
~~~~

バッテリーをどこまで充電させるかはなかなか悩ましいところだ。
一応Lenovoの公式サイトには以下の記載がある。

- [ThinkPad のバッテリーを長持ちさせる方法について](http://support.lenovo.com/ja_JP/detail.page?LegacyDocID=SYJ0-0023B00)

要約すると、以下のようである。

- ほぼ常時100%の満充電状態に保持されることで劣化が加速される
- バッテリーは細かい充放電が頻繁に行われるのは苦手である
- 主にACアダプタでの利用が中心の場合の設定
  - 充電停止を90%〜95%に設定
	- 充電開始を60%〜75%に設定
- 主にバッテリー駆動での利用が中心の場合の設定
  - この場合も設定が有効である(!)
  - 設定はACアダプタでの利用が中心の場合よりいくらか高めでも良い
- 3〜6ヶ月に1度はバッテリーを完全に放電させ満充電した方が良い
- 長期間バッテリーを保管する場合は20%〜30%前後まで充電しておくこと

長期間使用しないことがないならば、だいたい常時60%〜95%くらいに充電しておけば良さそうに読める。

## 設定した閾値の確認

念の為、設定した値が反映されているか確認しておく。
この設定はリブートしてもきちんと記録されていた。

~~~~
# tpacpi-bat -g ST 1
60 (relative percent)
# tpacpi-bat -g SP 1
70 (relative percent)
# tpacpi-bat -g ST 2
80 (relative percent)
# tpacpi-bat -g SP 2
90 (relative percent)
~~~~

## 結果

この状態でThinkPadにACアダプタを接続して充電させてみると、確かに設定どおりの閾値で充電が完了することが確認できた。
なおこの設定はハードウェアの機能なので、ThinkPadを起動していない状態でも有効である。

~~~~
$ acpi -b
Battery 0: Unknown, 89%
Battery 1: Unknown, 69%
~~~~
