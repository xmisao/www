---
layout: blog
title: frameやiframeのURLはJavaScriptで外部から取得できない
tag: javascript
---

# frameやiframeのURLはJavaScriptで外部から取得できない

frameやiframeのURLを取得できるのは、同一ドメインの場合のみである。
外部のWebページをframeやiframeで表示している場合、そのURLをJavaScriptで取得する方法はない。
これはクロスドメインの制約で、ブラウザのセキュリティのためだ。

以下のようなコードは、実行時に権限がないとエラーになる。

~~~~
<html>
	<frameset rows="100,*">
		<frame src="http://yahoo.co.jp/" name="webpage" onload="alert(webpage.location.href)">
	</frameset>
</html>
~~~~

frameやiframeを使ってユーザを騙し、行動をトラッキングするようなことができないように、このような制限がかかっているのだろう。
もしURL取得が可能なら、面白いことができそうなだけに残念である。
