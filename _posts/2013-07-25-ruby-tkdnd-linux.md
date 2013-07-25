---
layout: default
title: DebianでRubyからTcl/TkのTkDNDを利用してドラッグアンドドロップを実装する
---

# DebianでRubyからTcl/TkのTkDNDを利用してドラッグアンドドロップを実装する

Rubyでドラッグアンドドロップを実装したGUIプログラムを作りたかったが、全く情報が無く、苦労したのでメモする。
結論から書くと、tkライブラリと、TkDNDというエクステンションを活用すれば実装できる。

## 背景

Rubyではtkライブラリを使って、簡単にTcl/Tkを使ったGUIプログラムを作ることができる。
Tcl/Tkは便利だが、標準ではドラッグアンドドロップをサポートしていないという問題がある。この問題を解決するのが、TkDNDというTkのエクステンションだ。

実はRubyのtkライブラリにも、tkextlib/tkDNDというサブライブラリが用意されており、これでTkDNDを使うことができる。
しかし、Debianでは肝心のTkDNDのパッケージが提供されていない。このためTkDNDを自力でインストールしてやらねばならない。

## tkライブラリのインストール

まずRubyのtkライブラリをインストールする。芋づる式にtk本体も入る。

    apt-get install libtcltk-ruby

## TkDNDのインストール

TkDNDはSourceForgeでLinux向けのバイナリが提供されているので、これを利用する。

[http://sourceforge.net/projects/tkdnd/](http://sourceforge.net/projects/tkdnd/)

私の環境はx86\_64なので、tkdnd2.6-linux-x86_64.tar.gzをダウンロードした。これを展開し、/usr/lib/tcltk以下にコピーする。

    tar zxvf tkdnd2.6-linux-x86_64.tar.gz
    cp tkdnd2.6 /usr/lib/tcltk

なおTkDND 2.6はマルチプラットフォームで、Windows、Linux(X Window)、Macに対応しているようだ。

## プログラム例

Rubyのtkライブラリのドキュメントは燦々たるもので、チュートリアルを除いてほとんど情報がない。以下が詳しい。

- [Ruby/Tk チュートリアル](http://pub.cozmixng.org/~the-rwiki/rw-cgi.rb?cmd=view;name=Ruby%2FTk+%A5%C1%A5%E5%A1%BC%A5%C8%A5%EA%A5%A2%A5%EB)
- [逆引き Ruby/Tk](http://pub.cozmixng.org/~the-rwiki/rw-cgi.rb?cmd=view;name=%B5%D5%B0%FA%A4%ADRuby%2FTk)

特に拡張ライブラリに至っては、ほとんどを通りこして、全く情報がない。ソースを確認しつつ、手探りで使うしかないようだ。

以下に2つ、サンプルプログラムを示す。

### TkDNDのバージョン表示

TkDNDが正常に使えるか、確認してみよう。先ほどインストールしたバージョンのとおり、2.6と出れば正常だ。

    require 'tk'
    require 'tkextlib/tkDND'
    puts Tk::TkDND::DND.version

なお、TkDNDが正しくインストールされていない場合は、以下のエラーが表示される。

    /usr/lib/ruby/1.9.1/tk/package.rb:86:in `rescue in require': TkPackage can't find package tkdnd (RuntimeError)
            from /usr/lib/ruby/1.9.1/tk/package.rb:83:in `require'
            from /usr/lib/ruby/1.9.1/tkextlib/tkDND/tkdnd.rb:14:in `<top (required)>'
            from version.rb:3:in `<main>'

### 外部アプリケーションからのドラッグアンドドロップ

サブライブラリのtkDNDをrequireすると、TkWindowが拡張される。TkWindowはすべてのウィジットのスーパークラスだ。これで各種ウィジットのインスタンスで、dnd_から始まるメソッドが利用できるようになる。

以下のプログラムは、ラベルに外部アプリケーションからファイル(複数も可)をドロップすると、ターミナルにドロップ時の情報を出力する。

    require 'tk'
    require 'tkextlib/tkDND'
    
    Tk::TkDND::DND
    
    label = TkLabel.new{
    	text "Hello, World!"
    	dnd_bindtarget('text/uri-list', '<Drop>'){|event|
    		p event
    	}
    	pack
    }
    
    Tk.mainloop

出力から、変数eventのdataに、ドロップしたファイルのパスが配列で格納されているのが確認できるはずだ。

## まとめ

TkDNDのインストールというひと手間はあるが、たかだか10行のRubyスクリプトでドラッグアンドドロップが扱えるのは夢が広がる。
