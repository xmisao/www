---
layout: blog
title: GoFのデザインパターンをJavaで実装して理解する Composite編
tag: ['GoF', 'java']
---



<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4797311126/xmisao-22/ref=nosim/" name="amazletlink" target="_blank"><img src="http://ecx.images-amazon.com/images/I/418CWTjHAFL._SL160_.jpg" alt="オブジェクト指向における再利用のためのデザインパターン" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4797311126/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">オブジェクト指向における再利用のためのデザインパターン</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 13.12.11</div></div><div class="amazlet-detail">エリック ガンマ ラルフ ジョンソン リチャード ヘルム ジョン ブリシディース <br />ソフトバンククリエイティブ <br />売り上げランキング: 61,798<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4797311126/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>


オブジェクト指向における再利用のためのデザインパターンより、GoFのデザインパターンをJavaで実装してみる。
4回目の今回はガイダンスの"もっとも良く使われているパターン"からCompositeパターンを実装する。

Compositeパターンの主なメリットは以下のとおり。

- コンポーネントの種類に関する場合分けを取り除ける(透過性を高められる)
- 新しい種類のコンポーネントを簡単に追加できる
- 木構造の範囲内で複雑なオブジェクトを構成できる

Compositeパターンのクラス図は以下のとおり。

![Composite]({{ site.url }}/assets/2014_02_10_gof_composite.png)

`Component`は木構造の要素を表すクラスである。コンポーネントに共通の操作はすべてこのクラスに定義する。表現したいコンポーネントの種類だけ、`Component`のサブクラスを作る。一例として、`Leaf`は木構造の中で葉を表すサブクラスである。`Composite`は複数の`Component`を束ねるサブクラスであり、このパターンの本質的なクラスである。`Composite`は子オブジェクトとして`Component`の集合を保持し、`operation`が呼ばれたら、全ての子オブジェクトに対して`operation`を再帰的に実行する。

`Client`は`Leaf`と`Composite`を組み合わせて木構造を構成する。また`Client`は、`Component`のインタフェースを通じて、木構造中の任意の要素について、`operation`を呼び出すことができる。この際に、`Client`は、`operation`を呼び出した`Component`が、`Leaf`であるのか`Composite`なのか意識する必要はない。

子オブジェクトを管理するオペレーション(`add`, `remove`, `getChild`)を`Component`で宣言するか`Composite`で宣言するかはCompositeパターンを使う上で悩ましい点である。これはGoF本でも重要な問題とされている。

ただし、GoF本には以下の記載があり、デザインパターンの目的としては`Component`を透過的に扱える事を重視しているように読める。よって、本エントリでは子オブジェクトを管理するオペレーションを`Component`に実装することにした。

> このパターンでは安全性より透過性を強調してきた。安全性を重視する場合には、型情報を失うかもしれないが、componentをcompositeに変換しなければならないだろう。
> (中略)
> もちろん、ここでの問題は、すべてのcomponentを一様に扱えないことである。つまり、特定のアクションを実行する前に、オブジェクトの型をテストするという状況に後戻りしなければならない。

`Component`に子オブジェクトを管理するオペレーションを実装した都合上、`Leaf`のクラスにデフォルト実装を提供したくなったため、以下のサンプルコードでは`Component`を抽象クラスとして、`Leaf`と`Composite`は必要なメソッドをオーバーライドするようにした。よりJava風にするのなら`Component`をインタフェースとして、デフォルト実装は`AbstractLeaf`のような中間クラスを設けて提供する方法も考えられる。

Compositeパターンに関連するパターンは多い。木構造の要素を順にアクセスするにはIteratorパターンが利用できる。また要素を共有して資源を節約するFlyweightパターンが利用できる。さらに、もし要素に親オブジェクトへの参照を持たせれば、Chain of Responsibilityパターンを併用することになる。

- Client.java

~~~~
package com.xmisao.gof.composite;

public class Client {
	public static void main(String[] args) {
		// building tree
		//
		//           root
		//           /  \
		//         leaf composite
		//                 /  \
		//              leaf  composite
		//
		Component root = new Composite();
		root.add(new Leaf());
		root.add(new Composite());
		root.getChild(1).add(new Leaf());
		root.getChild(1).add(new Composite());
		root.operation();
	}
}
~~~~

- Component.java

~~~~
package com.xmisao.gof.composite;

public abstract class Component {
	abstract public void operation();
	
	public void add(Component component){
		throw new UnsupportedOperationException();
	}
	
	public void remove(Component component){
		throw new UnsupportedOperationException();	
	}
	
	public Component getChild(int i){
		return null;
	}
}
~~~~

- Leaf.java

~~~~
package com.xmisao.gof.composite;

public class Leaf extends Component{
	@Override
	public void operation() {
		System.out.println("This is Leaf.");
	}
}
~~~~

- Composite.java

~~~~
package com.xmisao.gof.composite;

import java.util.ArrayList;
import java.util.List;

public class Composite extends Component{
	private List<Component> components = new ArrayList<Component>();
	
	@Override
	public void operation() {
		System.out.println("This is Composite.");
		for(Component component : components){
			component.operation();
		}
	}
	
	@Override
	public void add(Component component){
		components.add(component);
	}
	
	@Override
	public void remove(Component component){
		components.remove(component);
	}
	
	@Override	
	public Component getChild(int i){
		return components.get(i);
	}
}
~~~~

- 実行結果

~~~~
This is Composite.
This is Leaf.
This is Composite.
This is Leaf.
This is Composite.
~~~~
