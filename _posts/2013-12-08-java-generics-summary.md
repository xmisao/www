---
layout: blog
title: Javaのジェネリック(総称型)の使い方まとめ
tag: java
---

# Javaのジェネリック(総称型)の使い方まとめ

Java 1.5からはクラスに型パラメータを渡せるようになった。
型パラメータを持つクラスやインタフェースがジェネリッククラスやジェネリックインタフェースである。
標準ライブラリで代表的なものはコレクションクラスで、`List<T>`や`Map<K, V>`が該当する。

ジェネリックとは、ようはクラスやインタフェースが扱う型をプログラマが指定できるクラスやインタフェースのことだ。
ジェネリックのメリットは、コードに型を自在に差し替える柔軟性を持たせつつ、コンパイル時に型の不整合を検出できるためコードが型安全になり、実行時にCastExceptionが発生しなくなることだ。

## ジェネリッククラスの使い方

型パラメータを持つクラスは以下のように定義できる。
型パラメータの名前は何でも良いが、慣例で大文字1文字の名前をつける事が多い。
クラス中では型パラメータを使って変数やメソッドを定義することができる。

~~~~
// ジェネリッククラスの例
class GenericClass<T>{
	// 型Tのオブジェクトを受け取り型Tの結果を返すメソッドの例
	public T method(T obj){
		T result = new T();
		return result;
	}
}
~~~~

イメージとしてはクラス中の型パラメータは実行時に指定されたクラスで読み替えて処理される。
例えば以下のように初期化したジェネリッククラスは、以下のコードと同じように動作する。

~~~~
	GenericClass<Object> gc = new GenericClass<Object>;
~~~~

~~~~
class GenericClass{
	public Object method(Object obj){
		Object result = new Object();
		return result;
	}
}
~~~~

型パラメータを複雑にしているのは、extends指定とワイルドカードだろう。
以下ではextends指定とワイルドカードを例示して説明する。

## extends指定

型パラメータのextends指定は型パラメータが特定の型であることを要求する。
その効用としてジェネリッククラスの中では要求したクラスの機能を自由に使うことができる。
ClazzとそのサブクラスSubClazzが定義されているとして、これらのクラスを受け付けるGenericClassを定義してみよう。

~~~~
class Clazz{
	public void function(){
		// 処理
	}
}

class SubClazz extends Clazz{
	// SubClazzの実装
}

class GenericClass<T extends Clazz>{
	// 型Tのオブジェクトを受け取り型Tの結果を返すメソッドの例
	public T method(T obj){
		T result = new T();
		result.clazz_function(); // Clazzの機能の呼び出し
		return result;
	}
}
~~~~

このGenericClassを使う場合は、TはClazzかそのサブクラスでなければならない。

~~~~
GenericClass<Object> gc1 = new GenericClass<Clazz>; // Clazzが型パラメータ
GenericClass<Object> gc2 = new GenericClass<SubClazz>; // SubClazzが型パラメータ
~~~~

以下のようにClazzと継承関係にない型パラメータを渡すとコンパイルエラーとなる。

~~~~
GenericClass<Object> gc = new GenericClass<Object>; // コンパイルエラー!
~~~~

## ワイルドカード

プログラムでジェネリッククラスの性質のみに関心があり、ジェネリッククラスの型パラメータにまでは関心がない場合がある。このような型指定にはワイルドカード`?`が利用できる。
例えば何らかのGenericClassを引数に取るメソッドは以下のように定義できる。

~~~~
public static void wildcardMethod(GenericClass<?> gc){
	// 処理
}
~~~~

なお型パラメータの継承関係はジェネリッククラスの型には関係がない。
GenericClass<Clazz>とGenericClass<SubClazz>は別の型である事は注意が必要だ。
以下のコードはコンパイルエラーとなる。

~~~~
GenericClass<Clazz> gc = new GenericClass<SubClazz>();
~~~~

ClazzとSubClazzを型パラメータに受け取ったジェネリッククラスを受け入れられる変数の型は、ワイルドカードを使ったGenericClass<?>だけである。

~~~~
GenericClass<?> gc1 = new GenericClass<Clazz>();
GenericClass<?> gc2 = new GenericClass<SubClazz>();
~~~~
