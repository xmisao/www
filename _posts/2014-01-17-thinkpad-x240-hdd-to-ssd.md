---
layout: blog
title: ThinkPad X240のHDDをSSDに換装する(写真つき)
tag: thinkpad
---



従来のThinkPadは簡単にHDDやメモリにアクセスでき容易に交換できることがユーザに受けていたところがある。ThinkPadのSSDモデルは高価だが、HDDを自分でSSDに換装してしまえば安くあがるからだ。

では本格的にウルトラブック路線にシフトしたX240はどうか。本機も[保守マニュアル](http://download.lenovo.com/jp/mobiles_pdf/sp40a26001_j.pdf)が公開されており、ドライブやメモリのユーザ交換が可能になっている。

ただし、X240は背面のカバーを開けるのに手間がかかり、従来のThinkPadのHDD換装難度「易」とすると、一段難しく換装難度は「中」といったところだ。ぶきっちょを自覚している人はその点を気をつけよう。以下では写真つきでX240のHDDをSSDに換装する手順を紹介する。

なお換装するSSDはSamsungの840EVO MZ-7TE250B/ITにした。容量が250GBクラスのSSDとしては容量単価が安く、また厚みもスペック上6.8mmと薄いことから、今回の用途に最適だと判断した。価格.comでも売れ行きは好調で、現時点では主要な通販サイトでは品切れも見られる。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B00E5YOPZI/xmisao-22/ref=nosim/" name="amazletlink" target="_blank"><img src="https://images-fe.ssl-images-amazon.com/images/I/413Vg%2BfvzoL._SL160_.jpg" alt="Samsung SSD840EVO ベーシックキット250GB MZ-7TE250B/IT (国内正規代理店 ITGマーケティング取扱い品)" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B00E5YOPZI/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Samsung SSD840EVO ベーシックキット250GB MZ-7TE250B/IT (国内正規代理店 ITGマーケティング取扱い品)</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 14.01.17</div></div><div class="amazlet-detail">日本サムスン (2013-08-07)<br />売り上げランキング: 142<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B00E5YOPZI/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>

# 0. 回復ドライブを作成しておく

Windowsを使わないのならこの手順は必要ないが、事前にWindows 8の回復ドライブを作成しておくことをおすすめする。回復ドライブの作成には16GB以上のUSBメモリが必要である。回復ドライブの作成方法についてはLenovoの公式ホームページを参照。

- [Microsoft Windows 8プリロードのLenovoシステムでリカバリーメディアを作成し、復元する方法](http://support.lenovo.com/ja_JP/research/hints-or-tips/detail.page?AliasID=SF12-D0247)

# 1. BIOSから内蔵バッテリーを無効化する

ThinkPad X240は内蔵のフロント・バッテリーとリア・バッテリーを搭載している。パーツ交換を行うにあたって、通電しながらの作業を防ぐため、事前に内蔵のバッテリーを無効化してやる必要がある。

ThinkPadの電源をオンする際にF1ボタンを押してThinkPad Setupプログラム(ようはBIOSの設定画面)に入る。「Config」->「Power」と進み、「Disable build-in battery」メニューを選択する。「Setup Warning」ウィンドウが表示されるので、これに「Yes」と回答すると自動的に電源が切れる。

なおAC電源アダプターを再接続すると、自動的にこの項目は有効になるとのことなので注意。

# 2. リア・バッテリーを取り外す

![Step2](/assets/2014_01_17_hdd_to_ssd_00.jpg)

ThinkPadを完全に通電していない状態にするため、リア・バッテリーを取り外す。図は保守マニュアルからの引用。リア・バッテリーを取り外す際は*図中1*の2箇所のラッチを操作して、バッテリーを引き抜く。

# 3. 背面カバーのネジを8箇所緩める

![Step3](/assets/2014_01_17_hdd_to_ssd_01.jpg)

背面カバー(保守マニュアルによると、ベース・カバー・アセンブリー)を取り外すため、まず8箇所のネジを緩める。写真で○をつけた箇所が緩めるネジである。なおこのネジはカバーと密着しており、完全に引き抜くことはできないようだ。

# 4. 背面カバーを取り外す

![Step4](/assets/2014_01_17_hdd_to_ssd_02.jpg)

保守マニュアルではあっさり記載されているのだが、この工程が難所である。背面カバーには随所に爪があるため、基本的にはそこを狙ってカバーを引き剥がす。

手での作業は難しいので、私はマイナスドライバーを隙間に差し込み、無理やり開けた。ただマイナスドライバーではカバーを傷つける可能性があるので、もっと柔らかく細いものがあればそれを使った方が良いだろう。

無事、背面カバーを取り外したら、マザーボードがむき出しになる。写真、左下がHDDである。ThinkPadをここまで分解したことはなかったので、私はちょっとドキドキである。

# 5. HDDの2箇所のネジを取り外す

![Step5](/assets/2014_01_17_hdd_to_ssd_03.jpg)

図は保守マニュアルから引用。*図中1*と*図中l2*のドライブ本体とケーブルを固定している2箇所のネジを取り外す。さらに*図中1*で固定されていた部品を取り外す。これでドライブが取外し可能となる。

ドライブを取り出し、SATAケーブルをドライブから取り外す。保守マニュアルではSATAケーブルをマザーボードから取り外す手順も掲載されているが、その必要はない。ここは正直いじらない方が無難だと思う。

# 6. HDDのカバーを取り外す

![Step6-1](/assets/2014_01_17_hdd_to_ssd_04.jpg)

HDDはプラスチックのカバーで固定されているので、このカバーを取り外す。図は保守マニュアルからの引用。このカバーはネジレスなので、引っ張るとぽこぽこと外れるようになっている。HDDを完全に取り外すと以下の写真の状態になる。

![Step6-2](/assets/2014_01_17_hdd_to_ssd_05.jpg)

# 7. SDDにカバーを装着し、SATAケーブルをSSDに接続して、埋め込む

![Step7](/assets/2014_01_17_hdd_to_ssd_06.jpg)

SSDにカバーを装着して、SATAケーブルをSSDに接続する。あとは*手順 5.*、*手順 4.*、*手順 3.*、*手順 2.*を全く逆の手順で行い、背面カバーを被せれば良い。カバーは位置を合わせて、爪の部分を押していくとうまくはまるので、外すより取り付ける方が簡単である。

# おわりに

以上でThinkPad X240のHDDをSSDに換装することができた。ThinkPadの電源をオンにしてSSDが認識されているかを確認しよう。
