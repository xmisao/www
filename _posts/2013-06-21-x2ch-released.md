---
layout: blog
title: Rubyで2chにアクセスするライブラリx2chを作った
tag: x2ch
---



Rubyで2chにアクセスする適当なライブラリがなかったので、自分好みのライブラリx2ch(ぺけにちゃんねる)を作った。
200行足らずの小さいライブラリだが、rubygemsにも公開したので以下でインストールできる。

    gem install x2ch

このライブラリのアピールポイントは、とりあえずeachしまくればデータががんがんダウンロードできること。
使用例は以下のとおり。

2chのカテゴリーと板一覧を取得する。

    require 'x2ch'
    include X2CH
    
    bbs = Bbs.load
    bbs.each{|category|
        puts '- ' + category.name
        category.each{|board|
            puts ' - ' + board.name 
        }
    }

カテゴリー「趣味」の「アクアリウム」板のスレッド一覧を取得する。

    require 'x2ch'
    include X2CH
    
    bbs = Bbs.load
    bbs['趣味']['アクアリウム'].each{|thread|
        puts thread.name + '(' + thread.num.to_s + ')'
    }

アクアリウム板の最初のスレッドの投稿を取得する。

    require 'x2ch'
    include X2CH
    
    bbs = Bbs.load
    bbs['趣味']['アクアリウム'].threads.first.each{|post|
        puts "#{post.name} <> #{post.mail} <> #{post.metadata} <> #{post.body}"
    }

rubygemsとGitHubのURLは以下。

- [https://rubygems.org/gems/x2c](https://rubygems.org/gems/x2ch)
- [https://github.com/xmisao/x2ch](https://github.com/xmisao/x2ch)
