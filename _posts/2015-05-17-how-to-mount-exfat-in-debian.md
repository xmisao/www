---
layout: blog
title: Debian/UbuntuでexFATをマウントする方法
tag: linux
---



最近はSDXCカードが普及して、exFATを使う機会が増えている。

Debian/UbuntuでexFATのマウントができない場合は、以下のとおり`exfat-fuse`と`exfat-utils`をインストールすると、マウントできるようになる。

~~~~
apt-get install exfat-fuse exfat-utils
~~~~

通常は特に指定しなくても良いはずだが、exFATを明示的に指定したい場合は以下のように`-t exfat`オプションを指定してマウントすれば良い。

~~~~
mount -t exfat /dev/mmcblk0p1 /mnt
~~~~

新しいファイルシステムのフリーな実装を開発してくれる開発者には本当に頭が下がる。
