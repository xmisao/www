---
layout: blog
title: Rubyで構造体を定義する
tag: ruby
---

# Rubyで構造体を定義する

Rubyに構造体という概念は存在しない。しかし`Struct`クラスが用意されており、構造体ライクなクラスを簡潔に記述できるようになっている。Rubyにおける構造体は、メンバに値を設定するコンストラクタと、メンバへのアクセサメソッドが定義されただけのクラスである。

構造体を定義するには`Struct.new`を呼ぶ。このコンストラクタは少しばかり異色で、`Struct`のサブクラスを新たに作って返す。例えば年齢と性別をメンバとして持つ`Dog`構造体は以下のように定義できる。

~~~~
Dog = Struct.new(:age, :sex)
~~~~

`Dog`構造体にはメンバに値を設定するコンストラクタが定義される。以下のように呼び出すことで、生成と同時にメンバに値を設定できる。

~~~~
Dog = Struct.new(:age, :sex)
dog = Dog.new(10, :male)
p dog # => <struct Dog age=10, sex=:male>
~~~~

メンバへのアクセスは、メソッド呼び出しの形式でも、ハッシュ風の方法でも、どちらも可能になっている。なお、メンバの一覧はクラスメソッドの`members`メソッドで取得することができる。また`each_pair`メソッドにより、ハッシュの`each`のようにメンバ名と値を取り出すことができる。

~~~~
Dog = Struct.new(:age, :sex)
dog = Dog.new

dog.age = 10
dog.sex = :male

p dog[:age] # => 10
p dog[:sex] # => :male

p dog.members # => [:age, :sex]

dog.each_pair{|k, v|
	puts k, v
}
~~~~

`Struct.new`にブロックを渡して、その中にメソッドを定義することで、構造体にメソッドを持たせることもできる。とはいえ、ここまで来ると、果たして構造体である必要があるのかどうか、若干疑問ではある。

~~~~
Dog = Struct.new(:age, :sex) {
	def baw
		puts 'baw!'
	end
}
dog = Dog.new
dog.baw # => 'baw!'
~~~~
