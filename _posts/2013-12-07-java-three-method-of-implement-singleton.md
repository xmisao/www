---
layout: blog
title: Javaでシングルトンを実装する3つの方法
tag: java
---

# Javaでシングルトンを実装する3つの方法

Javaでシングルトンを実装するには以下3つの方法がある。
それぞれ詳しく見てみよう。

1. publicなstaticフィールドにインスタンスを保持する
2. publicなstaticメソッドでインスタンスを返す
3. 単一要素のenumを使う

## 1. publicなstaticフィールドにインスタンスを保持する

~~~~
public class Singleton1 {
	public static final Singleton1 INSTANCE = new Singleton1();
	private Singleton1(){
		// Initialize instance
	}
}
~~~~

`public`な`static`フィールドを定義し、インスタンスをこのフィールドに保持しておく方法だ。
同時にコンストラクタを`private`として、外部からのインスタンス生成を防止する。

## 2. publicなstaticメソッドでインスタンスを返す

~~~~
public class Singleton2 {
	private static final Singleton2 INSTANCE = new Singleton2();
	private Singleton2(){
		// Initialize instance
	}
	public static Singleton2 getInstance(){
		return INSTANCE;
	}
}
~~~~

`private`な`static`フィールドを定義し、インスタンスをこのフィールドに保持する。
このインスタンスを返す`public`で`static`メソッドを定義して、シングルトンを返却する方法だ。
コンストラクタを`private`として、外部からのインスタンス生成を防止するのは'方法 1.'と変わらない。

生成をメソッド化したことにより、スレッド毎に固有のシングルトンを返却するなど、生成にバリエーションを持たせられることが利点である。

## 3. 単一要素のenumを使う

~~~~
public enum Singleton3 {
	INSTANCE;
}
~~~~

この方法はJava 1.5以降で利用できる。
単一要素の`enum`を定義し、これをシングルトンとして利用する方法だ。
`enum`の要素は複数作られることがないため、`INSTANCE`はこれだけでシングルトンとなる。

この方法が'方法 1.'と'方法 2.'より優れているのは、リフレクションにより無理やりコンストラクタを呼び出したり、シリアライズ・デシリアライズによりインスタンスが複製されたりすることがない点だ。

## シングルトンの参照

上記'方法 1.'から'方法 3.'で実装したシングルトンを参照する方法はそれぞれ以下のとおり。

~~~~
public class Main {
	public static void main(String[] args) {
		Singleton1 s1 = Singleton1.INSTANCE;
		Singleton2 s2 = Singleton2.getInstance();
		Singleton3 s3 = Singleton3.INSTANCE;
	}
}
~~~~

Javaでシングルトンを実装する詳細は、Effective Javaの項目3に詳しい。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/489471499X/xmisao-22/ref=nosim/" name="amazletlink" target="_blank"><img src="http://ecx.images-amazon.com/images/I/51E1m-weAXL._SL160_.jpg" alt="Effective Java 第2版 (The Java Series)" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/489471499X/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Effective Java 第2版 (The Java Series)</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 13.12.07</div></div><div class="amazlet-detail">Joshua Bloch <br />ピアソンエデュケーション <br />売り上げランキング: 88,031<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/489471499X/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>
