---
layout: blog
title: fluentdでイベントを他のノードに転送する最小の設定
tag: fluentd
---

# fluentdでイベントを他のノードに転送する最小の設定

fluentdでイベントを他のノードに転送するにはforwardアウトプットプラグインを使う。
転送されたイベントを他のノードから受け取るにはforwardインプットプラグインを使う。
すべてのイベントを他のノードに転送する送信側と受信側の最小の設定は以下のとおり。

送信側

~~~~
<match **>
  type forward
  <server>
    host 1.2.3.4
  </server>
</match>
~~~~

受信側

~~~~
<source>
  type forward
</source>
~~~~

ポートを指定しなかった場合、fluentdが使用するデフォルトのポートは24224である。
TCPだけでなくUDPも使用するのでファイアウォールの設定に注意が必要。

その他、詳しいオプションについてはfluentdのマニュアルを参照。

参考

- [forwardインプットプラグイン](http://docs.fluentd.org/ja/articles/in_forward)
- [forwardインプットプラグイン](http://docs.fluentd.org/ja/articles/out_forward)
