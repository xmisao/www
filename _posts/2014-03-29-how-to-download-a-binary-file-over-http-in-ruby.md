---
layout: blog
title: RubyでHTTP経由でバイナリファイルをダウンロードする方法
tag: ruby
---



UNIX風OSであればwgetを実行してしまうのが簡単である。

~~~~
`wget http://www.xmisao.com/xmisao_icon_96x96.png`
~~~~

純粋にRubyスクリプトでファイルをダウンロードするのならnet/httpライブラリを使って以下のようにする。

~~~~
require 'net/http'
Net::HTTP.start('www.xmisao.com') do |http|
  res = http.get('/xmisao_icon_96x96.png')
  open('xmisao_icon_96x96.png', 'wb'){|f|
    f.write(res.body)
  }
end
~~~~

より簡単にopen-uriライブラリを使う方法もある。

~~~~
require 'open-uri'
open('xmisao_icon_96x96.png', 'wb'){|saved_file|
  open('http://www.xmisao.com/xmisao_icon_96x96.png', 'rb'){|read_file|
    saved_file.write(read_file.read)
  }
}
~~~~

参考

- [How do I download a binary file over HTTP?](http://stackoverflow.com/questions/2263540/how-do-i-download-a-binary-file-over-http)
