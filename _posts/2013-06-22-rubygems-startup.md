---
layout: blog
title: RubyGemsで自作のgemを公開する
tag: programming
---

# RubyGemsで自作のgemを公開する

RubyGemsに自作のgemを公開するのは敷居が高く感じるが、手順はとても簡単なので、もっとこの手軽さが知られても良いと思う。

詳しい手順はRubyGemsのガイドを参考のこと。

[Make your own gem](http://guides.rubygems.org/make-your-own-gem/)

## gemの作成

例としてholaというgemを作る。holaは自分のgem名に読み替えること。ツールは使わず自分でスクラッチする。

hola.gemspecとlibディレクトリ、更にlibの内部にライブラリ本体のhola.rbを作成する。ディレクトリ構成は以下のようになる。

    ├── hola.gemspec
    └── lib
        └── hola.rb

hola.rbはこんな内容だとする。

    class Hola
      def self.hi
        puts "Hello world!"
      end
    end

hola.gemspecを記述する。

    Gem::Specification.new do |s|
      s.name        = 'hola'
      s.version     = '0.0.0'
      s.date        = '2010-04-28'
      s.summary     = "Hola!"
      s.description = "A simple hello world gem"
      s.authors     = ["Nick Quaranto"]
      s.email       = 'nick@quaran.to'
      s.files       = ["lib/hola.rb"]
      s.homepage    = 'http://rubygems.org/gems/hola'
    end

gemをビルドする。これでhola-0.0.0.gemができる。

    % gem build hola.gemspec

gemを試しにインストールしてみよう。

    % gem install ./hola-0.0.0.gem

irbでholaが使えるか確認する。Ruby 1.9.2より以前のバージョンでは、irb -rubygemsで起動しよう。

    % irb
    >> require 'hola'
    => true
    >> Hola.hi
    Hello world!

## RubyGemsのアカウントを作成する

[https://rubygems.org/](https://rubygems.org/)の右上の「sign up」からアカウントを作成しておく。

## APIキーの保存

RubyGemsに登録するためにAPIキーを保存する。qrushは自分のアカウントに読み替える。

    % curl -u qrush https://rubygems.org/api/v1/api_key.yaml > ~/.gem/credentials
    Enter host password for user 'qrush':

## RubyGemsへ登録

gemファイルをRubyGemsに登録する。gem pushコマンドを用いる。

    % gem push hola-0.0.0.gem

これでRubyGemsに登録された。gemコマンドで確認してインストールしてみる。

    % gem list -r hola
    
    *** REMOTE GEMS ***
    
    hola (0.0.0)
    
    % gem install hola
    Successfully installed hola-0.0.0
    1 gem installed
