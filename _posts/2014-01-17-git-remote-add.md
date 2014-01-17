---
layout: blog
title: Gitでリモートリポジトリを追加してpullする
tag: 'git'
---

# Gitでリモートリポジトリを追加してpullする

Gitで既存のリポジトリをpullしてくるには以下の手順でok。URLはリポジトリのURLに置き換える。
これでカレントディレクトリにURLのリポジトリの内容がすべてダウンロードされる。

~~~~
git init
git add origin URL
git pull origin master
~~~~
