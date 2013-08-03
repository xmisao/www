---
layout: default
title: BestGems Pickup! 第1回 「hike」
---

# BestGems Pickup! 第1回 「hike」

拙作の[BestGems](http://bestgems.org/)から注目のGemを紹介するエントリー。第1回は「hike」を取り上げる。

## 概要

hikeは指定したパスの中からファイルやディレクトリを検索するライブラリだ。Rubyのロードパスを見つけたり、シェルのパスから実行ファイルを探す用途に利用できる。

hikeは今日現在、合計ダウンロードランキング30位、デイリーダウンロードランキング25位につけている。

## インストール

    gem install hike

## 使用例

プロジェクト中からマッチしたファイルを見つける。

    trail = Hike::Trail.new "/Users/sam/Projects/hike"
    trail.append_extension ".rb"
    trail.append_paths "lib", "test"
    
    trail.find "hike/trail"
    # => "/Users/sam/Projects/hike/lib/hike/trail.rb"
    
    trail.find "test_trail"
    # => "/Users/sam/Projects/hike/test/test_trail.rb"

Rubyのロードパスを探索する。この例ではnet/httpライブラリとstrscanライブラリをloadした際のパスを探している。

    trail = Hike::Trail.new "/"
    trail.append_extensions ".rb", ".bundle"
    trail.append_paths *$:
    
    trail.find "net/http"
    # => "/Users/sam/.rvm/rubies/ree-1.8.7-2010.02/lib/ruby/1.8/net/http.rb"
    
    trail.find "strscan"
    # => "/Users/sam/.rvm/rubies/ree-1.8.7-2010.02/lib/ruby/1.8/i686-darwin10.4.0/strscan.bundle"

シェルのパスを探索する。lsコマンドとgemコマンドの在り処がわかる。

    trail = Hike::Trail.new "/"
    trail.append_paths *ENV["PATH"].split(":")
    
    trail.find "ls"
    # => "/bin/ls"
    
    trail.find "gem"
    # => "/Users/sam/.rvm/rubies/ree-1.8.7-2010.02/bin/gem"

## 解説

Trail.newに与えるのはベースパスで、明示的に指定しなければカレントディレクトリが指定される。このパスを起点に、add_pathsで検索対象のパスを相対パスで指定できる。add_pathsで絶対パスを指定する場合は、ベースパスは特に関係ない。なお、サブディレクトリの再帰的な検索はされない。

add_extensionsメソッドは、検索対象の拡張子を指定するメソッドだ。ここで拡張子を指定しておくと、findした際に、引数で与えた文字列に拡張子を連結したファイルがあるかもチェックするようになる。

拡張子の指定には、エイリアスという機能もある。alias_extension(new_extension, old_extension)すると、new_extensionがold_extensionと同じ拡張子として処理される。この機能は.htmlと.htmを同じ拡張子として処理させるような用途が想定されているようだ。

findは検索を行うメソッドだ。マッチしたファイルパスがフルパスで返される。findで検索できるのは、完全一致だけだ。引数にとるのはStringだけで、正規表現も指定できない。findはブロックを取ることもでき、マッチしたファイルを順に処理することもできる。
