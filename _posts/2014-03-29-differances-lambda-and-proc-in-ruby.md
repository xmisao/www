---
layout: blog
title: RubyのlambdaとProc.newにおけるreturnの挙動の違い
tag: ruby
---

# RubyのlambdaとProc.newにおけるreturnの挙動の違い

以下のような挙動となる。注意。

~~~~
def method1
  proc = lambda{
    return "return in lambda"
  }
  proc.call
  return "return in method"
end
p method1() #=> "return in method"

def method2
  proc = Proc.new{
    return "return in proc"
  }
  proc.call
  return "return in method"
end
p method2() #=> "return in proc"
~~~~
