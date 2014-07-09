---
layout: blog
title: Debian WheezyでDartプログラミング
tag: ['debian', 'dart']
---

# Debian WheezyでDartプログラミング

GoogleのいわゆるAltJSであるDartには、今日時点でDebian Wheezy向けのパッケージが用意されている。
以下からダウンロードできる。`dart_1.5.3-1_amd64.deb`がそれだ。

- [http://gsdview.appspot.com/dart-archive/channels/stable/release/latest/linux_packages/debian_wheezy/](http://gsdview.appspot.com/dart-archive/channels/stable/release/latest/linux_packages/debian_wheezy/)

このパッケージはサーバ用で、Dart Editorなどは含まれていない素のDart環境となっている。
当たり前だがDebian Wheezyなら`dpkg`でインストールするだけで、dartを使い始めることができる。
便利。

~~~~
dpkg -i dart_1.5.3-1_amd64.deb
~~~~

インストールしたら適当にDartのコードを書いて実行してみよう。
`hello.dart`として以下の内容を記述する。

~~~~
void main(){
  print("Hello, Dart!");
}
~~~~

Dartの実行はそのまんま`dart`コマンドである。
以下のようにして実行する。

~~~~
dart hello.dart
~~~~

~~~~
Hello, Dart!
~~~~

ちなみにdartをjsにコンパイルする`dart2js`は`/usr/lib/dart/bin/dart2js`へインストールされる。
なぜパスが通った場所にインストールされないのかは不明…。
必要なら`/usr/bin`あたりにシンボリックリンクを作っておこう。

~~~~
ln -s /usr/lib/dart/bin/dart2js /usr/bin/dart2js
~~~~

先ほど書いた`hello.dart`をコンパイルするなら以下のようにする。

~~~~
dart2js --out=hello.js hello.dart
~~~~

Dartが出力するJavaScriptはごちゃごちゃしているが、`hello.js`を見ると以下のような部分が確認できるはずである。

~~~~
  main: function() {
    H.printString("Hello, World!");
  }
~~~~

きちんとJavaScriptにコンパイルされていることがわかる。
もちろんブラウザで読みこめば実行することができる。
Dartすごい。
