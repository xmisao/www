---
layout: blog
title: GoFのデザインパターンをJavaで実装して理解する Adapter編
tag: ['GoF', 'java']
---



<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4797311126/xmisao-22/ref=nosim/" name="amazletlink" target="_blank"><img src="http://ecx.images-amazon.com/images/I/418CWTjHAFL._SL160_.jpg" alt="オブジェクト指向における再利用のためのデザインパターン" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4797311126/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">オブジェクト指向における再利用のためのデザインパターン</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 13.12.11</div></div><div class="amazlet-detail">エリック ガンマ ラルフ ジョンソン リチャード ヘルム ジョン ブリシディース <br />ソフトバンククリエイティブ <br />売り上げランキング: 61,798<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4797311126/xmisao-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>

オブジェクト指向における再利用のためのデザインパターンより、GoFのデザインパターンをJavaで実装してみる。
3回目の今回はガイダンスの"もっとも良く使われているパターン"からAdapterパターンを実装する。

Adapterパターンの主なメリットは以下のとおり。

- 既存の実装を変更せずに互換性のないインタフェースに適合させることができる

本パターンは移譲と継承の2パターンの実装が知られている。
クラス図はそれぞれ以下のとおり。

![Adapter]({{ site.url }}/assets/2014_01_09_gof_adapter.png)

これは再利用したい既存の実装Adapteeを、Adapteeとは互換性のないITargetインタフェースに適合させる例である。この際に、AdapteeとITargetの間を取り持つのがAdapterだ。(クラス図の赤のクラス)

Adapterクラスを設けることで、既存の実装Adapteeを変更することなく、新しいインタフェースITargetを通じて、Adapteeの実装を再利用することができる。

Javaではクラスの多重継承が許されないので、前者の移譲による実装を使うことが多いと思われる。以下のサンプルコードは移譲によるAdapterパターンの実装である。

実際にAdapterパターンを活用する際には、Adapterが担う役割がどの程度のものになるのかがポイントだ。
最も簡単なのは単にメソッド名を変換するだけのAdapterだ。
しかし、既存の複数のクラスを協調させて新しいインタフェースに適合させるような複雑なAdapterも考えられる。
結局、Adapterパターンを使っても、既存の実装と適合させたいインタフェースが似ても似つかなければ、実装は複雑なものになってしまう。

- Client.java

~~~~
package com.xmisao.gof.adapter;

public class Client {
	public static void main(String[] args) {
		Adaptee adaptee = new Adaptee();
		ITarget target = new Adapter(adaptee);
		target.request();
	}
}
~~~~

- ITarget.java

~~~~
package com.xmisao.gof.adapter;

public interface ITarget {
	public void request();
}
~~~~

- Adapter.java

~~~~
package com.xmisao.gof.adapter;

public class Adapter implements ITarget{
	Adaptee adaptee;

	public Adapter(Adaptee adaptee){
		this.adaptee = adaptee;
	}
	
	@Override
	public void request() {
		adaptee.specificRequest();		
	}
}
~~~~

- Adaptee.java

~~~~
package com.xmisao.gof.adapter;

public class Adaptee {
	public void specificRequest(){
		System.out.println("specificRequest was called.");
	}
}
~~~~

- 実行結果

~~~~
specificRequest was called.
~~~~
