---
layout: blog
title: JavaジェネリックスのPECS原則、extendsとsuperの勘所
tag: java
---



# はじめに

PECS(Producer extends and Consumer super)とは、Javaのジェネリックスプログラミングにおいて、ジェネリッククラスのメソッドに柔軟性を持たせるための原則である。基本は以下の通り。

- メソッドが値を取得するコレクション(Producer)は型にextendsをつける
- メソッドで値を設定するコレクション(Consumer)は型にsuperをつける

# 例

説明のためスタックの実装を考える。`Stack`はジェネリッククラスであり、任意のクラスのオブジェクトのスタックを表現する。`Stack`のソースコードを以下に示すが、実装は重要でないので、シグネチャに注目して欲しい。

~~~~
public class Stack<T> {
	private List<T> stack = new ArrayList<T>();
	
	public void push(T elm){
		stack.add(elm);
	}
	
	public T pop(){
		return stack.remove(stack.size() - 1);
	}
	
	public boolean isEmpty(){
		return stack.size() > 0 ? false : true;
	}
}
~~~~

この`Stack`を拡張して、以下2つのメソッドを追加することにする。

- `pushAll`メソッド -- `Iterable`を受け取り、コレクションの全要素をスタックにプッシュするメソッド
- `popAll`メソッド -- `Collection`を受け取り、スタックの全要素をポップしてコレクションに出力するメソッド

# Producer extends

この時、もし`Stack<Number>`であれば、`pushAll`メソッドは`Iterable<Number>`だけでなく、`Number`のサブクラスのコレクション、すなわち`Iterable<Double>`や`Iterable<Integer>`も受け取れればAPIの柔軟性が増す。

つまりこのメソッドは、型パラメータ`T`に対して、`T`か`T`のサブクラスの`Iterable`を受け取らねばならない。これを指定するのが`? extends T`というワイルドカード型だ。これが*"Producer extends"*の原則であり、この原則に従って実装したメソッドを以下に示す。

~~~~
	public void pushAll(Iterable<? extends T> src){
		for(T elm : src){
			push(elm);
		}
	}
~~~~

# Consumer super

一方、`Stack<Number>`の時、`popAll`メソッドは、`Collection<Number>`だけでなく、`Collection<Object>`を受け取り、値を詰め込むことができれば、APIはより柔軟になる。

つまりこのメソッドは、型パラメータ`T`に対して、`T`か`T`のスーパークラスの`Collection`を受け取り、値を詰め込めることが望ましい。これを指定するのが`? super T`というワイルドカード型だ。これが*"Consumer super"*の原則であり、この原則に従って実装したメソッドを以下に示す。

~~~~
	public void popAll(Collection<? super T> dst){
		while(!isEmpty()){
			dst.add(pop());
		}
	}
~~~~

# おわりに

本エントリーは、Effective Java 項目28の内容のうち、PECS原則に焦点を当てて、要点をまとめたものだ。境界ワイルドカード型の使い方については、詳しくは本書を参照。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/489471499X/xmisao-22/ref=nosim/" name="amazletlink" target="_blank"><img src="http://ecx.images-amazon.com/images/I/51E1m-weAXL._SL160_.jpg" alt="Effective Java 第2版 (The Java Series)" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/489471499X/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Effective Java 第2版 (The Java Series)</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 13.12.07</div></div><div class="amazlet-detail">Joshua Bloch <br />ピアソンエデュケーション <br />売り上げランキング: 88,031<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/489471499X/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>
