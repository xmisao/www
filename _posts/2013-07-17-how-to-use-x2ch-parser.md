---
layout: blog
title: x2chの使い方 -- チャットちゃんねるを扱う
tag: x2ch
---



拙作の2ちゃんねるアクセス用のライブラリ[x2ch](https://github.com/xmisao/x2ch)は、パーサとダウンローダーを独立して使えるようになっている。このため、2ちゃんねると同じ構造の掲示板であれば、何でもx2chで扱うことができる。

例えば[チャットちゃんねる](http://cha2.net/)のアニメ特撮実況掲示板を扱うには、以下のように板を表すBoardクラスを自分で生成して使うと良い。

    require 'x2ch'
    include X2CH
    
    url = 'http://cha2.net/cgi-bin/anitoku/'
    name = 'アニメ特撮実況掲示板'
    Board.new(url, name).each{|thread|
    	p thread
    }

上の例では板をx2chに解釈させて、スレッドを取り出している。もしDATファイルのURLまでわかっているなら、以下の方法でDATファイルのパーサだけ利用することもできる。

    require 'x2ch'
    include X2CH

    url = ""
    dat = Dat.download(url)
    Dat.parse(dat).each{|post|
    	p post
    }

parseはStringでDATファイルの内容を与えればそれをパースして、投稿を表すPostクラスの配列を返すメソッドだ。

DATファイルは別にx2chでダウンロードさせなくても良いので、既にダウンロードして保存してあるDATファイルを読み込ませ、内容をパースするような使い方もできるだろう。
