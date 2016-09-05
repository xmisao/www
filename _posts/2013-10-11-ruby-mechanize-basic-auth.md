---
layout: blog
title: Ruby MechanizeでBASIC認証する
tag: ruby
---



RubyのMechanizeでBASIC認証を扱う場合は`add_auth()`を使う。`add_auth()`の引数は、BASIC認証を使うURLの一部、ユーザ名、パスワードだ。以下の例のように、マッチするURL以下にBASIC認証を使ったアクセスを行う。

~~~~
require 'mechanize'
agent = Mechanize.new
agent.add_auth('http://example.org', 'foo', 'bar')
page = agent.get('http://example.org/buz')
~~~~

なお`auth()`や`basic_auth()`というメソッドもあるが、こちらはセキュリティ上の理由でdeprecatedになっており、以下のエラーが出る。これらのメソッドでは、BASIC認証を使うURLを指定しないため、ユーザ名とパスワードを本来は必要がない場合でも送ってしまう不具合があるためらしい。

~~~~
At /tmp/vHUJYIW/23 line 4

Use of #auth and #basic_auth are deprecated due to a security vulnerability.


You have supplied default authentication credentials that apply to ANY SERVER.
Your username and password can be retrieved by ANY SERVER using Basic
authentication.

THIS EXPOSES YOUR USERNAME AND PASSWORD TO DISCLOSURE WITHOUT YOUR KNOWLEDGE.

Use add_auth to set authentication credentials that will only be delivered
only to a particular server you specify.
~~~~

- 関連
  - [楽々スクレイピング! Ruby Mechanizeの使い方](http://www.xmisao.com/2013/10/05/ruby-www-mechanize.html)
