---
layout: blog
title: debian squeezeのIPv6を無効化
tag: linux
---



/etc/sysctl.d/disableipv6.confに以下の1行を記述し、OSを再起動することでIPv6を無効化できる。

    net.ipv6.conf.all.disable_ipv6=1

最近はさくらのVPSなどで無意識のうちにIPv6のグローバルIPアドレスが当たっているケースもあるので用心したい。

参考:  
[How to turn off IPv6](http://wiki.debian.org/DebianIPv6#How_to_turn_off_IPv6)
