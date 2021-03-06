---
layout: blog
title: 仕事で使える! Eclipseの7つのショートカットキー
tag: java
---



仕事でEclipseを使っていて覚えた、便利な7つのショートカットキーを紹介する。これを知っているだけでも、Eclipseを相当使いこなすことができるはずだ。

# Ctrl + Shift + R

Open Resourceダイアログを開く。

Open Resourceダイアログは、ファイル名で部分一致の絞り込みを行い、ファイルを開くダイアログだ。

ポイントとして、この絞り込みでは小文字の入力を省略することができる。例えば`FB`は`FooBar.java`にマッチする。慣れれば大文字だけをタイプして、長い名前のファイルも一発で開くことができる。

# F4

Type Hierarchyを開く。

通常は編集中のクラスの階層が開く。もしソースコード中のクラス名にマウスオーバーしていれば、そのクラスの階層を開くこともできる。クラスの継承関係を調査するのに便利である。

# Shift + Ctrl + O

Organize Importを実行する。

編集中のファイルで、参照されていない不要なインポート文をまとめて削除する機能だ。雑に書いたソースコードを、コミット前に整理する場合に良く使う。

# Shift + Ctrl + T

Open Typeダイアログを開く。

Open Typeダイアログは、クラス名による絞り込みを行い、クラスを開く機能を持つダイアログだ。

プロジェクト中のソースコードだけでなく、参照先のライブラリのclassファイルも開くことができるのがポイントだ。

# Ctrl + H

Searchダイアログを開く。

Searchダイアログは強力な検索機能を提供する。Ctrl + Fで開くFind/Replaceダイアログとは異なり、プロジェクトの全ファイルに対して、Javaの構文に基づく検索や、正規表現による検索などが行える。

# Shift + Alt + R

リファクタリングで名前を変更する。

ファイルにフォーカスしていれば、ファイル名(クラス名)の変更が行える。ソースコード中のクラス名や変数名にフォーカスしていれば、それらの名前を変更することができる。リファクタリングの効率を上げてくれるショートカットだ。

# Ctrl + 2 に続いて l

ローカル変数を定義する。

例えば、以下のようにインスタンス生成だけを入力した行があるとしよう。

~~~~
new ArrayList<String>();
~~~~

この行で`Ctrl + 2`に続いて`l`を入力すると、ローカル変数の定義が以下のように挿入される。

~~~~
ArrayList<String> arrayList = new ArrayList<String>();
~~~~
