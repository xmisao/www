---
layout: blog
title: JavaのPECS、extendsとsuperの勘所
tag: java
---

# JavaのPECS、extendsとsuperの勘所

PECS(Producer extends and Consumer super)とは、Javaのジェネリックスプログラミングにおいて、ジェネリッククラスのメソッドに柔軟性を持たせるための原則である。基本は以下の通り。

- メソッドが値を取得するコレクション(Producer)は型にextendsをつける
- メソッドで値を設定するコレクション(Consumer)は型にsuperをつける

説明のためスタックの実装を考える。`Stack`はジェネリッククラスであり、任意のクラスのオブジェクトのスタックを表現する。`Stack`のソースコードを以下に示すが、実装は重要でないので、シグネチャに注目して欲しい。

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

この`Stack`を拡張して、以下2つのメソッドを追加することを考える。

- `pushAll`メソッド -- `Iterable`を受け取り、スタックにコレクションの全要素を入力するメソッド
- `popAll`メソッド -- `Collection`を受け取り、スタックの全要素をポップしてコレクションに出力するメソッド

この時、もし`Stack<Number>`であれば、`pushAll`メソッドは`Iterable<Number>`だけでなく、`Number`のサブクラスのコレクション、すなわち`Iterable<Double>`や`Iterable<Integer>`も受け取れればAPIの柔軟性が増す。

つまりこのメソッドは、型パラメータ`T`に対して、`T`か`T`のサブクラスの`Iterable`を受け取らねばならない。これを指定するのが`? extends T`というワイルドカード型だ。これが*"Producer extends"*の原則であり、この原則に従って実装したメソッドを以下に示す。

~~~~
	public void pushAll(Iterable<? extends T> src){
		for(T elm : src){
			push(elm);
		}
	}
~~~~

一方、`Stack<Number>`の時、`popAll`メソッドは、`Collection<Number>`だけでなく、`Collection<Object>`を受け取り、値を詰め込むことができれば、APIはより柔軟になる。

つまりこのメソッドは、型パラメータ`T`に対して、`T`か`T`のスーパークラスの`Collection`を受け取り、値を詰め込めることが望ましい。これを指定するのが`? super T`というワイルドカード型だ。これが*"Consumer super"*の原則であり、この原則に従って実装したメソッドを以下に示す。

~~~~
	public void popAll(Collection<? super T> dst){
		while(!isEmpty()){
			dst.add(pop());
		}
	}
~~~~
