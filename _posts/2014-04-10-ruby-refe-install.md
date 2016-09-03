---
layout: blog
title: ReFeのインストールと設定 -- Rubyリファレンスマニュアルをコマンドラインで読む
tag: ruby
---



Rubyにはコマンドラインでリファレンスを読めるツールReFeが存在する。

gemが用意されているが罠があり、`refe`パッケージは以下のようにエラーが出て使えない。

~~~~
# gem install refe
~~~~

~~~~
$ refe Array
/var/lib/gems/1.9.1/gems/refe-0.8.0.3/lib/refe/mygetopt.rb:14:in `new': undefined method `map' for #<String:0x00000000b86eb0> (NoMethodError)
        from /var/lib/gems/1.9.1/gems/refe-0.8.0.3/bin/refe:25:in `main'
        from /var/lib/gems/1.9.1/gems/refe-0.8.0.3/bin/refe:130:in `<top (required)>'
        from /usr/local/bin/refe:23:in `load'
        from /usr/local/bin/refe:23:in `<main>'
~~~~

正しくは`refe2`パッケージをインストールする。
これでReFe2本体と、BitClustが入る。

~~~~
# gem insatll refe2
~~~~

ReFeでドキュメントを参照できるようにするため、ドキュメントを取得してデータベースを構築する。
以下のように`bitclust`を実行する。
今日現在、1.8.7、1.9.3、2.0.0のデータベースが構築された。

~~~~
$ bitclust setup
~~~~

これでRubyのドキュメントが`refe`コマンドで参照できるようになった。

~~~~
$ refe Array
class Array < Object

include Enumerable

配列クラスです。
配列は任意の Ruby オブジェクトを要素として持つことができます。

一般的には配列は配列式を使って

  [1, 2, 3]

のように生成します。

* Singleton methods
[] new try_convert 

* Instance methods
& * + - << <=> == [] []= abbrev assoc bsearch clear clone collect! 
combination compact concat cycle delete delete_at delete_if each 
each_index empty? eql? fetch fill find_index first flatten hash 
include? insert inspect join keep_if last length pack permutation pop 
product push rassoc repeated_combination repeated_permutation replace 
reverse reverse_each rindex rotate rotate! sample select! shelljoin 
shift shuffle shuffle! slice slice! sort sort_by! to_a to_ary 
transpose uniq unshift values_at zip | 
~~~~

なおデフォルトは`~/.bitclust/config`で設定したバージョンのリファレンスからの検索となる。
例えばRuby 1.9.3のリファレンスをデフォルトにするには`:default_version`の行を以下のように書き換える。

~~~~
:default_version: 1.9.3
~~~~
