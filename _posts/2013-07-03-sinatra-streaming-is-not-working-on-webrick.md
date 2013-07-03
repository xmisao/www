---
layout: default
title: Sinatra::Streamingの使い方と注意点
---

# Sinatra::Streamingの使い方と注意点

SinatraからはWebサーバのIOが隠蔽されているので、通常はメモリ上で結果を生成し、それを返すことしかできない。

Sinatra::Streamingを使うと、Sinatra上でストリーミング出力を実装することができる。これにより巨大なファイルを徐々に送信したり、WebSocketもどきを実装することができる。

Sinatra::Streamingはsinatra-contribに含まれている。準備として、sinatra-contribをインストールする。

    gem install sinatra-contrib

使い方だが、ストリーミング出力はstream()メソッドで行う。例として1秒ごとにメッセージを送信するアプリケーションは以下のように書ける。

    require 'sinatra'
    require 'sinatra/contrib/streaming'
    
    get '/'
    	stream do |out|
    		out << 'Hello, World!<br>'
    		out.flush
    		sleep 1
    	end
    end

stream()は引数を指定でき、:keep_openを指定してやると、接続を保ったまま保持し、サーバから任意のタイミングでメッセージを送る事もできるようだ。

注意点としてSinatra::Streamingは便利だが、1つ落とし穴がある。webrickでは動作しないようなのだ。出力がすべてバッファリングされてしまうし、:keep_openも動作しない。

私はwebrickの代わりにthinを使っている。thinは起動するとカレントディレクトリのconfig.ruを読み込み動作する。

インストール

   gem install thin

起動(config.ruのあるディレクトリで)

   thin start

上記のアプリケーションの例をapp.rbとすると、config.ruはこんな感じで。

    require 'sinatra'
    load 'app.rb'
    
    run Sinatra::Application

以上で、Sinatraで実装できるアプリケーションの幅が一気に広くなるだろう。

参考:  
[http://www.sinatrarb.com/contrib/streaming.html](http://www.sinatrarb.com/contrib/streaming.html)

