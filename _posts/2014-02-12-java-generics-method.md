---
layout: blog
title: Javaでジェネリックメソッドを利用する
tag: java
---



Javaでは、クラスだけでなく、メソッドでもジェネリックを利用することができる。例えば任意の型の`HashSet`を返すメソッドは以下のように定義できる。ジェネリックメソッドを定義する場合、ジェネリックメソッドの型パラメータは、メソッド修飾子とメソッドの型の間に入ることに注意しよう。

~~~~
public static <E> Set<E> newHashSet(){
    return new HashSet<E>();
}
~~~~

ジェネリックメソッドで強力なのは、型推論が利用できることだ。このメソッドは呼び出し時に明示的に型を指定する必要はない。Javaが変数の型からコンパイル時に型を推論してくれるからだ。よって、`String`型の`Set`を得たいなら以下のように書くだけで良い。

~~~~
Set<String> set = newHashSet();
~~~~

このようなメソッドは、ジェネリックを利用してオブジェクトを生成することから、ジェネリックstaticファクトリーメソッドと呼ばれることもあるようだ。

もしジェネリックstaticファクトリーメソッドを使用せずに、`String`型の`Set`を得たいなら、以下のように型パラメータを明示したコンストラクタを使わなければならない。これは冗長な記述だとして、しばしばJavaの批判の対象になる。

~~~~
Set<String> set = new HashSet<String>();
~~~~

これと比べると、ジェネリックstaticファクトリーメソッドを使う方法は、右辺から型を消しされるので、幾らか簡潔に記述できることがわかる。

型推論が使えるのは、返り値の型にとどまらない。引数の型でも型推論が働く。例えば2つの`Set`の和集合を求めるメソッド`union`は以下のように定義して、呼び出すことができる。型推論によって`Set<E>`が`Set<String>`であることが推論されている。

~~~~
public static <E> Set<E> union(Set<E> s1, Set<E> s2){
    Set<E> result = new HashSet<E>(s1);
    result.addAll(s2);
    return result;
}
~~~~

~~~~
Set<String> s1 = newHashSet();
s1.add("hoge");
Set<String> s2 = newHashSet();
s2.add("piyo");
Set<String> result = union(s1, s2);
System.out.println(result); #=> ["hoge", "piyo"]
~~~~

以上のように、Javaのジェネリックメソッドを使えば、高い抽象度で処理を記述できるとともに、型推論によってコードの記述量を削減することができる。Javaのジェネリックメソッドについては、Effective Javaの項目27が詳しい。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/489471499X/xmisao-22/ref=nosim/" name="amazletlink" target="_blank"><img src="https://images-fe.ssl-images-amazon.com/images/I/51E1m-weAXL._SL160_.jpg" alt="Effective Java 第2版 (The Java Series)" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/489471499X/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Effective Java 第2版 (The Java Series)</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 13.12.07</div></div><div class="amazlet-detail">Joshua Bloch <br />ピアソンエデュケーション <br />売り上げランキング: 88,031<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/489471499X/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>
