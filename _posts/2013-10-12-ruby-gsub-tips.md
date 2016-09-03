---
layout: default
title: Rubyのgsubに関する2つのTIPS
tag: ruby
---



Rubyのエントリを漁っていて、これは面白いなと思ったので、メモしつつ紹介する。特に後者のハッシュを使った置換は目から鱗だった。

- [Using Ruby's Gsub With a Block](http://batsov.com/articles/2013/08/30/using-gsub-with-a-block/)
- [Using Ruby's Gsub With a Hash](http://batsov.com/articles/2013/10/03/using-rubys-gsub-with-a-hash/)

Rubyの`String#gsub()`は、文字列中のマッチした箇所を別の文字列に置換するおなじみのメソッドだ。しかし、`gusb()`をブロック付きで呼び出したり、引数にハッシュを与えたりしたことはあるだろうか?

# gusbをブロック付きで呼び出す

`gusb()`をブロック付きで呼び出すと、マッチした部分文字列がブロックに渡され、ブロックを評価した結果で置換される。

~~~~
'Apollo 12'.gsub(/\d+/) { |num| num.to_i.next }
# =>  'Apollo 13'
~~~~

この例は組み込み変数`$1`や`Regexp.last_match[1]`を使っても書くこともできるが、ブロックの引数を使った方がきれいだろう。なおブロックの引数は常に1つで、マッチした部分文字列全体が渡される。この点は少し不便だ。

# gusbにハッシュを与える

`gsub()`の第2引数にハッシュを与えると、マッチした部分文字列をキーとして、その値でマッチした部分を置き換えることができる。

~~~~
def geekify(string)
  string.gsub(/[leto]/, 'l' => '1', 'e' => '3', 't' => '7', 'o' => '0')
end

geekify('leet') # => '1337'
geekify('noob') # => 'n00b'
~~~~

これは1文字の置換だけに限らない。複数文字をキーとしても同じように働くので、以下のような複雑な置換も行える。なおハッシュを使った置換はRuby 1.9からの機能らしい。

~~~~
def doctorize(string)
  string.gsub(/M(iste)?r/, 'Mister' => 'Doctor', 'Mr' => 'Dr')
end

doctorize('Mister Freeze') # => 'Doctor Freeze'
doctorize('Mr Smith')   # => 'Dr Smith'
~~~~
