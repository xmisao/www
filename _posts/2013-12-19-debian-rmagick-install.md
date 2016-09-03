---
layout: blog
title: Debian WheezyにRMagickをインストール
tag: ruby
---



RubyからImageMagickを使えるRMagickはネイティブエクステンションだ。ImageMagickの開発用のパッケージと強く依存しており、インストールにひと手間かかる。

Gemをビルドする基本的な環境は整っている前提。いろいろ試行錯誤したところ、RMagick固有の依存ライブラリはDebianなら`libmagick++-dev`でまとめてインストールできるようだ。以下でRMagickが使えるようになるはずである。

~~~~
apt-get install libmagick++-dev
gem install rmagick
~~~~
