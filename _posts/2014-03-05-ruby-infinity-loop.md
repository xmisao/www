---
layout: blog
title: Rubyで無限ループはkernel.#loop
tag: ruby
---

# Rubyで無限ループはkernel.#loop

Rubyの無限ループで最も簡潔なのは`Kernel.#loop`だろう。

`Kernel.#loop`はブロックの中身を無限に繰り返すメソッドだ。

~~~~
loop do
  # 無限ループ!
end
~~~~

ブロック内で`StopIteration`を`raise`するとnilを返してループは終了する。

~~~~
loop do
  raise StopIteration
end
~~~~

単にループを終わらせたいなら`break`すれば良い。

~~~~
loop do
  break
end
~~~~
