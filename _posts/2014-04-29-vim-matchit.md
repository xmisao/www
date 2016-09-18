---
layout: blog
title: matchitでvimの%を拡張する
tag: vim
---



matchitはvimで対応する括弧にジャンプする`%`の機能を拡張し、HTMLやLaTeXのタグなど複数文字で構成されるペアを持った言語でも、この機能を利用できるようにするvimプラグインだ。

vim 6.0以降ではvimに同梱されているらしいのだが、手元のdebianの環境では見当たらなかった。ダウンロードして使用する場合は[matchit.zip](http://www.vim.org/scripts/script.php?script_id=39)から。[Vundle](/2013/08/22/vundle.html)を使っている場合は、`.vimrc`に以下を記述して、`BundleInstall`でインストールできる。

~~~~
Bundle 'tmhedberg/matchit'
~~~~

これでHTMLなどを編集中にタグにカーソルを置いてノーマルモードで`%`を押下すると、カーソルが対応するタグにジャンプするようになる。非常に便利なのでぜひ活用したい。
