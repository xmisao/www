---
layout: blog
title: JavaScriptでマウス座標を取得する最も簡単な方法
tag: javascript
---

# JavaScriptでマウス座標を取得する最も簡単な方法

JavaScriptでマウス座標を取得するには`onmousemove`イベントハンドラで、イベントオブジェクトの`clientX`と`clientY`を読めば良い。以下はマウス座標を表示するHTMLの例である。わずか7行のJavaScriptで実装が可能だ。

~~~~
<html>
<head>
<script type="text/javascript">
(function() {
    window.onmousemove = handleMouseMove;
    function handleMouseMove(event) {
        event = event || window.event; // IE対応
        document.body.innerHTML = event.clientX + ", " + event.clientY;
    }
})();
</script>
</head>
<body>
</body>
</html>
~~~~

- [Mouse Position Sample HTML]({{ site.url }}/assets/samples/mouseposition/index.html)

Internet Explorerではイベントハンドラにイベントオブジェクトが渡されないため、上記のコードでは`event`が`null`なら`window.event`でイベントオブジェクトを上書きするようになっている。`||`演算子を使えば条件分岐は必要ない。

- [Javascript - Track mouse position](http://stackoverflow.com/questions/7790725/javascript-track-mouse-position)
