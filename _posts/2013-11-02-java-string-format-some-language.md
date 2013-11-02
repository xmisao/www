---
layout: default
title: JavaのString.formatの結果はロケールに依存する
tag: java
---

# JavaのString.formatの結果はロケールに依存する

驚くべきことに、この世には小数点を,(カンマ)で表記する言語がある、ドイツ語などがそうだ。

それだけなら良いのだが、Javaの`String.format()`は、ロケールを考慮した整形を行う。そのため、例えばドイツ語環境で数値を整形すると、小数点は,になってしまう。

~~~~
import java.util.Locale;

public class Main {
	public static void main(String[] args) {
		Locale.setDefault(Locale.JAPAN);
		System.out.println(String.format("%f", 4.2));	// 4.200000	
		Locale.setDefault(Locale.GERMAN);
		System.out.println(String.format("%f", 4.2)); // 4,200000
	}
}
~~~~

国際化対応したプログラムを書く場合には注意しておきたい。

ちなみに`Double#toString()`による数値 -> 文字の変換や、`Double.parseDouble()`による文字 -> 数値の変換は、ロケールの影響を受けない。

処理中で文字列化、再数値化を行うプログラムでは特に注意が必要だ。混ぜるな危険である。
