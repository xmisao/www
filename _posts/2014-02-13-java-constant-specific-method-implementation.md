---
layout: blog
title: JavaでenumにAbstractメソッドを定義して定数に固有の振る舞いを実装する(定数固有メソッド実装)
tag: java
---

# JavaでenumにAbstractメソッドを定義して定数に固有の振る舞いを実装する(定数固有メソッド実装)

Javaのenumはクラスの一種であり、enumにメソッドを定義することができる。では、そのメソッドをabstractにしたらどうなるだろうか? 実はenumに定義したabstractメソッドは定数でオーバーライドすることになる。これを利用すると定数による場合分けなしで、定数に固有の振る舞いを実装できる。この実装は定数固有メソッド実装(constant-specific method implementation)と呼ばれる。

以下は演算子を表すenumに、その演算子を使った計算を適用する`apply`メソッドを実装した例である。

~~~~
public enum operator {
    PLUS{
        @Override
        double apply(double v0, double v1) {
            return v0 + v1;
        }
    },
    MINUTS{
        @Override
        double apply(double v0, double v1) {
            return v0 - v1;
        }
    },
    TIMES{
        @Override
        double apply(double v0, double v1) {
            return v0 * v1;
        }
    },
    DIVIDE{
        @Override
        double apply(double v0, double v1) {
            return v0 / v1;
        }
    };
    
    abstract double apply(double v0, double v1);
}
~~~~

このenumは以下のように利用できる。

~~~~
operator.PLUS.apply(1, 2); //=> 3.0
operator.MINUS.apply(1, 2); //=> -1.0
operator.TIMES.apply(1, 2); //=> 2.0
operator.DIVIDE.apply(1, 2); //=> 0.5
~~~~
