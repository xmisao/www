---
layout: blog
title: JavaScriptランタイムが無いというエラーでrails serverが起動しない場合
tag: ruby
---



`rails new`したプロジェクトを、`rails server`でさあ起動! というタイミングで以下のエラーが出て出鼻をくじかれた。

    /var/lib/gems/1.9.1/gems/execjs-2.0.2/lib/execjs/runtimes.rb:51:in `autodetect': Could not find a JavaScript runtime. See https://github.com/sstephensos for a list of available runtimes. (ExecJS::RuntimeUnavailable)

JavaScriptランタイムがないという。railsの実行にはNode.jsのようなJavaScriptの実行環境が必要だ。Node.jsをインストールすると解決。

~~~~
git clone git://github.com/joyent/node.git
cd node
./configure
make
sudo make install
~~~~
