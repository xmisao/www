---
layout: blog
title: Vimプラグイン RubyJump v0.9.2 をリリースした
tag: ['rubyjump', 'vim', 'ruby']
---



# デモ

![rubyjump demo]({{ site.url }}/assets/2014_05_11_rubyjump_demo.gif)

# リリース

- [rubyjump.vim](https://github.com/xmisao/rubyjump.vim)

鋭意製作中のVimプラグイン RubyJumpの最新版となる v0.9.2 をリリースした。主な変更点は以下のとおり。

- `self.hoge`や`Hoge::Piyo`といった名前をパースできなかったバグを修正
- `RubyJump`と`RubyJumpLocal`で補完候補がない場合に変な候補が表示されるバグを修正
- ジャンプ先の抽出にripperを使うようにした
- ripperの有効無効を切り替える`g:rubyjump#enable_ripper`オプションを追加した
- RubyJumpの対象とするファイルタイプを`g:rubyjump#filetypes`で指定できるようにした

特に目玉となる変更点は、Rubyスクリプトのパースに[ripper](/2014/05/12/ruby-ripper.html)を使ってジャンプ先を抽出するようにしたこと。これによりコメントアウトされたコードにジャンプすることがなくなるなど、ユーザビリティが向上した。Ruby 1.9以上のRubyが使えるVimなら自動的にデフォルトで有効になる。

微妙な改良点としては`g:rubyjump#filetypes`でRubyJumpのジャンプ対象とするファイルタイプを自由に指定できるようになった。RubyJumpはripperでシンタックスエラーになるソースコードは正規表現で解析してジャンプ先を抽出するので、例えばRubyを併用したVimスクリプトにも上手くジャンプすることができる。これまでRubyJumpをRubyJumpを使って開発できない(!)という問題があったが、それを解決した。

RubyJumpのリリースも3回目となり、だいぶこなれてきた感じがするが、まだまだ改良したい箇所が残っている。今後手を付けたい部分としては以下のような感じ。

- ジャンプ先の抽出をバッファの内容が書き換えられた時だけ行うようにする
- 演算子オーバーロードにジャンプできない不具合を修正する
- ctagsと連携して開いていないファイルにもジャンプできるコマンドを作る
- その他、全般的なリファクタリング

RubyJumpはリリース間もないながら、現時点でgithubでスターが6つも付いていて感触も良好なので、今後もビシバシと機能追加していく予定。
