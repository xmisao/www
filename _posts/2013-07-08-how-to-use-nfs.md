---
layout: default
title: debian wheezyでNFS環境を構築
---

# debian wheezyでNFS環境を構築

## NFSサーバ

    apt-get install nfs-common  nfs-kernel-server

設定は/etc/exportsに記述する。共有するディレクトと、公開を許可するホスト(ネットワーク)と、それぞれのホストに対するオプションを指定する。オプションの意味は下記のとおり。

- ro -- 読み込み専用
- rw -- 読み書き可能
- sync -- 同期書き込み(安全だが遅い)

    /foo/bar 192.168.1.2(ro,sync) 192.168.1.3(rw,sync)

/etc/exportsで設定が終わったらnfsサーバを再起動するか、HUPシグナルを送ってやらないといけない。

    /etc/init.d/nfs-kernel-server restart

## NFSクライアント

NFSのマウントはmountコマンドに-t nfsを指定するだけで行える。

    mount -t nfs 192.168.1.2:/foo/bar hoge

注意点としてデフォルトのNFSサーバはrootでのアクセスを許可しない。クライアントはmountだけrootでやって、ファイルシステムへのアクセスはroot以外のユーザを使うことになる。

またmountしているのを忘れてnfsサーバをシャットダウンすると、クライアントはdevice is busyと言われてumountが効かなくなるので注意。こうなったらumount -lfするしかない。
