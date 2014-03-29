---
layout: blog
title: Gemのインストールで--no-ri --no-rdocをデフォルトにする方法
tag: ruby
---

# Gemのインストールで--no-ri --no-rdocをデフォルトにする方法

Gemをインストールする時、ドキュメントの生成はしばしば長い時間がかかる。ドキュメントのインストールが不要な場合は、ドキュメントの生成を抑止したいこともあるだろう。

`gem`コマンドでドキュメント生成を抑止するには、`--no-ri`と`--no-rdoc`をオプションを使用する。

~~~~
gem install --no-ri --no-rdoc x2ch
~~~~

本当にドキュメントが必要ない場合、`gem`コマンド実行の度にこの指定をするのは煩わしい。そのような場合はホームディレクトリに`.gemrc`ファイルを作成し、以下の内容を記述すればデフォルトでドキュメントの生成が抑止されるようになる。

~~~~
gem: --no-document
~~~~

参考

- [How to make --no-ri --no-rdoc the default for gem install?](http://stackoverflow.com/questions/1381725/how-to-make-no-ri-no-rdoc-the-default-for-gem-install)
