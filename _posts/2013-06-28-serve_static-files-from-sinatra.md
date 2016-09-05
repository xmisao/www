---
layout: blog
title: Sinatraで静的ファイルを配信する方法
tag: sinatra
---



Rubyの軽量WebアプリケーションフレームワークSinatraで、静的なファイルをどのように配信すべきか? という話。英語のWebページを漁っていたら以下の記事を見つけたので紹介する。

[the best way to serve static files from Sinatra](http://lifeascode.com/2013/01/24/the-best-way-to-serve-static-files-from-sinatra/)

要約すると、Sinatraでファイルは配信せずに、上位のRackで処理してしまうのが簡単という内容だ。

config.ruに以下の内容を追加し、ディレクトリや個別ファイルの配信のため以下のmapを定義する。

~~~~
#map a directory including a directory listing
map "/js" do
    run Rack::Directory.new("./resources/js")
end
 
# map just one file
map "/favicon.ico" do
    run Rack::File.new("./resources/favicon.ico")
end
~~~~

これでrackupすれば/jsのアクセスには./resources/js内のファイルが配信し、/favicon.icoには./resources/favicon.icoを配信することができる。
