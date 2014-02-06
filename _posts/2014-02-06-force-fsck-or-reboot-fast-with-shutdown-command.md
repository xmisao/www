---
layout: blog
title: Linuxで次回起動時にfsckを強制または抑止する方法について
tag: linux
---

# Linuxで次回起動時にfsckを強制または抑止する方法について

Linuxで次回起動時に`fsck`を強制したい場合は、ルートファイルシステムに`forcefsck`ファイルを作ってやれば良い。
この操作は`touch`コマンドを使って、以下のようにファイルを作ることで行うよう紹介されることが多い。

~~~~
touch /forcefsck
~~~~

このことは経験的に知っていたのだが、`/forcefsck`をブートプロセスがチェックし、`fsck`を実行することはどこに明文化されているのかがふと気になった。

少なくとも`fsck`のmanページには書かれていない。
調べてみると`shutdown`コマンドのmanには、`/forcefsck`ファイルに関して、以下の記述があることがわかった。
引用する。

> The  -F  flag means 'force fsck'.  This only creates an advisory file /forcefsck which can be tested by the system when it comes up again.  The boot rc file can test if this file is present, and decide to run fsck(1) with a special 'force' flag so that even properly  unmounted  file  systems  get checked.  After that, the boot process should remove /forcefsck.

これによると`shutdown -F`すると`/forcefsck`を作る、次回起動時にブートプロセスがこれをチェックし、`fsck`が実行されることを期待しているようにみえる。

これを読むと、実は`/forcefsck`ファイルはユーザがおいそれと`touch`するものではなく、本来は`shutdown`コマンドに作らせるものなのではないか、という気がしてくる。

ちなみに、`shutdown`コマンドのmanにはもう1つ興味深い事が書かれている。
それが`shutdown -f`オプションである。

> The  -f  flag means 'reboot fast'.  This only creates an advisory file /fastboot which can be tested by the system when it comes up again.  The boot rc file can test if this file is present, and decide not to run fsck(1) since the system has been shut down in the proper way.  After that, the boot process should remove /fastboot.

これは`shutdown -F`と対を成すオプションだ。
これによるとルートファイルシステムに`fastboot`ファイルを作ってやれば、次回起動時の`fsck`を抑止できるようだ。
試したことはないが、いつか使ってみたいものだ。

fsckをめぐる冒険はひとまずこれで終わり。
