---
layout: blog
title: 技あり! gemspec中でファイル一覧を取得する
tag: ruby
---

# 技あり! gemspec中でファイル一覧を取得する

## はじめに

gemspecファイルはRubyのGemファイルの生成元となるファイルである。gemspecファイルでは、Gemに含むファイルの一覧を`Gem::Specification#files`に設定して、Gemファイルに含むファイル一覧を定義する。

ファイル数が少ない場合は手書きしても良いのだが、ファイル数が多い場合は1つ1つ書くのが馬鹿馬鹿しいため、普通は何らかの方法でファイル一覧をプログラム的に取得して設定する。

このファイル一覧の取得方法は標準化されているとは言いがたく、有名どころのGemであっても、ファイル一覧の取得方法は様々である。このエントリではいくつか目に止まったGemについて、ファイル一覧の取得・設定方法を見てみたい。

なおメジャーなGemを調べるには、拙作の[BestGems.org](http://bestgems.org/)が便利である。(宣伝)

## rack

[rack](https://github.com/rack/rack)は合計ダウンロードランキング2位である。
言わずと知れたWebサーバインタフェースはどのようにファイル一覧を取得しているのか。
以下が`rack.gemspec`からの抜粋である。

~~~~ruby
s.files = Dir['{bin/*,contrib/*,example/*,lib/**/*,test/**/*}'] +
%w(COPYING KNOWN-ISSUES rack.gemspec Rakefile README.rdoc SPEC)
~~~~

いきなりなんか難しい感じだ。`Dir.[]`は`Dir.glob`である。`Dir.glob`はワイルドカード展開を行いパターンにマッチしたファイル名を文字列の配列として返すメソッドだ。

`{bin/*,contrib/*,example/*,lib/**/*,test/**/*}`が難しいので構成要素を分解すると、`{}`は組み合わせの展開、`*`は任意の文字列とのマッチ、`**`は`*/`の0回以上の繰り返しとなっている。

良く読むと、これで`bin`直下のファイルや、`lib`以下の全ファイルなどを、一覧していることがわかる。意外とアナログである。

## thor

[thor](https://github.com/erikhuda/thor)は合計ダウンロードランキング3位である。
サードパーティのコマンドラインオプションのパーサとしては最も人気がある。
以下が`thor.gemspec`からの抜粋である。

~~~~ruby
spec.files = %w[.document CHANGELOG.md LICENSE.md README.md Thorfile thor.gemspec]
spec.files += Dir.glob("bin/**/*")
spec.files += Dir.glob("lib/**/*.rb")
spec.files += Dir.glob("spec/**/*")
~~~~

これは読みやすい。使っているのは`Dir.glob`でrackと変わらない。あまりトリッキーなことはせずに、可読性を重視しているように見える。`Array#+`で配列を連結できることをうまく活用していると言えるだろう。

## active-support

[active-support](https://github.com/rails/rails/tree/master/activesupport)は合計ダウンロードランキング4位である。
みんな大好きactive-supportは説明するまでもなく、Railsで使われている便利なクラスの詰め合わせだ。
以下が`active-support.gemspec`の抜粋である。

~~~~ruby
s.files = Dir['CHANGELOG.md', 'MIT-LICENSE', 'README.rdoc', 'lib/**/*']
~~~~

…なんだか`Dir.[]`だとか`Dir.glob`ばかりでつまらないが、こいつは`Dir.[]`に引数を複数渡している点がこれまでに紹介したGemとは異なる。`Dir.[]`は複数引数が取れるのである。組み合わせ展開なんて要らないのである。

なおrails系統のGemは同じように書かれていることを確認した。

## json

[json](https://github.com/flori/json)は合計ダウンロードランキング6位である。
jsonはその名の示す通りJSONのパースと生成を行うライブラリだ。
さて`json.gemspec`の抜粋は以下である。

~~~~ruby
s.files = ["./tests/test_json.rb", "./tests/test_json_addition.rb", 以下略
~~~~

数えたら115ファイル分ベタ書きされていたため、都合により省略させてもらった。
jsonはプログラムによるファイル一覧の生成には頼らず、すべてのファイルを手書きするというアプローチを取っていた。
まさか手書きとは思えないのだが、こういう形式のgemspecを出力するツールがあるのだろうか?

## builder

[builder](https://github.com/jimweirich/builder)は合計ダウンロードランキング9位である。
XML生成を行うライブラリである。

builderにはgemspecファイルは存在せず、rakeタスクでGemファイルを生成するようになっている。
このため`Rakefile`から`Gem::Specification#files`を設定する箇所を抜粋する。

~~~~ruby
PKG_FILES = FileList[
'[A-Z]*',
'doc/**/*',
'lib/**/*.rb',
'test/**/*.rb',
'rakelib/**/*'
]
~~~~

~~~~ruby
s.files = PKG_FILES.to_a
~~~~

`FileList`はrakeタスク中で使用できるファイル格納用の配列だ。`FileList.[]`は遅延評価であることを除いて`Dir.[]`と基本的には同じである。配列が必要なため最後に`FileList.to_a`している。

## tzinfo

[tzinfo](https://github.com/tzinfo/tzinfo)は合計ダウンロードランキング13位となっている。
異なるタイムゾーン間での時刻の相互変換を行うためのライブラリである。
以下は`tzinfo.gemspec`からの抜粋だ。

~~~~ruby
s.files = %w(CHANGES.md LICENSE Rakefile README.md tzinfo.gemspec .yardopts) +
          Dir['lib/**/*.rb'].delete_if {|f| f.include?('.svn')} +
          Dir['test/**/*.rb'].delete_if {|f| f.include?('.svn')} +
          Dir['test/zoneinfo/**/*'].delete_if {|f| f.include?('.svn') || File.symlink?(f)}
~~~~

内容自体はもはやつまらないものだが、特筆すべきはSubversionの管理ファイルを除外している点だろう。以前はSubversionで管理していたのだろうか。現在はGitHubで管理されているのでもはや不要なコードのように見える。

## tilt

[tilt](https://github.com/rtomayko/tilt)は合計ダウンロードランキング16位だ。
解説によると複数のテンプレートエンジンの汎用インタフェースとある。
`tilt.gemspec`を抜粋する。

~~~~ruby
s.files = %w[
  CHANGELOG.md
  COPYING
  Gemfile
  省略
]
~~~~

こいつもベタ書きだった。`%`記法を使ってコンマを省略している点がjsonと比べて新しいと言えば新しい。

## polyglot

[polyglot](https://github.com/cjheath/polyglot)は合計ダウンロードランキング19位だ。
良く知らないので説明は省略。

polyglotもgemspecは無く`Rakefile`でGemを生成する系統である。ようやくJewelerが出てきた。

~~~~ruby
Jeweler::Tasks.new do |gem|
  省略
end
~~~~

20位まで見て疲れたので最後にもう1パターンだけ紹介して、このエントリを終わりにする。

## jekyll

jekyllは合計ダウンロードランキング449位となっている。
GitHubでも使われていて静的サイトジェネレータとして広く知られている。
以下が`jekyll.gemspec`からの抜粋である。

~~~~ruby
all_files = `git ls-files -z`.split("\x0")
s.files = all_files.grep(%r{^(bin|lib)/})
~~~~

もはや自力でディレクトリを辿ってファイル一覧を生成するのを諦め、`git`コマンドを実行してしまっている。なおbundlerも似たようなgemspecを生成する。

`git ls-files`はGitで管理しているファイル一覧を出力するコマンド。`-z`は区切りをヌル文字とするオプション。ここに技あり! 改行ではなくヌル文字を使うことで安全にパスを切り出せるというわけだ。

ファイル一覧から必要なファイルだけを取り出すのに`Enumerable#grep`を使っているのもエレガントである。`Enumerable#grep`はパターンと`===`でマッチする要素を含んだ配列を返すメソッドだ。

この例では`git ls-files`の結果のうち、`bin`または`lib`からはじまるパスだけを、`files`に格納していることがわかる。

## おわりに

似ているものは省略したがGemの合計ダウンロードランキング1〜20位とjekyllについて、gemspecでファイル一覧を取得する方法について調べた。

何かテンプレートがあってひな形は自動生成されているような気もするのだが、そちらについてはあまり明るくないので特に書かないことにする。

想像以上にファイル一覧の取得・設定方法がばらついており、色々と生々しいものを見てしまった気分だ。たまにはこういう観点でGemを読んでみるのも面白い。もうやりたくないが…。
