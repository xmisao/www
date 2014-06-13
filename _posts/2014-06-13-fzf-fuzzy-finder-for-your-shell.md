---
layout: blog
title: fzfでFuzzyFinderライクなシェル操作
tag: ['ruby', 'shell']
---

# fzfでFuzzyFinderライクなシェル操作

## はじめに

[fzf](https://github.com/junegunn/fzf)は[FuzzyFinder](http://www.vim.org/scripts/script.php?script_id=1984)ライクな選択インタフェースをシェルに提供するツールである。
このようなツールはインタラクティブなgrepツールと呼ばれることもあり、有名な実装に[percol](https://github.com/mooz/percol)がある。
fzfはgithub上で現時点で300 Star以上付いており、percolの類似ツールとしては最も人気がある。

## デモ

以下に公式のデモを引用する。
まるで魔法のように絞り込みと補完が行える様子がわかる。

![fzf demo](https://camo.githubusercontent.com/0b07def9e05309281212369b118fcf9b9fc7948e/68747470733a2f2f7261772e6769746875622e636f6d2f6a756e6567756e6e2f692f6d61737465722f667a662e676966)

## インストール(シェル)

以下のようにgithubから`git clone`して、`install`スクリプトを実行することで、インストールが行われる。シェルの設定ファイルが書き換えられるので注意。

~~~~
$ git clone https://github.com/junegunn/fzf.git ~/.fzf
Cloning into '/home/xmisao/.fzf'...
remote: Reusing existing pack: 972, done.
remote: Counting objects: 10, done.
remote: Compressing objects: 100% (10/10), done.
remote: Total 982 (delta 4), reused 0 (delta 0)
Receiving objects: 100% (982/982), 271.17 KiB | 167 KiB/s, done.
Resolving deltas: 100% (574/574), done.
$ ~/.fzf/install
Checking Ruby executable ... OK (/usr/bin/ruby)
Checking Curses support ... OK
Checking Ruby version ... >= 1.9
Do you want to add auto-completion support? ([y]/n) y
Do you want to add key bindings? ([y]/n) y

Generate ~/.fzf.bash ... OK
Generate ~/.fzf.zsh ... OK

Update /home/xmisao/.bashrc:
  - source ~/.fzf.bash
    - Added

Update /home/xmisao/.zshrc:
  - source ~/.fzf.zsh
    - Added

Finished. Restart your shell or reload config file.
   source ~/.bashrc  # bash
   source ~/.zshrc   # zsh

Use uninstall script to remove fzf.

For more information, see: https://github.com/junegunn/fzf
~~~~

## インストール(vim)

fzfはシェル用のツールだが、vimプラグインとしても動作する。

上記のインストール手順を実行している場合、`~/.vimrc`にランタイムパスを追加するだけで使えるようになる。

~~~~
set rtp+=~/.fzf
~~~~

## 機能

fzfが提供するのは`fzf`コマンドだ。
`fzf`は標準入力から候補を受け取り、それをインタラクティブに選択させ、選択した候補を標準出力する機能を持つ。

なお、標準入力が与えられない場合は環境変数`FZF_DEFAULT_COMMAND`で指定したコマンドの実行結果を候補とする。
デフォルトでは、`find`でカレントディレクトリ以下を探索して候補とする。

## 使い方

### 基本的な使い方

試しに`fzf`を単独で実行してみよう。
カレントディレクトリ以下の全ファイルが候補として表示されるはずである。

~~~~
fzf
~~~~

候補はインクリメンタルにあいまい検索が可能である。
選択候補の移動はカーソルキーか、vim風に`Ctrl-J`、`CTRL-K`またはemacs風に`Ctrl-N`、`CTRL-P`で行い、Enterキーで確定できる。
`Ctrl-C`、`Ctrl-G`、`ESC`はキャンセルである。

### 複数候補の選択

`-m`オプションを使用すると、`TAB`と`Shift-TAB`による複数候補の選択が可能だ。
選択した候補はそのまま別のコマンドの入力とすることができる。

~~~~
fzf -m
~~~~

### パイプで使う

`fzf`が標準入力を候補とすることを利用して、実質的に`grep`と同様に利用することができる。

例えば、debianのパッケージ管理システムaptの`apt-cache`で、目的のパッケージを検索する処理は以下のように書ける。

~~~~
apt-cache search . | fzf
~~~~

### コマンド置換で使う

`fzf`は選択した候補を標準出力に出力するため、シェルの機能を使えば選択した候補に何かアクションを実行することができる。

例えば、先ほどの例の応用として`apt-cache`で選択した候補を、`apt-get install`でインストールする処理は、コマンド置換を使って以下のように書ける。

~~~~
apt-get installa `apt-cache search . | fzf | awk '{print $1}'`
~~~~

### シェルスクリプトで使う

上記の例では、`fzf`を`ESC`等で終了しても`apt-get`が実行されてしまう問題がある。
シェルスクリプトにして、きちんと判定してやれば問題ない。
以下は`fzf`がシェルスクリプト中でも有効に動作するという例である。

~~~~
#
local package
package=$(apt-cache search . | fzf | awk '{print $1}')
[ -n "$package" ] && apt-get install "$package"
~~~~

※実際には`apt-get`は`sudo`を併用するなどしてroot権限で実行するようにする

## fzfの応用例

以下の応用例がfzfの公式ページで紹介されている。`.bashrc`等に追記するこでコマンドとして使用できる。

~~~~
# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
  local file
  file=$(fzf --query="$1" --select-1 --exit-0)
  [ -n "$file" ] && ${EDITOR:-vim} "$file"
}

# fd - cd to selected directory
fd() {
  local dir
  dir=$(find ${1:-*} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# fh - repeat history
fh() {
  eval $(([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s | sed 's/ *[0-9]* *//')
}

# fkill - kill process
fkill() {
  ps -ef | sed 1d | fzf -m | awk '{print $2}' | xargs kill -${1:-9}
~~~~

## 自動補完

fzfの機能を使ってbashでの自動補完が可能となっている。デフォルトのトリガーシーケンスは`**`である。

例えば以下のようにシェルに入力して`TAB`キーを押せば、fzfを使ってファイルやディレクトリが補完される。

~~~~
vim **
~~~~

自動補完は`kill`でプロセスIDを補完したり、`ssh`でホスト名を補完したりすることもできる。

~~~~
kill -9
~~~~

~~~~
ssh **
~~~~

なお、公式ページによると、この機能は実験的なものとのことである。

## vimプラグイン

インストールの項で紹介したとおりvimプラグインを有効にする設定をしておくと、vimで`:FZF`コマンドが利用可能になる。`:FZF`コマンドでは、`fzf`を使ってファイルを開くことができる。


## おわりに

以上、fzfの導入方法とその機能をざっと紹介した。fzfの機能はとてもシンプルなものだが、色々と応用範囲の広そうなツールである。fzfで素敵なシェルライフを!
