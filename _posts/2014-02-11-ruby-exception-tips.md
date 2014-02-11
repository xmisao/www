---
layout: blog
title: Rubyの例外処理の挙動と例外の階層について
tag: ruby
---

# Rubyの例外処理の挙動と例外の階層について

はじめて使うと間違いがちなRubyの例外処理について基本と注意点をまとめた。

## 例外処理の文法

Rubyで例外処理を行うのは`begin`-`rescue`-`else`-`ensure`-`end`構文である。JavaやC++でいう`try`-`catch`と使い方は概ね同じである。以下にリファレンスマニュアから引用して文法を示す。

~~~~
begin
  式..
[rescue [error_type,..] [=> evar] [then]
  式..]..
[else
  式..]
[ensure
  式..]
end
~~~~

`begin`節の処理で例外が発生した場合は`rescue`節が評価され、例外が発生しなかった場合は`else`節が評価される。例外の発生有無に関わらず、`ensure`節は`begin`節の実行後に必ず評価される。

## 例外処理の注意点

`rescue`節は`error_type`を指定することで、発生する例外と対応させて複数記述することができる。`error_type`を省略した時は、`Exception`ではなく`StandardError`を指定したのと同じになることに注意しよう。以下の2つは同一である。

~~~~
begin
  # do something
rescue 
  # recover
end
~~~~

~~~~
begin
  # do something
rescue StandardError
  # recover
end
~~~~

`error_type`に明示的に`Exception`を指定することもできるが、普通は`Exception`を捕捉するようにしてはいけない。この説明は例外の階層で後述する。

## よりエレガントな例外処理

例外処理を簡潔に記述するために`rescue`修飾子がある。この修飾子は以下の文法で、`式1`で例外が発生したときに、`式2`を評価する。

~~~~
式1 rescue 式2
~~~~

`rescue`修飾子は以下のような`begin`-`rescue`-`end`と同等であり、省略形と言える。

~~~~
begin
  式1
rescue
  式2
end
~~~~

もう1点、リファレンスマニュアルには以下の記載がある。さらっと書いてあるが重要なことだ。
メソッド定義の中では`begin`-`end`を省略することができるというのだ。

> クラス／メソッドの定義/クラス定義、クラス／メソッドの定義/モジュール定義、クラス／メソッドの定義/メソッド定義 などの定義文では、それぞれ begin なしで rescue, ensure 節を定義でき、これにより例外を処理することが できます。

つまり以下のような例外処理は、

~~~~
def foo
  begin
    # do someting
  rescue
    # recover
  end
end
~~~~

冗長な`begin`-`end`を省略して、次のように書けるというわけだ。

~~~~
def foo
  # do someting
  rescue
    # recover
end
~~~~

## 例外の階層

以下にRuby 1.9.3の組み込み例外クラスの一覧を示す。(抽出したのはExceptionの子クラスと孫クラスまで)

- Exception
  - fatal
  - NoMemoryError
  - ScriptError
    - NotImplementedError
    - LoadError
    - SyntaxError
  - SecurityError
  - SignalException
    - Interrupt
  - StandardError
    - ArgumentError
    - EncodingError
    - FiberError
    - IOError
    - IndexError
    - LocalJumpError
    - Math::DomainError
    - NameError
    - RangeError
    - RegexpError
    - RuntimeError
    - SystemCallError
    - ThreadError
    - TypeError
    - ZeroDivisionError
  - SystemExit
  - SystemStackError

一般的な例外はすべて`StandardError`のサブクラスとなっていることがわかる。

また`StandardError`以外の`Exception`のサブクラスには、メモリ不足で発生する`NoMemoryError`や、シグナルを受信した際に発生する`SignalException`(`Interrupt`)など、即座にスクリプトを中止すべき例外が並んでいることもわかる。

この例外の階層こそ、注意点で述べたようにRubyが`rescue`で捕捉するデフォルトの例外が`StandardError`であり、安易に`Exception`を捕捉してはならない理由である。`StandardErro`以外の例外が発生したら、即座に処理を終了すべきなのである。

## 参考

- [制御構造 例外処理](http://docs.ruby-lang.org/ja/1.9.3/doc/spec=2fcontrol.html#BEGIN)
