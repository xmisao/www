---
layout: blog
title: Javaのジェネリック(総称型)の使い方まとめ
tag: java
---



Java 1.5からはクラスに型パラメータを渡せるようになった。
型パラメータを持つクラスやインタフェースがジェネリッククラスやジェネリックインタフェースである。
標準ライブラリで代表的なものはコレクションクラスで、`List<T>`や`Map<K, V>`が該当する。

ジェネリックとは、ようはクラスやインタフェースが扱う型をプログラマが指定できるクラスやインタフェースのことだ。
ジェネリックのメリットは、コードに型を自在に差し替える柔軟性を持たせられること。さらにコンパイル時に型の不整合を検出できるためコードが型安全になり、実行時に`CastException`が発生しなくなることだ。

# ジェネリッククラスの使い方

型パラメータを持つクラスは以下のように定義できる。
型パラメータの名前は何でも良いが、慣例で大文字1文字の名前をつける事が多い。
クラス中では型パラメータの型を使って変数やメソッドを定義することができる。

~~~~
// ジェネリッククラスの例
class GenericClass<T>{
	// 型Tのオブジェクトを受け取り
	// そのまま結果を返すメソッドの例
	public T method(T obj){
		return obj;
	}
}
~~~~

イメージとしてはクラス中の型パラメータは実行時に指定されたクラスで読み替えて処理される。
例えば`Object`クラスで初期化したジェネリッククラスは、以下のコードと同じように動作する。

~~~~
GenericClass<Object> gc = new GenericClass<Object>;
~~~~

~~~~
// TをObjectで読み替えたジェネリッククラスのイメージ
class GenericClass{
	public Object method(Object obj){
		return obj;
	}
}
~~~~

型パラメータを複雑にしているのは、*extends指定*と*ワイルドカード*だろう。
以下ではextends指定とワイルドカードを例示して説明する。

# extends指定

型パラメータのextends指定は型パラメータが特定の型であることを要求する。
その効用としてジェネリッククラスの中では要求したクラスの機能を自由に使うことができる。
`Clazz`とそのサブクラス`SubClazz`が定義されているとして、これらのクラスを受け付ける`GenericClass`を定義してみよう。

~~~~
public class Clazz{
	public void function(){
		// 処理
	}
}

public class SubClazz extends Clazz{
	// SubClazzの実装
}

public class GenericClass<T extends Clazz>{
	public void method(T obj){
		// Clazzのメソッドの呼び出し
		obj.function();
	}
}
~~~~

この`GenericClass`を使う場合は、`T`は`Clazz`かそのサブクラスでなければならない。

~~~~
GenericClass<Object> gc1 = new GenericClass<Clazz>; // Clazzが型パラメータ
GenericClass<Object> gc2 = new GenericClass<SubClazz>; // SubClazzが型パラメータ
~~~~

以下のように`Clazz`と継承関係にない型パラメータを渡すとコンパイルエラーとなる。

~~~~
// コンパイルエラー!
GenericClass<Object> gc = new GenericClass<Object>; 
~~~~

# ワイルドカード

プログラムでジェネリッククラスの性質のみに関心があり、ジェネリッククラスの型パラメータにまでは関心がない場合がある。
このような型指定にはワイルドカード`?`が利用できる。
例えば何らかの`GenericClass`を引数に取るメソッドは、以下のように定義できる。

~~~~
public static void wildcardMethod(GenericClass<?> gc){
	// 何らかのGenericClassに対する処理
}
~~~~

なお型パラメータの継承関係はジェネリッククラスの型には何ら影響を与えない。
`GenericClass<Clazz>`と`GenericClass<SubClazz>`は別の型である事は注意が必要だ。
よって以下のコードはコンパイルエラーとなる。

~~~~
// コンパイルエラー!
GenericClass<Clazz> gc = new GenericClass<SubClazz>();
~~~~

`Clazz`と`SubClazz`を型パラメータに受け取ったジェネリッククラスを受け入れられる変数の型は、ワイルドカードを使った`GenericClass<?>`だけである。

~~~~
GenericClass<?> gc1 = new GenericClass<Clazz>();
GenericClass<?> gc2 = new GenericClass<SubClazz>();
~~~~

Javaのジェネリックについては、Effective Javaの第5章が詳しい。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/489471499X/xmisao-22/ref=nosim/" name="amazletlink" target="_blank"><img src="https://images-fe.ssl-images-amazon.com/images/I/51E1m-weAXL._SL160_.jpg" alt="Effective Java 第2版 (The Java Series)" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/489471499X/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Effective Java 第2版 (The Java Series)</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 13.12.07</div></div><div class="amazlet-detail">Joshua Bloch <br />ピアソンエデュケーション <br />売り上げランキング: 88,031<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/489471499X/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>
