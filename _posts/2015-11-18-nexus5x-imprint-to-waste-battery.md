---
layout: blog
title: Nexus 5Xの指紋センサがバッテリーを浪費しているかも知れない
tag: ['nexus5x', 'mobile']
---



![Nexus 5X](/assets/2015_11_18_5x1.jpg)

# はじめに

このエントリは推測で書いています。内容の正しさはご自身で判断して下さい。

Nexus 5Xの指紋センサによるロック解除(Nexus Imprint)を有効にしていると、指紋センサがこすれて誤作動することで、バッテリーを浪費しているかも知れません。私の場合、登録した指紋をすべて削除してNexus Imprintを無効にしたところ、Nexus 5Xのバッテリーの持ちが劇的に改善しました。

# 推測

Nexus 5Xを使用していて、以下の条件をすべて満たす場合、私と同じ現象にはまっています。
Nexus Imprintに登録している指紋をすべて削除することで、バッテリーの消費を抑えられる可能性があります。

* バッテリー消費が非常に早いと感じる
* Nexus Imprintに1つ以上指紋を登録している
* 指紋センサが物や人肌に触れる状態で携帯している事が多い(ズボンのポケットに入れるなど)
* `設定` -> `電池`の画面で、`Android OS`と`Androidシステム`が特に多くバッテリーを消費している(特定のアプリがバッテリーを浪費しているわけではない)
* `設定` -> `電池`でチャートをタップして見られる画面で、`スリープなし`が`画面点灯`していなくても頻繁に発生しており、`スリープなし`の間のバッテリー消費が激しい(以下の画像を参照)
* バッテリーを消費するあらゆる要因(モバイルネットワーク, Wi-Fi, Bluetooth, NFC, 位置情報, 通知, 同期, 画面の自動回転, アンビエント表示)をすべて無効にしてもなおバッテリー消費を抑えられない

![Battery Chart 1](/assets/2015_11_18_5x2.png)

_問題発生時のバッテリーのチャート。左側おおよそ12時までの時間帯に特に注目。画面点灯(Screen on)していない状態で、頻繁にスリープなし(Awake)となっており、バッテリー消費が多くなっていることがわかる。_

# 推測に至るまでの経緯

月初にNexus 5Xを購入しました。良い端末だとは思いますが、バッテリーの持ちが不満でした。具体的には、朝に100%まで充電して仕事に行って家に帰る頃には、40%以下しかバッテリーの残量がないという状態でした。電車での移動中と昼休み程度にしかNexus 5Xを使用していないのにも関わらず、です。

何がバッテリーを消費しているか`設定` -> `電池`の画面から確認しましたが、原因はよくわかりませんでした。
最もバッテリー消費の激しいアプリは`Android OS`と`Androidシステム`で、この画面からは特定のアプリがバッテリーを浪費しているようには見えません。

バッテリーがいつ消費されているのかグラフを見ると、操作中のバッテリー消費が早いのは勿論ですが、操作していない時のバッテリー消費が想像より多いことが気になりました。
特に`画面点灯`していない間に、`スリープなし`の状態が多く発生し、`スリープなし`の状態でバッテリー消費が多くなっていました。
この時点で何らかのバックグラウンドで行われている処理がスリープに入るのを邪魔しており、バッテリーを消費しているのだろうと推測しました。

推測に基づいて、バッテリーを消費するあらゆる要因を可能な限り無効にしました。
バッテリーを消費するという情報をネットで見た`アンビエント表示`をまず無効にし、通信(モバイルネットワーク, Wi-Fi, Bluetooth, NFC), センサ(位置情報, 画面の自動回転), アプリのバックグラウンド処理(通知, 同期)も無効にて試してみましたが、バッテリーの消費に目立った変化はありませんでした。

ここで、家に居るときはバッテリーをあまり消費しないことが疑問でした。12時間放置していても10%くらいしか使いません。最初はモバイルネットワークとの通信でバッテリーを使っており、家ではWi-Fiなのでバッテリーの減りが穏やかなのかと思っていました。しかし、モバイルネットワークを無効にしてもやはり外出中はバッテリーの消費が激しいことを確認したため、別の要因があるのかと思いました。

そして、購入直後から当然のように使っていて、まったく意識していなかったのですが、Nexus Imprintを使っていることを思い出しました。しかも、いちいち電源ボタンで画面を点灯させていたので知りませんでしたが、実はNexus Imprintは画面が点灯していない状態でも指紋センサに指を当てるとロックが解除できます。私は普段ポケットにNexus 5Xを入れているので、まさかこいつが犯人か!(｀ω´)と思ったわけです。

実際に、Nexus Imprintに登録していた指紋をすべて削除したところ、以下の画像のとおりバッテリーの持ちがめざましく改善しました。`画面点灯`している時しか`スリープなし`になっていないことがわかります。この結果、以前は帰宅時には40%以下になっていたバッテリーを、70%ほど残して家に帰ることができるようになり、実にバッテリー消費は半分になったのです。

![Battery Chart 2](/assets/2015_11_18_5x3.png)

_Nexus Imprintを無効にして1日過ごした時のバッテリーのチャート。画面点灯(Screen on)の時しか、スリープなし(Awake)の状態が発生しておらず、画面点灯していないときは緩やかなバッテリー消費が保たれている。_

以上が、指紋センサがバッテリー浪費の原因だと推測するに至った経緯のすべてです。

# まとめ

しかしこれ、本当に指紋センサがポケットの中で誤作動していることが原因で、バッテリーを浪費しているのだとしたら、設計が良くない端末だと思います。服の素材や携帯の仕方にも依るのだとは思いますが、あまりにもユーザがどう製品を使用するかについて、考慮されていないのではないでしょうか。(日本価格はともかくとして)機能や使用感についてはおおよそ満足しているだけに残念です。

Nexus 5Xの使用感については、後日別途感想をまとめたいと思っています。
