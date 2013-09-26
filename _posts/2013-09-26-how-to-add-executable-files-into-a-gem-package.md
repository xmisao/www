---
layout: blog
title: 実行可能ファイルをgemパッケージに含める方法
tag: ruby
---

# 実行可能ファイルをgemパッケージに含める方法

gemでアプリケーションを配布する場合、実行可能なファイルをgemパッケージに含めてやりたい事がある。例えば[拙作のxcalパッケージ](http://www.xmisao.com/2013/09/25/xcal-display-a-japan-calendar-like-cal.html)は、カレンダーを表示する`xcal`コマンドを含んでいる。以下ではxcalを例に、gemパッケージに実行可能ファイルを含める方法を説明する。

実行可能ファイルをgemパッケージに含めるには、まずディレクトリ構成を以下のようにして、binディレクトリにコマンド(この例では`xcal`)を配置する。

~~~~
├── xcal.gemspec
└── bin
    └── xcal
~~~~

続いて、gemspecファイルで、以下のようにexecutablesにコマンドを追加してやる。名前はbinディレクトリに配置したコマンド名に合わせる。

~~~~
Gem::Specification.new do |s|
  s.name        = 'xcal'
  s.version     = '1.0.0'
  s.date        = '2013-09-25'
  s.summary     = "xcal displays a japan calendar like cal, ncal"
  s.description = "xcal displays a japan calendar like cal, ncal"
  s.authors     = ["xmisao"]
  s.email       = 'mail@xmisao.com'
  s.files       = ["bin/xcal", "lib/xcal.rb"]
  s.homepage    = 'https://github.com/xmisao/xcal'
  s.executables << 'xcal' # here!
  s.add_dependency('icalendar')
end
~~~~

あとはgemをビルドすれば、実行可能ファイルが入ったgemパッケージを作成することができる。

実行可能ファイルが入ったgemパッケージは、`gem`でインストールした際に、gemによって`/usr/local/bin`以下に起動用コマンドが自動生成される。起動用コマンドは、パッケージに含めた実行可能ファイルを`load`する内容だ。

結果として、gemをインストールしたユーザは、/usr/local/bin以下の起動用コマンドを実行することで、パッケージに含まれた実行可能ファイルを実行させることができるようになる。

gemの作成方法とRubyGems.orgにgemを公開する方法については、[RubyGemsで自作のgemを公開する](http://www.xmisao.com/2013/06/22/rubygems-startup.html)を参照。
