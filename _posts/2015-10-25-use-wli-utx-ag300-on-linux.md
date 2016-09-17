---
layout: blog
title: Linuxで無線LANが不安定な場合、いっそイーサネットコンバータを使うのもあり
tag: linux
---



![WLI-UTX-AG300/C](/assets/2015_10_25_wli_utx_ag300c.jpg)

残念ながらLinuxでは、WindowsやMacと比較して、未だに無線LANの接続が不安定なことがあります。
うまく設定したり適切なドライバを使用したりできれば、実用に耐える場合もあるのかも知れません。
しかし、私がこれまで使用してきたノートPC(ThinkPad X200、Aspire One、ThinkPad X240)では、いずれも接続こそできるものの、突然接続が切れて再起動するまで再接続できなくなるなど、満足な使用感を得ることはできませんでした。

Linuxで無線LANのトラブルに業を煮やしたなら、力技ではありますが、無線LANを有線LANに変換する機器(決まった名称は無いようなので、以下ではイーサネットコンバータと呼びます)を使用するのが良いかも知れません。
PCは有線LANでイーサネットコンバータに接続して、イーサネットコンバータ経由で無線LANに接続するようにすれば、間接的ではありますが安定して無線LANに接続できるようになります。

大部分のイーサネットコンバータは、据え置き型で、電源を必要とするものが多く、筐体も大きくて、モバイル用途には向きませんが、ごく一部のイーサネットコンバータは、USBで給電が可能で、筐体のサイズも比較的小さく抑えられているものもあります。
具体的にはBUFFALOのWLI-UTX-AG300/Cです。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B008MRUINC/xmisao-22/ref=nosim/" name="amazletlink" target="_blank"><img src="http://ecx.images-amazon.com/images/I/31VAZYoViDL._SL160_.jpg" alt="BUFFALO 11n/a/g/b 300Mbps 簡単無線LAN子機 WLI-UTX-AG300/C" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B008MRUINC/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">BUFFALO 11n/a/g/b 300Mbps 簡単無線LAN子機 WLI-UTX-AG300/C</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 15.10.25</div></div><div class="amazlet-detail">バッファロー (2012-08-01)<br />売り上げランキング: 223<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B008MRUINC/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>


WLI-UTX-AG300/Cは、BUFFALOの無線LANルータの子機という位置づけです。
子機ですが、特定の親機でなくとも、規格さえ対応していればどんな無線LANにも接続することが可能です。
USBのバスパワーで動作するため、ノートPCのUSBポートからでも給電できます。
メーカー発表の最大消費電力は2.5Wとなっています。
またサイズも 136 x 37 x 26 mm と、イーサネットコンバータとしては圧倒的な小型さで、持ち運んでの使用でも許容できる大きさです。
価格も、本日時点でAmazonで約3,000円で、リーズナブルです。

私は、ThinkPad X240でWLI-UTX-AG300/Cを使用しています。冒頭の写真が使用中の様子です。

メリットは、内蔵の無線LANアダプタを使用するより、圧倒的に安定しており、まず接続が途切れることはなくなったこと。
喫茶店でノートPCを広げて、docomoのスマートフォンのテザリングでインターネットに接続しても、SSHも安定して繋がり続けます。

デメリットは、やはり荷物が増えることと、多少ノートPCのバッテリーの持ちが悪くなったかな、ということです。
しかし、このエントリーで興味を持ってくれる方は、そもそも相当不便なことがわかっているのに、何としてもノートPCでLinuxを動かしたいという覚悟の方でしょうから、この程度のデメリットは問題にならないと思います。

WLI-UTX-AG300/Cは私にとってはとても良い買い物でした。
時間があれば、WLI-UTX-AG300/Cのネットワーク的な仕組みや、設定時の使いやすさ・使いにくさなど、使用感についても別途まとめてみたいと思います。
