---
layout: default
title: debian squeezeでのKVMの使い方
---

# debian squeezeでのKVMの使い方

LinuxをホストOSとして仮想化を行うには、KVM(Kernel-based Virtual Machine)が手軽に利用できる。
KVMの利用にはIntel-VTやAMD-VをサポートしたCPUで、これらの仮想化支援機能がBIOSで有効になっている必要がある。

## KVMのインストール

kvmとbridge-utilsパッケージをインストールする。

    apt-get install kvm bridge-utils

## イメージファイルの作成

イメージファイルはqemu-imgコマンドで作成する。
kvm-imgコマンドも使えるが、qemu-imgを使うメッセージが出るので、qemu-imgの方が良い模様。

    qemu-img create -f qcow2 centos64.img 8G

上記コマンドではcentos64.imgというファイル名でqcow2の8GBのイメージファイルを作成している。
qcow2は利用した実際に利用した分しか容量を消費しない。

## 仮想マシンにゲストOSをインストール

仮想マシンの起動はkvmコマンドで行う。

    kvm -hda centos64.img -cdrom CentOS-6.4-x86_64-netinstall.iso -boot d -m 1024 -monitor stdio

各オプションの意味は以下の通り。詳しくはman kvmを参照。

* -hda centos64.img -- 先ほど作成したcetnos64.imgファイルを、ハードディスク0として使用する。
* -cdrom CentOS-6.4-x86_64-netinstall.iso -- CentOS-6.4-x86_64-netinstall.iso(ゲストOSのインストールCDイメージファイル)をCD-ROMとして使用する。
* -boot d -- dは最初のCD-ROMドライブからブートするオプション。manによると-boot drives形式の指定は古く、将来削除されると注意書きがある。
* -m 1024 -- 仮想マシンに1024MBのメモリを割り当てる。
* -monitor stdio -- 非グラフィックモードで起動。

仮想マシンのネットワークは、10.0.2.2がゲートウェイ、10.0.2.3がネームサーバの仮想ネットワークで、ゲストOSのホストは10.0.2.xになる(DHCPが使える)。
ゲストOSからホストOSのネットワークにアクセスできるが、逆にはアクセスできない。

なおkvmのウィンドウにフォーカスが当てると、マウスとキーボードの入力がゲストOSに取られてしまう。
フォーカスを外したい場合は、Ctrl + AltでホストOSに戻れる。

## 仮想マシンのゲストOSを起動

インストール済みのゲストOSを起動するだけなら以下で良い。

    kvm -hda centos64.img -m 1024 -monitor stdio

参考:  
[知って見るみるKVM（2）](http://www.atmarkit.co.jp/ait/articles/0904/15/news122.html)
