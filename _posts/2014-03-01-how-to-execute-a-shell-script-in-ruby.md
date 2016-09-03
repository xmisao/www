---
layout: blog
title: Rubyでシェルコマンドを実行する方法
tag:
---



Rubyでは以下4つの方法でシェルコマンドを実行することができる。

1. Kernel#\`, バッククォート \`cmd\`
2. %記法, %x( cmd )
3. Kernel#system
4. Kernel#exec

# 1. Kernel#\`, バッククォート \`cmd\`

これはBash, PHP, Perlなど他の言語と似ている。

シェルコマンドの結果を返す。

終了ステータスは変数`$?`で参照できる。

~~~~
value = `echo 'hi'`
value = `#{cmd}`
~~~~

# 2. %記法, %x( cmd )

バッククォートと同様に、シェルコマンドの結果を返す。

終了ステータスは変数`$?`で参照できる。

~~~~
value = %x( echo 'hi' )
value = %x[ #{cmd} ]
~~~~

# 3. Kernel#system

与えたシェルコマンドをサブシェルで実行する。

コマンドが見つかり実行が成功したらtrue、そうでなければfalseを返す。

終了ステータスは変数`$?`で参照できる。

~~~~
wasGood = system( "echo 'hi'" )
wasGood = system( cmd )
~~~~

# 4. Kernel#exec

シェルコマンドを実行して実行中のプロセスを置き換える。

成功すると処理が戻らないため、返却値はない。

~~~~
exec( "echo 'hi'" )
exec( cmd )
~~~~

参考

- [Calling Bash Commands From Ruby](http://stackoverflow.com/questions/2232/calling-bash-commands-from-ruby)
