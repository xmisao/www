---
layout: blog
title: Rubyのdupとcloneの違い
tag: ruby
---



Rubyの`Object.dup`と`Object.clone`の違いは、特異メソッドと`freeze`をコピーするかどうかである。
`Object.clone`の方がコピーされる情報が多いが、一般的な用途には`Object.dup`で十分だ。
以下は検証コード。

~~~~
obj1 = Object.new
obj1.taint
def obj1.singleton_method; end
obj1.freeze

obj2 = obj1.dup
obj3 = obj1.clone

p obj1.tainted? #=> true
p obj1.respond_to?(:singleton_method) #=> true
p obj1.frozen? #=> true

p obj2.tainted? #=> true
p obj2.respond_to?(:singleton_method) #=> false
p obj2.frozen? #=> false
 
p obj3.tainted? #=> true
p obj3.respond_to?(:singleton_method) #=> true
p obj3.frozen? #=> true
~~~~

- 参考
  - [instance method Object#clone](http://docs.ruby-lang.org/ja/1.9.3/method/Object/i/clone.html)
