---
layout: blog
title: LinuxでUSB-HDDを接続時に所定のディレクトリへ自動マウントする方法
tag: linux
---



LinuxでUSB-HDDを使っている場合、いつも決まったディレクトリに中身をマウントしてやりたい事がある。そういう場合は、/etc/fstabをUUID指定で設定し、それにudevの設定を組み合わせれば、USB-HDDの接続時に自動的に所定のディレクトリにマウントすることができる。

# UUIDの調査

まずはUUIDを調べる。

UUIDの調べ方にはいくつか方法があるが、以下のエントリによるとlsコマンドを使うのが最も簡単なようだ。

[\[Linux\]HDDのuuidを調べる。vol_idよりblkid、blkidより「 ls -l /dev/disk/by-uuid/」が良さげ](http://deginzabi163.wordpress.com/2011/09/18/linuxhdd%E3%81%AEuuid%E3%82%92%E8%AA%BF%E3%81%B9%E3%82%8B%E3%80%82vol_id%E3%82%88%E3%82%8Ablkid%E3%80%81blkid%E3%82%88%E3%82%8A%E3%80%8C-ls-l-devdiskby-uuid%E3%80%8D%E3%81%8C%E8%89%AF%E3%81%95/)

    ls -l /dev/disk/by-uuid/

結果は以下のようになる。この場合はUUIDが569785b6-7c3b-4bf0-b6ae-ce8a746c0a38のパーティションが/dev/sda1となっている。

    lrwxrwxrwx 1 root root 10 Jun 16 20:50 569785b6-7c3b-4bf0-b6ae-ce8a746c0a38 -> ../../sda1

# fstabの設定

続いて、USB-HDDをマウントする設定をする。

/etc/fstabに先ほど調べたUUIDのパーティションが、適当なディレクトリにマウントされるようにする。

    UUID=569785b6-7c3b-4bf0-b6ae-ce8a746c0a38 /mnt ext3 rw,noauto 0 0

udevからmountコマンドを実行させてマウントするので、noautoを指定している。

# udevの設定

最後に、udevでUSB-HDDの接続時に自動的にmountコマンドを実行する設定をする。

udevは/etc/udev/rules.d以下の設定を読み込むので、ここに適当な名前でルールを設定しておく。(例えば/etc/udev/rules.d/80-usbhdd.rulesとする)

設定内容は以下。UUID部分は自分のUSB-HDDのものに読み替える。

    ACTION=="add", ENV{DEVTYPE}=="partition", ENV{ID_FS_UUID}=="569785b6-7c3b-4bf0-b6ae-ce8a746c0a38" RUN+="/bin/mount -U $env{ID_FS_UUID}"

上記のルールはID_FS_UUIDで指定したUUIDのパーティションが認識された際に、mount -Uコマンドを自動的に実行してHDDをマウントするものだ。

以上で設定は完了。再起動するなりして、自動的にUSB-HDDがマウントされるか確認しよう。
