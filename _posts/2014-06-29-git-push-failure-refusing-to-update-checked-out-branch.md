---
layout: blog
title: リモートリポジトリへのgit pushがrefusing to update checked out branchで失敗する
tag: git
---

# リモートリポジトリへのgit pushがrefusing to update checked out branchで失敗する

リモートでリポジトリを作成する。

~~~~ bash
git init
~~~~

ローカルでもリポジトリを作成し、何か変更して、リモートへpushする。

~~~~ bash
git init
echo foo > foo.txt
git add foo.txt
git commit -m "first commit"
git push ssh://remote-host/path/to/repos master
~~~~

すると以下のようなエラーが出てpushできない。

~~~~
Counting objects: 5, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (4/4), done.
Writing objects: 100% (5/5), 612 bytes, done.
Total 5 (delta 0), reused 0 (delta 0)
remote: error: refusing to update checked out branch: refs/heads/master
remote: error: By default, updating the current branch in a non-bare repository
remote: error: is denied, because it will make the index and work tree inconsistent
remote: error: with what you pushed, and will require 'git reset --hard' to match
remote: error: the work tree to HEAD.
remote: error: 
remote: error: You can set 'receive.denyCurrentBranch' configuration variable t
remote: error: 'ignore' or 'warn' in the remote repository to allow pushing int
remote: error: its current branch; however, this is not recommended unless you
remote: error: arranged to update its work tree to match what you pushed in som
remote: error: other way.
remote: error: 
remote: error: To squelch this message and still keep the default behaviour, se
remote: error: 'receive.denyCurrentBranch' configuration variable to 'refuse'.
To ssh://remote-host/path/to/repos
 ! [remote rejected] master -> master (branch is currently checked out)
error: failed to push some refs to 'ssh://remote-host/path/to/repos'
~~~~

理由はワーキングツリーとインデックスが不整合になるから。

## 解決策1 リモートリポジトリでオプションを設定

カレントブランチへのpushを受け付けるように`receive.denyCurrentBranch`オプションを`ignore`に設定する。

~~~~ bash
git config --add receive.denyCurrentBranch ignore
~~~~

この方法は不注意な操作で変更を失う可能性が高いため、複数人で作業している場合はNG。

ただし1人で使っている分には便利なことも多々ある…と思う。

## 解決策2 リモートリポジトリを--bareで作成

リモートリポジトリを`--bare`で作成すれば、ワーキングツリーが無くなるので、この問題は発生しない。

~~~~ bash
git init --bare
~~~~

複数人で作業する場合はこのように`--bare`なリポジトリを用意した方が良い。

- 参考
  - [Tips non-bareなリポジトリにpushする](http://wiki.arashike.com/git/tips/1)
  - [git config --add receive.denyCurrentBranch ignoreはどう危険なのか](http://d.hatena.ne.jp/nishiohirokazu/20120416/1334548800)
