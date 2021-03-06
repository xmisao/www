---
layout: blog
title: Refine:壊れたかもしれないハードディスクからのデータサルベージ
tag: linux
---



※このエントリーは旧ブログで600はてなブックマークを記録した[壊れたかもしれないハードディスクからのデータサルベージ](http://d.hatena.ne.jp/kokutoto/20080525/p1)の内容を再構成したものです

ハードディスクの不調が疑われる場合は、いったん全データをディスクイメージとしてコピーして、修復を行った方が良い。
問題のあるディスクを直接操作することで、さらにデータが破損することを防ぐためだ。
Linuxを使えばこのディスクイメージの作成とバックアップを簡単に行うことができる。
このエントリでは`dd`を使用した基本的なデータのサルベージ方法を解説する。

# Step.1 ディスク情報の把握

不調が疑われるディスクのデバイスファイルは`/dev/hdb`とする。
まず`fdisk`でディスクの情報とパーティションを調査する。
`-l`はパーティションテーブルを表示するオプション、`-u`は表示をセクタ単位とするオプションだ。

~~~~
fdisk -lu /dev/hdb
~~~~

~~~~
Disk /dev/hdb: 250.0 GB, 250059350016 bytes
255 heads, 63 sectors/track, 30401 cylinders, total 488397168 sectors
Units = sectors of 1 * 512 = 512 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/hdb1   *          63   131973974    65986956    7  HPFS/NTFS
/dev/hdb2       131973975   149966774     8996400   83  Linux
/dev/hdb3       149966775   151958834      996030   82  Linux swap / Solaris
/dev/hdb4       151958835   488392064   168216615    7  HPFS/NTFS
~~~~

`fdisk`の出力から、ディスクのサイズ(総セクタ数)と、パーティションの配置が読み取れる。
以降のステップでこの情報を元にディスクイメージ作成とマウントを行うので、出力はメモしておこう。

なお`fdisk`でパーティションが表示できるのはMBRの場合だけである。
GPTの場合は、`parted`を使ってパーティションを調べてやる必要がある。

そもそもパーティションテーブルが読めないほどデータが破損している場合は、残念ながらあきらめた方が良いだろう。
一縷の望みでパーティションテーブルが壊れていてもデータを修復できる専用のツールを使うしかないだろう。

# Step.2 ディスクイメージの作成

不調が疑われるディスクのディスクイメージを作成する。
以下の例のように`dd`を使うことで、ディスク全体を1つのファイルにコピーできる。
データの破損があれば、随時標準エラー出力にエラーが表示される。

~~~~
dd if=/dev/hdb of=/root/hdd.img ibs=512 obs=1024k count=488397168 conv=sync,noerror
~~~~

オプションの意味は以下のとおり。

- `if` -- データの入力元。この例では不調な`/dev/hdb`を指定している。
- `of` -- データの出力先。この例では`/root/hdd.img`としてディスクイメージを作成する。
- `ibs` -- データの入力単位。セクタサイズ(512バイト)とする。
- `obs` -- データの出力単位。高速化のため大きめなサイズ(1024kバイト)とする。
- `count` -- データ長。入力単位で何個分のデータをコピーするか指定する。この例では`ibs`をセクタサイズとしているので、Step.1で調べた総セクタ数に合わせる。
- `conv` -- `sync,noerror`はデータが読み込めなくてもnullパディングすること、エラーを無視することを意味する。

ポイントは`ibs`と`obs`を指定して、入力のサイズを小さく、出力のサイズを大きくして、読み込み不可能でnullパディングされる量を最小にしつつ、データのコピーを高速化することだ。

# Step.3 データのサルベージ

ディスクイメージからパーティションをマウントして、データをサルベージする。
以下はstep 1.で調べた1つ目のNTFSパーティションをマウントする例である。

~~~~
mount /root/hdd.img /mnt/ntfs -t ntfs -o ro,loop,offset=32256,nls=utf8
~~~~

オプションの意味は以下のとおり。

- `/root/hdd.img` -- ディスクイメージファイルの場所を指定する。適宜読み替える。
- `/mnt/ntfs` -- マウント先を指定する。この例では`/mnt/ntfs`にマウントする。
- `-t` -- パーティションのファイルシステム。`ntfs`はNTFSであることを示す。通常は自動でファイルシステムが判定されるが、データが壊れていることも想定して念の為している。
- `-o` -- オプションである。それぞれ以下の意味がある。
  - `ro` -- 読み取り専用でマウントする。
	- `loop` -- ループバックデバイスを使用して、ファイルをブロックデバイスにする指定。
	- `offset=` -- Step.1で調べたパーティションの開始位置をバイト単位で指定する。この例では63セクタ x 512バイトで32256バイトである。
	- `nls=utf8` -- NTFSパーティションで、ファイル名を正確に表示できるようにするため指定する。

マウントが成功すれば、あとはデータをコピーしてバックアップを取れば良い。
マウントが失敗するようなら、残念ながらデータが壊れている。
壊れたデータの修復はこのエントリの範囲を超えるが、NTFSであればWindowsのチェックディスク、EXT3であればLinuxの`fsck`で修復できる見込みがある。
