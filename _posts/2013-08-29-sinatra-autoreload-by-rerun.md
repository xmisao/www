---
layout: blog
title: Sinatraで編集したファイルをオートリロード(自動再読み込み)する方法
tag: sinatra
---



Sinatraは[Sinatra::Reloader](http://www.sinatrarb.com/contrib/reloader)でオートリロードが可能になっているが、SinatraのFAQでは、[rerun](https://github.com/alexch/rerun)を使ってオートリロードすることを推奨している。

- [How do I make my Sinatra app reload on changes?](http://www.sinatrarb.com/faq.html#reloading)

rerunは、ファイルの変更を監視して、ファイルが変更されタイミングで、自動的にプログラムを再起動するプログラムだ。rerunで実行するプログラムは何でも良いので、Sinatra以外にも様々な応用が可能だ。

インストールは以下。

    gem install rerun

使い方は簡単だ。
もし以下のようにfoo.rbを実行していたとすると、

    ruby foo.rb

単にrerunをつけて実行してやるだけだ。
これで、ファイルの変更と同時に、foo.rbが再実行される。

    rerun ruby foo.rb

Sinatraであれば、rackupしてやるとか、thin startするとか、好きにすれば良い。

~~~~
rerun rackup
~~~~

~~~~
rerun thin start
~~~~

Sinatraに限らず、rerunを使うと開発速度が跳ね上がるので、ぜひ活用したい。
