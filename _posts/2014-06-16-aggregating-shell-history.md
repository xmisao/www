---
layout: blog
title: シェルの履歴を集計する
tag: shell
---



ちょっと疲れたのでお遊び。

以下でシェルの履歴を集計して、どんなコマンドを良く使っているか調べられる。

~~~~
awk '{print $1}' ~/.bash_history | sort | uniq -c | sort -n
~~~~

ちなみに私の場合は…。

~~~~
...
    231 mv
    319 rake
    929 git
    981 exit
   1180 sudo
   1223 vim
   1966 cd
   2350 ruby
   2469 ls
   2664 fg
~~~~

1番使っているのはなんと`fg`。
これはひどい…。
ちょっとvimで作業をして、シェルに戻って、vimに戻って…というのが効いている模様。

さて、あなたはどんな感じでしょうか。
ぜひ試してみて下さい。
