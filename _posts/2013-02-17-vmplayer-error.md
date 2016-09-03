---
layout: blog
title: 64bitのDebianでVMWare Playerの起動にlibprotobufのエラーで失敗する
tag: virtualization
---



vmplayerを起動したら下記のエラーが出てしまう。
libprotobufは2.4のはずで、どうにもできず。

    $ vmplayer
    Xlib:  extension "RANDR" missing on display ":0.0".
    Logging to /tmp/vmware-yuutaro/vmware-modconfig-13193.log
    filename:       /lib/modules/3.2.0-3-amd64/misc/vmmon.ko
    supported:      external
    license:        GPL v2
    description:    VMware Virtual Machine Monitor.
    author:         VMware, Inc.
    depends:        
    vermagic:       3.2.0-3-amd64 SMP mod_unload modversions 
    Xlib:  extension "RANDR" missing on display ":0.0".
    libprotobuf FATAL google/protobuf/stubs/common.cc:61] This program requires version 2.4.0 of the Protocol Buffer runtime library, but the installed version is 2.3.0.  Please update your library.  If you compiled the program yourself, make sure that your headers are from the same version of Protocol Buffers as your link-time library.  (Version verification failed in "out_linux/Release/obj/gen/proto_out/config/config.pb.cc".)

結局、LANG=Cで起動したら動作した。
libprotobufは全然関係ないエラーだった模様…。

    LANG=C vmplayer

以下のスレッドが参考になった。

[http://w1.log9.info/~2ch/201209/linux/1247465219.html?all_show](http://w1.log9.info/~2ch/201209/linux/1247465219.html?all_show)

> 826 ：  
>     ディストリ： Debian wheezy(amd64)  
>     VMPlayer： 5.0.0(64bit)  
>     $ vmplayer  
>     Logging to /tmp/vmware-judas/vmware-modconfig-9520.log  
>     filename: /lib/modules/3.2.0-3-amd64/misc/vmmon.ko  
>     supported: external  
>     license: GPL v2  
>     description: VMware Virtual Machine Monitor.  
>     author: VMware, Inc.  
>     depends:  
>     vermagic: 3.2.0-3-amd64 SMP mod_unload modversions  
>     libprotobuf FATAL google/protobuf/stubs/common.cc:61] This program requires version 2.4.0 of the Protocol Buffer runtime library, but the installed version is 2.3.0. Please update your library.  
>     If you compiled the program yourself, make sure that your headers are from the same version of Protocol Buffers as your link-time library. (Version verification failed in "out_linux/Release/obj/gen/proto_out/config/config.pb.cc".)  
>     中止  
>     ○やってみたこと  
>     ・vmplayer 4.0.4(x86_64)＋パッチ適用済みを再インストール。結果5.0.0の時と同じエラーで起動不能  
>     ・出力にあるprotobufに関係ありそうなパッケージlibprotobuf-dev(2.4.1-3_amd64)をインストール。結果は変わらず起動不能  
>     ・出力にあるgoogle/protobuf・・・の/usr/include/googleディレクトリをgoogle.bakに名前変更して、vmplayerを再インストールして起動。  
>     　結果、出力がFATAL google/protobuf・・・とパスも変わらず何も変化なし。  
>     ・他にprotobufディレクトリがないか検索(find / -name *protobuf* -print)。結果/usr/include/google/protobufのみヒット・・・  
>     ・packages.debian.orgから直接パッケージlibprotobuf-dev(2.4.1-3_amd64)をダウンロードしてvmplayerを再インストールして起動。結果変わらず起動不能  
>     ・再起動後、vmplayerを再インストールして起動。結果変わらず起動不能  
>     などなどを試してみたのですがまったく解決しません。  
>     vmplayer起動時の出力を見る限りprotobufランタイムライブラリが古いのが原因らしいけど、
>     今インストールしているprotobufパッケージのバージョンは2.4系列で2.3系列ではありません。  
>     以前構築していたDebian wheezy(i386)では普通に起動できていました。  
>     なにかわかる方アドバイスお願いします。  
> 827 ：  
>     >>826  
>     ウチではカーネルヘッダが無かったせいで同様のエラーが出てた  
>     protobufはひとまず無視してログ(vmware-modconfig-9520.log)にエラー原因が出力されていないか確認してみては？  
> 828 ：  
>     >>827  
>     レスどうも  
>     無事解決しました！  
>     logにはエラーらしいエラーがのってなくて、  
>     もしかしたらと思って  
>     起動するときにLANG=Cを付け加えたらうまく起動できました。  
>     ありがとうございました。   
