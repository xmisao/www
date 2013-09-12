---
layout: blog
title: sshによるポートフォワーディングまとめ
tag: ssh
---

# sshによるポートフォワーディングまとめ

sshには以下3種類のポートフォワーディング機能がある。ポートフォワーディングの説明はmanが詳しいが、さほどわかりやすいとは言えない。このエントリでは、ポートフォワーディングの使い方を図解して簡単にまとめる。

1. `-L`によるポートフォワーディング
2. `-R`による逆ポートフォワーディング
3. `-D`によるダイナミックフォワーディング

説明中のserver、remotehostはホスト名に、portやremoteportはポート番号に、それぞれ読み替えること。

## ポートフォワーディング

![port forward]({{ site.url }}/assets/2013_09_12_ssh_portforward_l.png)

~~~~
ssh -L port:remotehost:remoteport server
~~~~

serverを中継点にして、clientのportを、remotehostのremortportへフォワードする。

clientからは直接接続できないファイアウォール内側のホストに、serverを経由してアクセスしたい場合に使うポートフォワーディングだ。

## 逆ポートフォワーディング

![reverse port forward]({{ site.url }}/assets/2013_09_12_ssh_portforward_r.png)

~~~~
ssh -R port:remotehost:remoteport server
~~~~

`-L`の逆で、自分が中継点になる。serverのportを、remotehostのremortportへフォワードする。

clientがファイアウォールの内側に居て、ファイアウォール内側の別ホストに対して、外部からアクセスさせたい場合に使うポートフォワードだ。

## ダイナミックポートフォワーディング

![dynamic port forward]({{ site.url }}/assets/2013_09_12_ssh_portforward_d.png)

~~~~
ssh -D port server
~~~~

`-L`と似ているが、clientのportでSOCKSプロキシが立ち上がる。

SOCKSプロキシを経由した通信は、serverに中継されて他のホストへ送られる。他のホストからは、serverが通信してきたように見える。

## まとめ

ポートフォワーディング機能は、直接接続できないファイアウォール内部のホストと一時的に通信したい場合や、Webアプリケーションのデバッグなどの際に重宝する。[以前紹介したautosshを使えば](http://www.xmisao.com/2013/07/16/autossh-how-to.html)、恒久的にポートフォワーディングによるトンネルを張り続けることも可能だ。

ただし、作業の度にsshでポートフォワーディングするような状況なら、VPNを整備するなど、環境そのものを見直す必要もあるだろう。

※注意  
これら3種類のポートフォワーディングは、デフォルトでローカルホストにのみbindされる。ローカルホスト以外のホストにもトンネルを利用させたい場合は、bindアドレスの指定が別途必要になる。
