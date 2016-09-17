---
layout: blog
title: GoFのデザインパターンをJavaで実装して理解する Abstract Factory編
tag: ['GoF', 'java']
---



<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4797311126/xmisao-22/ref=nosim/" name="amazletlink" target="_blank"><img src="https://images-fe.ssl-images-amazon.com/images/I/418CWTjHAFL._SL160_.jpg" alt="オブジェクト指向における再利用のためのデザインパターン" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4797311126/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">オブジェクト指向における再利用のためのデザインパターン</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 13.12.11</div></div><div class="amazlet-detail">エリック ガンマ ラルフ ジョンソン リチャード ヘルム ジョン ブリシディース <br />ソフトバンククリエイティブ <br />売り上げランキング: 61,798<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4797311126/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>

オブジェクト指向における再利用のためのデザインパターンより、GoFのデザインパターンをJavaで愚直に実装してみようと考えた。
手始めにガイダンスで触れられていた"もっとも良く使われているパターン"からAbstract Factoryパターンを実装してみる。

AbstractFactoryパターンの主なメリットは以下の通り。

- 特定の組み合わせが要求されるオブジェクト群を誤りなく生成できる
- 生成されるオブジェクトの実装を隠蔽することができる

クラス図は以下のとおり。

![Abstract Factory](/assets/2013_12_11_gof_abstractfactory.png)

ConcreteFactoryA, Bを使うことで、AbstractProductA, Bの実装は、正しい組み合わせで生成できる。(クラス図の緑と赤の組み合わせ)
ClientはAbstractFactoryと生成されるオブジェクトの抽象クラス(AbstractProductA, B)だけを意識すれば良いのがポイント。
使用するConcleteFactoryを差し替えれば、プログラムの挙動をごっそりと変更することができる。
AbstractFactoryとAbstractProductは書籍に倣って抽象クラスとしたが、もっとJava風に書けばインタフェースになるだろう。

AbstractFactoryの具象クラスで生成のパターンを定義しているのが欠点だが、これはPrototypeパターンを使うと解消できる。
またConcreteFactoryは1度しか生成されない事が多いので、Singletonパターンを適用できるとのことである。

ソースコードと実行結果は以下の通り。

- Client.java

~~~~
package abstractfactory;

import java.util.ArrayList;
import java.util.List;

public class Client {
	public static void main(String[] args) {
		List<AbstractFactory> factories = new ArrayList<AbstractFactory>();
		factories.add(new ConcreteFactory1());
		factories.add(new ConcreteFactory2());
		
		for(AbstractFactory factory : factories){
			AbstractProductA productA = factory.createProductA();
			productA.methodA();
			AbstractProductB productB = factory.createProductB();
			productB.methodB();
		}
	}
}
~~~~

- AbstractFactory.java

~~~~
package abstractfactory;

public abstract class AbstractFactory {
	abstract public AbstractProductA createProductA();
	abstract public AbstractProductB createProductB();
}
~~~~

- ConcreteFactory1.java

~~~~
package abstractfactory;

public class ConcreteFactory1 extends AbstractFactory {
	@Override
	public AbstractProductA createProductA() {
		return new ProductA1();
	}

	@Override
	public AbstractProductB createProductB() {
		return new ProductB1();
	}
}

~~~~

- ConcreteFactory2.java

~~~~
package abstractfactory;

public class ConcreteFactory2 extends AbstractFactory {
	@Override
	public AbstractProductA createProductA() {
		return new ProductA2();
	}

	@Override
	public AbstractProductB createProductB() {
		return new ProductB2();
	}
}
~~~~

- AbstractProductA.java

~~~~
package abstractfactory;

public abstract class AbstractProductA {
	abstract public void methodA();
}
~~~~

- ProductA1.java

~~~~
package abstractfactory;

public class ProductA1 extends AbstractProductA {
	@Override
	public void methodA() {
		System.out.println("ProductA1");
	}
}
~~~~

- ProductA2.java

~~~~
package abstractfactory;

public class ProductA2 extends AbstractProductA {
	public void methodA() {
		System.out.println("ProductA2");
	}
}

~~~~

- AbstractProductB.java

~~~~
package abstractfactory;

public abstract class AbstractProductB {
	abstract public void methodB();
}
~~~~

- ProductB1.java

~~~~
package abstractfactory;

public class ProductB1 extends AbstractProductB {
	@Override
	public void methodB() {
		System.out.println("ProductB1");
	}
}
~~~~

- ProductB2.java

~~~~
package abstractfactory;

public class ProductB2 extends AbstractProductB {
	@Override
	public void methodB() {
		System.out.println("ProductB2");
	}
}
~~~~

- 実行結果

~~~~
ProductA1
ProductB1
ProductA2
ProductB2
~~~~

ところで本書はその筋では名著(古典?)とされているが、文章も例も決してわかりやすいとは思えない。
この難解さは、上級者だから読める、初心者だから読めない、とかそいういうレベルでないと思う。
とはいえせっかく持っているので、しばらくこの本に付き合っていこうと思う。
