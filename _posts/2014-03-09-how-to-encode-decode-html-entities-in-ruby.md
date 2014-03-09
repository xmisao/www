---
layout: blog
title: RubyでHTMLの実体参照をエンコード/デコードする方法
tag: ruby
---

# RubyでHTMLの実体参照をエンコード/デコードする方法

RubyでHTMLの実体参照をエンコード/デコードするには、標準添付ライブラリ`cgi`が利用できる。

`CGI.escapeHTML`は、文字列中の&\"<>を実体参照に置換してエンコードした文字列を返すメソッドだ。

~~~~
require 'cgi'
string = CGI.escapeHTML('test "escaping" <characters>')
p string #=> "test &quot;escaping&quot; &lt;characters&gt;"
~~~~

実体参照の文字列をデコードするには`CGI.unescapeHTML`メソッドを使用する。

~~~~
require 'cgi'
string = CGI.unescapeHTML("test &quot;unescaping&quot; &lt;characters&gt;")
p string #=> "test \"unescaping\" <characters>"
~~~~

なおRuby on Railsでは`cgi`ライブラリを使用せずとも、`h`メソッドで実体参照にエンコードした文字列が得られる。

~~~~
<%= h 'escaping <html>' %>
~~~~

参考

- [How do I encode/decode HTML entities in Ruby?](http://stackoverflow.com/questions/1600526/how-do-i-encode-decode-html-entities-in-ruby)
