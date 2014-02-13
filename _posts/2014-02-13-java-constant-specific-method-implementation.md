---
layout: blog
title: Javaの定数固有メソッド実装 -- enumにabstractメソッドを定義して定数に固有の振る舞いを実装する
tag: java
---

# Javaの定数固有メソッド実装 -- enumにabstractメソッドを定義して定数に固有の振る舞いを実装する

Javaのenumは特殊なクラスであり、enumにメソッドを定義することができる。では、そのメソッドをabstractにしたらどうなるだろうか? 実はenumに定義したabstractメソッドは、定数でオーバーライドすることになる。

これを利用すると定数による場合分けなしで、定数に固有の振る舞いを実装できる。この実装は定数固有メソッド実装(*constant-specific method implementation*)と呼ばれる。

以下は演算子を表すenumに、その演算子を使った計算を適用する`apply`メソッドを実装した例である。

~~~~
public enum operator {
    PLUS{
        @Override
        double apply(double v0, double v1) {
            return v0 + v1;
        }
    },
    MINUTS{
        @Override
        double apply(double v0, double v1) {
            return v0 - v1;
        }
    },
    TIMES{
        @Override
        double apply(double v0, double v1) {
            return v0 * v1;
        }
    },
    DIVIDE{
        @Override
        double apply(double v0, double v1) {
            return v0 / v1;
        }
    };
    
    abstract double apply(double v0, double v1);
}
~~~~

このenumは以下のように利用できる。

~~~~
operator.PLUS.apply(1, 2); //=> 3.0
operator.MINUS.apply(1, 2); //=> -1.0
operator.TIMES.apply(1, 2); //=> 2.0
operator.DIVIDE.apply(1, 2); //=> 0.5
~~~~

定数固有メソッド実装は、定数による場合分けを利用した実装より、enumを追加した際に実装の追加を忘れてしまうことを避けられる点で優れている。JavaのenumについてはEffective Javaの項目30が詳しい。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/489471499X/xmisao-22/ref=nosim/" name="amazletlink" target="_blank"><img src="http://ecx.images-amazon.com/images/I/51E1m-weAXL._SL160_.jpg" alt="Effective Java 第2版 (The Java Series)" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/489471499X/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Effective Java 第2版 (The Java Series)</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 13.12.07</div></div><div class="amazlet-detail">Joshua Bloch <br />ピアソンエデュケーション <br />売り上げランキング: 88,031<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/489471499X/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>
