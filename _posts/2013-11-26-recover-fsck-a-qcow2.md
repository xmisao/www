---
layout: blog
title: 壊れたqcow2のパーティションをfsckで修復する方法
tag: linux
---



KVMで使っていたqcow2のディスクイメージが何かのはずみで壊れてしまった。
普通のディスクイメージであればfsckが試せるが、qcow2なのでそのままでは操作することができない。
何か手はないかと調べたところ以下のエントリーが見つかり、この通りの手順で修復できたのでメモする。

- [How to recover a qcow2 file using fsck](http://www.randomhacks.co.uk/how-to-recover-fsck-a-qcow2-file/)

まず`nbd`モジュールをロードする。

    modprobe nbd max_part=8

`yourdiskimage.qcow2`を`/dev/nbd0`にマウントする。
これでqcow2のディスクイメージが、物理的なブロックデバイスと同じように扱えるようになる。

    qemu-nbd --connect=/dev/nbd0 yourdiskimage.qcow2

念のため`fdisk`でパーティションを調べよう。
以下では1番目のパーティションを修復の対象だとする。

    fdisk /dev/nbd0

1番目のパーティションは`/dev/nbd0p1`になっている。
このブロックデバイスに`fsck`を実行する。
運を天に任せて質問に答えつつ修復を完了させる。

    fsck /dev/nbd0p1

ディスクイメージをアンマウントする。
あとは普通に仮想マシンを起動してみれば良い。

    qemu-nbd --disconnect /dev/nbd0
