---
layout: blog
title: cal風に日本のカレンダーを表示するxcalコマンドを作った
tag: ruby
---

# cal風に日本のカレンダーを表示するxcalコマンドを作った

![xcal screenshot]({{ site.url }}/assets/2013_09_25_xcal.png)

私はターミナルで作業することが多いので、`cal`コマンドを良く使う。
calはカレンダーを表示するUNIXコマンドだ。
しかし、calは祝日対応はしていないので、9月のように祝日が多い月は困ってしまう。

そこで、日本の祝日に対応したカレンダーを表示する`xcal`コマンドをRubyで開発した。
祝日の情報源はGoogle Calendarが提供するiCalendarファイルをダウンロードして利用、出力は`cal -3`に似せて更に土日祝日に色付けしてカラフルにした。

gem化して公開したので以下でインストールできる。
一緒にicalendarパッケージが入る。

    gem install xcal

xcalパッケージには`xcal`コマンドが含まれている。
環境に依るが`/usr/local/bin`あたりに入るはずだ。
xcalにはオプションはなく、先月はじめから来月末までのカレンダーを表示する。

    xcal

スクリーンショットは冒頭のとおり。
これでいちいちブラウザを開くことなく、ターミナルでカレンダーを確認できるようになった。

- [RubyGems.org xcal](https://rubygems.org/gems/xcal)
- [GitHub xmisao / xcal](https://github.com/xmisao/xcal)
