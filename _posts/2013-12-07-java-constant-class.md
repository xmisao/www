---
layout: blog
title: Javaで定数を定義するには定数クラスを使おう
tag: java
---



Javaで定数をまとめて定義するには、インタフェースとクラスを使う方法が考えられる。以下ではこれらをそれぞれ定数インタフェース、定数クラスと呼ぶことにする。このうち定数インタフェースは、以下の点で問題があるため、避けたほうが良い。

- クラスが定数インタフェースを実装している事が不必要に外部に漏洩してしまう
- 定数インタフェースが不要になった場合の変更に弱い
- 定数インタフェースを実装したサブクラスの名前空間がすべて汚染されてしまう

このためJavaで定数をまとめて定義するには以下のような定数クラスを用いた方が良い。

~~~~
package constants; // この例ではconstantsパッケージ

public class MathConstants {
	// privateコンストラクタでインスタンス生成を抑止
	private MathConstants(){} 
	
	// 定数
	public static final double PI = 3.14;
	public static final double NAPIER = 2.71;
	public static final double PYTHAGORAS = 1.41;
}
~~~~

通常、この定数を参照するには、以下のように`クラス名.定数名`で参照しなければならない。

~~~~
import constants.MathConstants;
public class Main {
	public static void main(String[] args) {
		double area2 = 3 * 3 * MathConstants.PI;
	}
}
~~~~

定数を頻繁に参照する必要があり、この表記が煩雑な場合はstaticインポート機能を使うことで、冗長な表記を避けることができる。

~~~~
import static constants.MathConstants.*;
public class Main {
	public static void main(String[] args) {
		double area2 = 3 * 3 * PI;
	}
}
~~~~

これなら定数インタフェースを使うメリットがないことがわかるだろう。

Javaで定数を定義する際にインタフェースとクラスどちらを使うべきかという議論は、Effective Javaの項目19に詳しい。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/489471499X/xmisao-22/ref=nosim/" name="amazletlink" target="_blank"><img src="http://ecx.images-amazon.com/images/I/51E1m-weAXL._SL160_.jpg" alt="Effective Java 第2版 (The Java Series)" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/489471499X/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Effective Java 第2版 (The Java Series)</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 13.12.07</div></div><div class="amazlet-detail">Joshua Bloch <br />ピアソンエデュケーション <br />売り上げランキング: 88,031<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/489471499X/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>
