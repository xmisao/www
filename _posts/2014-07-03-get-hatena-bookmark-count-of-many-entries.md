---
layout: blog
title: 複数URLのはてなブックマーク数を一括取得するRubyスクリプト
tag: ['ruby', 'hatena']
---

# 複数URLのはてなブックマーク数を一括取得するRubyスクリプト

[はてなブックマーク件数取得API](http://developer.hatena.ne.jp/ja/documents/bookmark/apis/getcount)を使えば最大で50件のURLに対してはてなブックマーク数を取得することができる。これを複数回に分けて呼び出せば、理屈の上では何件でもはてなブックマーク数を取得できる。

自分のブログのはてなブックマーク数を把握したいと思い、以下のRubyスクリプト`get_hb_count.rb`を書いた。このスクリプト、ファイルからURLを読み込み、そのURLのはてなブックマーク数を一括取得して出力する。

~~~~ ruby
require 'open-uri'
require 'json'
require 'uri'

ENDPOINT = "http://api.b.st-hatena.com/entry.counts?"

open(ARGV[0]){|f|
  f.each_slice(50){|list|
    api_url = ENDPOINT + list.map{|url| 'url=' + URI.encode(url)}.join('&')
    JSON.parse(open(api_url){|f| f.read}).each{|url, count|
      puts [count, url].join(' ')
    }
  }
}
~~~~

使い方はURLの書かれたファイル(以下の例では`URL`)を引数に与えて実行する。

~~~~
ruby get_hb_count.rb URL
~~~~

入力となるファイルは、単に1行に1つURLを記述しただけのテキストファイル。以下はその例。

~~~~
http://www.xmisao.com/2013/11/10/linux-kill-signals.html
http://www.xmisao.com/2014/01/21/how-to-use-powertop.html
http://www.xmisao.com/2014/05/13/vim-ruby-interface.html
~~~~

この入力に対する出力は以下のようになる。あとはシェルのコマンドで自由に整形するなりできる。

~~~~
379 http://www.xmisao.com/2013/11/10/linux-kill-signals.html
287 http://www.xmisao.com/2014/01/21/how-to-use-powertop.html
45 http://www.xmisao.com/2014/05/13/vim-ruby-interface.html
~~~~
