---
layout: blog
title: WiresharkでTCPセッションの通信内容を表示する方法
tag: network
---



![Wireshark]({{ site.url }}/assets/2014_01_26_wireshark_0.jpg)

Wiresharkでパケットキャプチャを行った際に、特定のTCPセッションに注目して、その通信内容を確認したい場合がある。そのような場合はWiresharkの*Follow TCP Stream*機能が利用できる。

![Wireshark]({{ site.url }}/assets/2014_01_26_wireshark_1.jpg)

使い方は簡単だ。通信内容を確認したいパケット上で右クリックし、出てくるメニューから*Follow TCP Stream*を選択する。

![Wireshark]({{ site.url }}/assets/2014_01_26_wireshark_2.jpg)

するとウィンドウがポップアップし、そのパケットの属するTCPセッションの通信内容をまとめて表示することができる。この機能は複数パケットにまたがるTCPセッションの通信内容を確認する場合に便利である。
