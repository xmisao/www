---
layout: blog
title: Debianでプレゼンテーションツールrabbitを使用する
tag: ruby
---

# Debianでプレゼンテーションツールrabbitを使用する

## rabbitとは

[rabbit](http://rabbit-shocker.org/)はRuby製のプレゼンテーションツールだ。

rabbitを使えばRDoc, Hiki記法, Markdownで書いたテキストを、スライド化することができる。
rabbitコマンドでスライドを表示するだけでなく、スライドをPDFとして出力することも可能だ。

このエントリではDebian Jessieにrabbitをインストールする方法と基本的な使い方を紹介する。

## インストール

インストールには、`apt-get`によりDebianのリポジトリからインストールする方法と、`gem install`でGemをビルドする方法の2通りがある。

Debianのリポジトリの`rabbit`パッケージは少々古いという問題がある。
最新が使いたいならGemをビルドするしかない。

基本的に以下の`gem`コマンド1発でインストールできる。
簡単なのでGemをビルドする方法を推奨。
ただしネイティブエクステンションのビルド環境が整っている必要がある。

~~~~
gem install rabbit
~~~~

ビルド環境が整っていない場合は途中でエラーになる。

ありがちなエラーと対処法は以下。

1. `mkmf`が無いというエラー
  - `apt-get install ruby-dev`で`mkmf`を使えるようにする
2. `ruby.h`が無いというエラー
  - `apt-get install ruby-dev`でヘッダファイルをインストールする
    - 実行中のRubyのバージョンと合ったヘッダファイルが入っているか確認のこと
3. `You have to install development tools first.`と言われるエラー
  - `apt-get install build-essential`でビルド環境を整える

## 使い方

### 入力ファイルの作成

スライドをMarkdownで書いてみる。
以下の内容を`slide.md`として保存する。

~~~~markdown
{% raw %}# タイトルページ

# 1ページ目

ヘッダがページ区切りになる

# 2ページ目

- このように
- 箇条書きが
- できる

# 3ページ目

画像は以下のようにして表示

![](picture.jpg "picture"){:width='100' height='100'}{% endraw %}
~~~~

### スライドの表示

以下のように`rabbit`コマンドにスライドファイルを渡すとスライドが実行される。

~~~~
rabbit slide.md
~~~~

### スライドの出力

`-p`オプションを指定し、`-o`オプションに出力ファイル名を指定する。
以下のようにすると`slide.md`を`slide.pdf`としてPDF出力することが可能。

~~~~
rabbit -p -o slide.pdf slide.md
~~~~

### その他詳しい使い方

[rabbitの公式](http://rabbit-shocker.org/ja/usage.html)に豊富な情報があるので詳しくはそちらを参照。
