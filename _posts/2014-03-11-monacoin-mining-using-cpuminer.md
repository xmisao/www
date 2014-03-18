---
layout: blog
title: cpuminerによるモナーコインの採掘
tag: monacoin
---

# cpuminerによるモナーコインの採掘

流行りの暗号仮想通貨ビットコインの影には、幾多の無名の暗号仮想通貨が存在する。
2ch発祥のモナーコイン(Monacoin)もそんな暗号仮想通貨の1つだ。

今のところモナーコインはほとんど値段がつかない、所詮コンピュータを使った"お遊び"ではあるが、流行りに乗ってモナーコインを採掘してみることにする。

## 採掘に必要なもの

コンピュータと専用のソフトがあればモナーコインは自分で採掘できる。
採掘とは計算によってモナーコインを自力で作り出すことだ。
暗号仮想通貨ではこの計算のことを金や宝石を掘り出すことに例えて採掘と呼んでいる。

このエントリでは`cpuminer`というソフトでCPUを使ってモナーコインを採掘するので、使うのはどのようなコンピュータであっても構わない。
あなたの手元のコンピュータでも、VPSでも、専用サーバでも、ともかくコンピュータであれば何でも良い。

なお高機能なグラフィックカードを搭載したコンピュータなら、GPUを駆使して`cudaminer`や`cgminer`というソフトを使って、より効率的にモナーコインを採掘することも可能だ。

## ソロマイニングとプールマイニング

暗号仮想通貨の採掘には、自分ひとりで採掘するソロマイニングと呼ばれる方法と、みんなで一緒に採掘するプールマイニングという方法がある。

ソロマイニングでは採掘した暗号通貨がすべて自分ものになるが、採掘できるかは運なので必ずしも暗号仮想通貨が得られるとは限らない。

一方プールマイニングはみんなで採掘を行ってその分け前をもらう方法だ。みんなでものすごい量の採掘をして、それを分けるから、確実に暗号仮想通貨が得られるというわけだ。

このエントリではモナーコインをプールマイニングで採掘することにする。

## 採掘場を選ぶ

プールマイニングを行うには、採掘場というシステムにアカウントを作る必要がある。
モナーコインには以下にあげるとおりいくつかの採掘場が存在する。

- [2chpool](http://mona.2chpool.com)
- [monapool](http://mona1.monapool.com)
- [CryptoPoolMining.com](https://www.cryptopoolmining.com/mona/)
- [SolidPool](http://solidpool.org/)
- [HappyMiners.net](http://mona.happyminers.net/)

採掘場によって、どのように分け前を配分するのかが異なる。
今回は一番上にあったので2chpoolで採掘することにする。

## 2chpoolへの登録とワーカーの追加

2chpoolにアクセスする。

- [2chpool](http://mona.2chpool.com)

登録の手順は以下。

1. 画面左のメニューからOTHERSのSign Upを選択
2. USERNAME, PASSWORD, REPEAT PASSWORD, EMAIL, EMAIL REPEAT, PINを入力してRegisterを押下
3. 画面右上のフォームにUSERNAMEとPASSWORDを入力してLoginを押下

これで登録とログインができた。
続いてワーカーという採掘を行うコンピュータの追加を行う。
1つのアカウントに複数のワーカーが登録でき、全ワーカーの貢献に応じてアカウントにモナーコインが分配されるというわけだ。

1. 画面左のメニューからMY ACCOUNTのMy Workerを選択
2. WORKER NAMEとWORKER PASSWORDを入力してAdd New Workerを押下

## cpuminerのダウンロードとインストール

採掘を行うコンピュータにcpuminerをダウンロードする。

- [cpuminer](http://sourceforge.net/projects/cpuminer/)

OS毎にコンパイル済みのバイナリファイルが用意されている。
一例として64bit版のLinuxであれば`pooler-cpuminer-2.3.3-linux-x86_64.tar.gz`をダウンロードする。

以下のコマンドで展開すると、`minerd`という実行可能ファイルが現れる。
これで準備は完了だ。

    tar zxvf pooler-cpuminer-2.3.3-linux-x86_64.tar.gz

## cpuminerの起動

以下のように起動する。`USER`はユーザ名に、`WORKER`はワーカー名に、`PASSWORD`はワーカーパスワードに読み替える。

    ./minerd -a scrypt -o stratum+tcp://mona.2chpool.com:5555 -u USER.WORKER -p PASSWORD

あとは2chpoolのDASHBOARDを眺めて画面右下、ACCOUNT INFORMATIONのMona Account Balanceの数値が上がるのを見守るのみ。

ようこそモナーコインの採掘へ!
