---
layout: default
title: JavaScriptでオブジェクトの内容をダンプする方法
---

# JavaScriptでオブジェクトの内容をダンプする方法

JavaScriptのデバッグ時にオブジェクトが持つ要素を一覧したい場合がある。
alert()ではObjectとしか出力できず不便。

Firefoxなら以下の1行でobjのプロパティをダンプしてWebコンソールに出力できる。
Google ChromeでもJavaScriptコンソールに出力できる模様。

    console.log(obj);

複数の要素も出力できる。

    console.log(obj1, obj2);

IEなど非対応のブラウザではconsoleが未定義なので、以下のようにif文で囲ってやれば他のブラウザでも邪魔をしない。

    if(console && console.log) { console.log(obj1, obj2); };

参考:  
[How can I print a JavaScript object?](http://stackoverflow.com/questions/957537/how-can-i-print-a-javascript-object)
