---
layout: blog
title: M+ FONTSをWebフォント化してSourceForge.jpでホスティングしてみた
tag: fonts
---

# M+ FONTSをWebフォント化してSourceForge.jpでホスティングしてみた

![M+ Web Fonts Demo]({{ site.url }}/assets/2014_01_01_mplus.png)
*[M+ Web Fonts Demo](http://www.xmisao.com/asset/samples/mplus/index.html)*

[M+ FONTS](http://mplus-fonts.sourceforge.jp/)はフリーで高品質な日本語フォントだ。M+ FONTSでは実験的に[Webフォントで公開されている](http://mplus-fonts.sourceforge.jp/webfonts/)が、残念ながら形式はTTFのみとなっている。これでは未だあなどれないシェアを持つInternet Explorerでは利用できず、より軽量なWOFFに対応したブラウザでもその恩恵にあずかることはできない。

今回、M+ FONTSを本格的にWebフォントとして活用したいと思い、先に紹介した[ttf2eot](http://www.xmisao.com/2014/01/04/ttf2eot-build-on-debian-wheezy.html)と[sfnt2woff](http://www.xmisao.com/2014/01/04/how-to-convert-ttf-to-woff-sfnt2woff.html)を使って、M+ FONTSの全TTFファイルをEOTとWOFFの両形式に変換した。さらにM+ FONTSはフリーなフォントなので、本家M+ FONTSに倣って、変換したフォントをオープンソース化してSourceForge.jpでホスティングするようにしてみた。

- [M+ Web Fonts Project](http://mplus-webfonts.sourceforge.jp/)

変換したフォントに加えて、全フォントの`@font_face`定義を記述したCSSも併せて公開しているので、これでCSSを数行書くだけで、どこからでもあらゆるブラウザでM+ FONTSを利用してページを表示させることができるはずだ。M+ FONTSのような高品質な日本語フォントがフリーなライセンスで配布されていて本当にありがたい。
