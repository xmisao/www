---
layout: default
title: kvmでTUN/TAPを使いゲストOSをホストOSと同じネットワークに所属させる
---

# kvmでTUN/TAPを使いゲストをホストと同じネットワークに所属させる

kvm(qemu)で仮想化したゲストには、デフォルトでホストから独立した仮想ネットワークが割り当てられる。そのため、外部からゲストOSにアクセスすることはできない。TUN/TAPを使えばゲストをホストと同じネットワークに所属させ、外部からゲストにアクセスできるようになる。

## ブリッジと仮想NICの作成

ブリッジと仮想NICの作成は/etc/network/interfacesファイルの書き換えで行う。元のファイルを以下とする。

    auto lo eth0
    
    iface lo inet loopback
    
    allow-hotplug eth0
    iface eth0 inet static
            address 10.0.0.2
            netmask 255.0.0.0
            network 10.0.0.0
            broadcast 10.255.255.255
            gateway 10.0.0.1
            dns-nameservers 10.0.0.1


eth0とtap0をbr0でブリッジするように設定する。IP等はbr0に設定する。

設定を間違えるとネットワークに繋がらなくなるので元のファイルは保存しておくこと。

    auto lo br0 # eth0を削除しbr0を追加
    
    iface lo inet loopback
    
    iface eth0 inet manual # manualに変更
    
    # ホットプラグは指定しない
    iface br0 inet static # br0に変更
            address 10.0.0.2
            netmask 255.0.0.0
            network 10.0.0.0
            broadcast 10.255.255.255
            gateway 10.0.0.1
            dns-nameservers 10.0.0.1
    				# 以下を追加
            bridge-ports all tap0
            bridge_stp off
            bridge_maxwait 0
            bridge_fd      0
            pre-up ip tuntap add dev tap0 mode tap user root
            pre-up ip link set tap0 up
            post-down ip link set tap0 down
            post-down ip tuntap del dev tap0 mode tap

これでネットワークを再起動すれば、br0とtap0が追加される。
ip addr listを実行して、以下のような表示がされれば成功している。

    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue state UNKNOWN 
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
        inet6 ::1/128 scope host 
           valid_lft forever preferred_lft forever
    2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master br0 state UP qlen 1000
        link/ether 90:2b:34:16:1c:f4 brd ff:ff:ff:ff:ff:ff
    18: tap0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master br0 state UP qlen 500
        link/ether c2:3b:da:6e:ed:43 brd ff:ff:ff:ff:ff:ff
    19: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP 
        link/ether 90:2b:34:16:1c:f4 brd ff:ff:ff:ff:ff:ff
        inet 10.0.0.2/8 brd 10.255.255.255 scope global br0
        inet6 fe80::922b:34ff:fe16:1cf4/64 scope link 
           valid_lft forever preferred_lft forever

## kvmの起動

以下のようなコマンドでKVMを起動する。-net nicと-net tapの2つの指定がポイント。

    kvm -hda hoge.img -m 1024 -monitor stdio -net nic -net tap,ifname=tap0,script=no,downscript=no

これでゲストはtap0を通じて外部と自由に通信できるようになる。

参考:  
- [http://wiki.debian.org/BridgeNetworkConnections](http://wiki.debian.org/BridgeNetworkConnections)
- [http://wiki.libvirt.org/page/Networking#Altering_the_interface_config](http://wiki.libvirt.org/page/Networking#Altering_the_interface_config)
