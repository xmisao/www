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

なおpullしてきたリポジトリにコミットするにはユーザ名とメールアドレスを事前に設定しておく必要がある。
Gitのユーザ名とパスワードの設定方法については、以下のエントリを参照。

- [Gitの設定の種類/Gitのユーザ名・メールアドレスの設定](http://www.xmisao.com/2012/10/23/git-config-user-email.html)
