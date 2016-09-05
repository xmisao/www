---
layout: blog
title: wombatの256色カラースキーム(CUI・GUI両用)
tag: vim
---



![wombat256]({{ site.url }}/assets/2014_05_01_wombat.png)

vimのカラースキームではwombatが好きだ。
オリジナルのwombatはgvim専用だが、256色のターミナル用に移植して、CUI・GUI両用としたカラースキームも公開されている。

- [wombat256.vim : Wombat for 256 color xterms ](http://www.vim.org/scripts/script.php?script_id=2465)

カラースキームを使用するには、最新版の`wombat256mod.vim`をダウンロードし、`~/.vim/color/`に配置した上で、`~/.vimrc`等で`:colorscheme wombat256mod`すれば良い。これでvim・gvim共にwombatカラースキームとなる。

冒頭のスクリーンショットはこのカラースキームを適用したvimである。
確かにターミナル上でもwombatのカラースキームがほぼ完璧に再現されている。
このwombatの美しい色彩で、さらに作業がはかどることだろう。
