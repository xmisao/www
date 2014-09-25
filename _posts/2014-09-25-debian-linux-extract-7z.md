---
layout: blog
title: Debian Linuxで7zファイルを圧縮・解凍する / p7zipの使い方
tag: ['debian', 'linux']
---

# Debian Linuxで7zファイルを圧縮・解凍する / p7zipの使い方

[7-Zip](http://www.7-zip.org/)はWindows用のアーカイバで、他の形式より圧縮率が高いとされている。
さほど使われていないのだが、たまたまLinuxで7zファイルを扱う機会があったのでメモを残しておく。

環境はDebian wheezyで試した。とはいえ他のDebianやUbuntuでも同じはずだ。

## p7zipのインストール

POSIXシステム(Unixなど)向けの7-Zipの実装が[p7zip](http://p7zip.sourceforge.net/)だ。

Debianでは`p7zip`や`p7zip-full`といったパッケージで提供されている。
`p7zip-full`は`p7zip`の提案パッケージとなっている。
このエントリでは`p7zip-full`をインストールする。

~~~~
apt-get install p7zip-full
~~~~

## p7zipのコマンド

`p7zip-full`をインストールすると、以下の4コマンドが使えるようになる。

- 7z
- 7za
- 7zr
- p7zip

これらのコマンドは違いが良くわからないのだが、[ArchWiki](https://wiki.archlinux.org/index.php/P7zip)に解説があった。

> 7z uses plugins to handle archives. 
> 7za is a stand-alone executable. 7za handles fewer archive formats than 7z, but does not need any others. 
> 7zr is a stand-alone executable. 7zr handles fewer archive formats than 7z, but does not need any others. 7zr is a "light-version" of 7za that only handles 7z archives. 

機能としては 7z ＞ 7za ＞ 7zr のようである。

なお`p7zip`はシェルスクリプトで、`7zr`のgzip風のラッパとなっている。
7zファイルを解凍したいだけなら、以下で解凍できる。
ただ`p7zip`は後述する`7z x`を内部で使用しているので注意。

~~~~
p7zip -d archive.7z
~~~~

以降ではp7zipの本丸である`7z`コマンドで圧縮・解凍などを行う。

## 圧縮

圧縮には`7z a`を使う。
以下は`files`を`archive.7z`に圧縮する例である。

~~~~
7z a archive.7z files
~~~~

## 解凍

解凍には`7z e`を使う。
以下は`archive.7z`を解凍する例である。

~~~~
7z e archive.7z
~~~~

なお解凍には`7z x`もある。
これはフルパスで解凍を行うとのこと。

バックアップ用だと思われるが、気持ち悪いので通常は`7z e`を使った方が良いと思う。

## 一覧表示

アーカイブファイルの内容を表示するには`7z l`を使う。
圧縮形式やファイル一覧などが表示される。

~~~~
7z l archive.7z
~~~~

## その他

他にアーカイブファイル中のファイルの更新や削除、破損していないかの確認、ベンチマークが可能らしい。
また結構な量のオプションが存在する。

詳しくは`7z --help`やmanを参照。
