---
layout: default
title: BestGems Pickup! 第2回 「builder」
tag: "bestgems_pickup"
---

# BestGems Pickup! 第1回 「hike」

拙作の[BestGems](http://bestgems.org/)から注目のGemを紹介するエントリー。第2回は「builder」を取り上げる。

## 概要

builderはXMLを簡単に構築できるライブラリだ。ある種のDSLのように、RubyのソースコードとしてXMLを記述することができる。APIを使用するために複雑なXMLをRubyで構築したり、HTMLを記述する用途にも利用できるだろう。

builderは今日現在、合計ダウンロードランキング12位、デイリーダウンロードランキング5位につけている。人気急上昇のライブラリである。

## インストール

    gem install builder

## 使用例

XmlMarkupオブジェクトに対するメソッド呼び出しがそのままタグに、ブロックがタグで挟まれた内容として構築される。なおXmlMarkupはStringのサブクラスなので、そのまま文字列として振る舞う。以下のコードを見るだけで、使い方が一目でわかる。

    require 'builder'
    
    builder = Builder::XmlMarkup.new
    xml = builder.person { |b| b.name("Jim"); b.phone("555-1234") }
    xml #=> <person><name>Jim</name><phone>555-1234</phone></person>

XmlMarkupクラスのコンストラクタはオプションを取り、出力先や整形のオプションを指定できる。この例では構築と同時にXMLが標準出力に出力される。

    require 'builder'
    
    builder = Builder::XmlMarkup.new(:target=>STDOUT, :indent=>2)
    builder.person { |b| b.name("Jim"); b.phone("555-1234") }
    #
    # Prints:
    # <person>
    #   <name>Jim</name>
    #   <phone>555-1234</phone>
    # </person>

ちなみにbuilder 2.1では、以下のオプションが用意されている。

- :indent -- インデントに使われるスペース数。デフォルトはインデントなし。
- :margin -- 初期のインデント量。
- :quote -- クオートの種類。:singleでシングルクオート、:doubleでダブルクオート。
- :target -- マークアップを受け取るオブジェクト。このオブジェクトに<<演算子で結果が渡される。デフォルトは空文字列。

comment!メソッドでXMLコメントを記述できる。

    xml_markup.comment! "This is a comment"
    #=>  <!-- This is a comment -->

instruct!メソッドでXML宣言も思いのまま。

    xml_markup.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
    #=>  <?xml version="1.0" encoding="UTF-8"?>

declare!メソッドでDOCTYPE宣言も書ける。

    xml_markup.declare! :DOCTYPE, :chapter, :SYSTEM, "../dtds/chapter.dtd"
    #=>  <!DOCTYPE chapter SYSTEM "../dtds/chapter.dtd">

エレメントも。

    xml_markup.declare! :ELEMENT, :chapter, :"(title,para+)"
    #=>  <!ELEMENT chapter (title,para+)>

合わせ技だとこんな感じで立派なDOCTYPE宣言の完成。

    @xml_markup.declare! :DOCTYPE, :chapter do |x|
      x.declare! :ELEMENT, :chapter, :"(title,para+)"
      x.declare! :ELEMENT, :title, :"(#PCDATA)"
      x.declare! :ELEMENT, :para, :"(#PCDATA)"
    end
    
    #=>
    
    <!DOCTYPE chapter [
      <!ELEMENT chapter (title,para+)>
      <!ELEMENT title (#PCDATA)>
      <!ELEMENT para (#PCDATA)>
    ]>

引数で与えた内容はデフォルトでエスケープされる。プログラム側で出力がXMLであることは意識しなくて良い。

    xml = Builder::XmlMarkup.new
    xml.sample(:escaped=>"This&That", :unescaped=>:"Here&amp;There")
    xml.target!  =>
    	<sample escaped="This&amp;That" unescaped="Here&amp;There"/>

## 解説

まるで魔法のようなXmlMarkupの仕組みは、Rubyのメタプログラミングに慣れた人にはお馴染みの、method_missingによるトリックだ。XmlMarkupクラスは、不要なメソッドをObjectクラスから省いた、いわゆるブランクスレートを継承している。
ブランクスレートは定義されたメソッドの定義がないため、メソッド呼び出しはすべてmethod_missingで処理される。XmlMarkupはこのmethod_missingでメソッド名のタグを作る実装になっている。

builderはそれ自体が便利なライブラリであるというだけでなく、Rubyのメタプログラミングのお手本として、ソースを読み込んでみても良いだろう。
