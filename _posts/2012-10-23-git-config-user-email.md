---
layout: blog
title: Gitの設定方法(ユーザ名・メールアドレス)
tag: git
---

# Gitの設定の種類

Gitには以下4種類の設定がある。
より狭い範囲の設定が優先される。

* system -- システム全体の全ユーザ共通の設定。/etc/gitconfigに書かれる。
* global -- あるユーザの全リポジトリ共通の設定。~/.gitconfigに書かれる。
* local -- あるリポジトリの設定。.git/configに書かれる。
* file -- リポジトリ中のあるファイルの設定。.git/configに書かれる。

なおgit configコマンドのデフォルトはlocalへの設定になる。
別の範囲の設定にするには以下のようにオプションを指定する。

    git config --global user.name foo

# Gitのユーザ名・メールアドレスの設定

user.nameとuser.emailの設定値がコミット時のユーザの情報になる。

    git config user.name foo
    git config user.email bar@example.com
