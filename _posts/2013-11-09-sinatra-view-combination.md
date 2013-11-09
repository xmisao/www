---
layout: blog
title: SinatraでViewから別のViewを呼び出す方法
tag: sinatra
---

# SinatraでViewから別のViewを呼び出す方法

ヘッダやフッタを共通化するために、Viewから別のViewを呼び出して利用したい場合がある。Sinatraではどうすれば良いのか、いろいろ試行錯誤したが、結局何も考えずにViewで`erb`を呼べば良いとわかった。erb固有の流儀に従う必要はないらしい。試していないが、他のテンプレートエンジンでも同様だろう。例は以下のとおり。

- app.rb

~~~~
require 'sinatra'
get '/' do
	erb :main
end
~~~~

- main.erb

~~~~
<%= erb :header %>
<h1>Hello, World!</h1>
<%= erb :footer %>
~~~~

- header.erb

~~~~
<html>
<body>
~~~~

- footer.erb

~~~~
</body>
</html>
~~~~
