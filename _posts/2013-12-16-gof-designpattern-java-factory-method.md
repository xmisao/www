---
layout: blog
title: GoFのデザインパターンをJavaで実装して理解する Factory Method編
tag: ['GoF', 'java']
---

# GoFのデザインパターンをJavaで実装して理解する Factory Method編

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4797311126/xmisao-22/ref=nosim/" name="amazletlink" target="_blank"><img src="http://ecx.images-amazon.com/images/I/418CWTjHAFL._SL160_.jpg" alt="オブジェクト指向における再利用のためのデザインパターン" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4797311126/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">オブジェクト指向における再利用のためのデザインパターン</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 13.12.11</div></div><div class="amazlet-detail">エリック ガンマ ラルフ ジョンソン リチャード ヘルム ジョン ブリシディース <br />ソフトバンククリエイティブ <br />売り上げランキング: 61,798<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4797311126/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>

オブジェクト指向における再利用のためのデザインパターンより、GoFのデザインパターンをJavaで実装してみる。
2回目の今回はガイダンスの"もっとも良く使われているパターン"からFactory Methodパターンを実装する。

Factory Methodパターンの主なメリットは以下のとおり。

- 機能を移譲するオブジェクトの生成をサブクラスの実装に委ねることができる
- Template Methodパターンと併用して実装の重複を避けることができる

クラス図は以下のとおり。

![Factory Method]({{ site.url }}/assets/2013_12_16_gof_factorymethod.png)

Creatorにオブジェクトを生成するアブストラクトメソッドを定義しておき、サブクラスにProductの具象クラスを生成する実装をする。(クラス図の赤のクラス)

こうしておく事で、Creatorを使用するClientは、Productの具象クラスの生成を意識する必要がなくなる。
またCreatorにanOperation()のようなTemplate Methodを持たせておくことで、Productを使用するコードを、Creatorのサブクラスで再利用することができる。

Abstract FactoryパターンとFactory Methodパターンの違いは、いまいちわかりにくい。Wikipediaの日本語版の解説によると、オブジェクトとオブジェクトの関係に着目するか、クラスとサブクラスの関係に着目するかの違いのようである。なお、この説明に相当する記載は英語版のWikipediaには存在しないため、出典は不明である。

- [Factory Method パターン - Wikipedia](http://ja.wikipedia.org/wiki/Factory_Method_%E3%83%91%E3%82%BF%E3%83%BC%E3%83%B3)

>Abstract Factory パターンとの違い
>
>『オブジェクト指向における再利用のためのデザインパターン』においてはFactory Method パターンは「クラスパターン」に分類されている。一方Abstract Factory パターンは「オブジェクトパターン」に分類されている。
>
>Factory Method パターンは親クラスであるCreatorクラスが子クラスであるConcreteCreatorクラスにオブジェクトの生成を委ねるという、CreatorクラスとConcreteCreatorクラスとの関連である。一方でAbstract Factory パターンは、ClientのインスタンスがConcreteFactoryのインスタンスにオブジェクトの生成を委ねるという、オブジェクト同士の関連である。

ソースコードと実行結果は以下の通り。

- Client.java

~~~~
package com.xmisao.gof.factorymethod;

public class Client {
	public static void main(String[] args) {
		Creator creator = new ConcreteCreator();
		creator.anOperation();
	}
}
~~~~

- Creator.java

~~~~
public abstract class Creator {
	abstract Product factoryMethod();
	
	public void anOperation(){
		Product product = factoryMethod();
	}
}
~~~~

- ConcreteCreator.java

~~~~
package com.xmisao.gof.factorymethod;

public class ConcreteCreator extends Creator{
	@Override
	public Product factoryMethod() {
		return new ConcreteProduct();
	}
}
~~~~

- Product.java

~~~~
package com.xmisao.gof.factorymethod;

public class Product {

}
~~~~

- ConcreteProduct.java

~~~~
package com.xmisao.gof.factorymethod;

public class ConcreteProduct extends Product{
	ConcreteProduct(){
		System.out.println("ConcreteProduct was constructed.");
	}
}
~~~~

- 実行結果

~~~~
ConcreteProduct was constructed.
~~~~

このシリーズのサンプルは、すべてGitHubでEclipseのプロジェクトごと公開することにした。今後もエントリーの追加と併せて、随時更新していく予定である。

- [xmisao/GoF](https://github.com/xmisao/GoF)
