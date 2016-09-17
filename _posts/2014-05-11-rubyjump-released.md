---
layout: blog
title: Vimプラグイン RubyJump v0.9.1 をリリースした
tag: ['rubyjump', 'vim', 'ruby']
---



# デモ

![rubyjump demo](/assets/2014_05_11_rubyjump_demo.gif)

# リリース

- [rubyjump.vim](https://github.com/xmisao/rubyjump.vim)

[XRubyJumpというvimプラグインを書いた](/2014/05/02/xrubyjump-released.html)が、本日これを大幅に機能拡張した最新版をリリースした。また、このリリースに合わせて、名前をXRubyJumpからRubyJumpに変更した。

主な変更点は以下のとおり。

- ジャンプ候補のあいまいな補完が可能になった
- `RubyJump`が全ウィンドウを検索できるようになった
- カレントウィンドウの検索は`RubyJumpLocal`として残した
- カーソル下の単語でジャンプする`RubyJumpCursour`を追加した
- 同名の候補へ`RubyJumpNext`/`RubyJumpPrev`で移動できるようにした
- 前後の定義へ`RubyJumpForward`/`RubyJumpBackward`で移動できるようにした
- カーソル移動の便利コマンドとして`RubyJumpNextForward`/`RubyJumpPrevBackward`を追加した
- `RubyJumpVersion`コマンドでバージョンを確認できるようにした
- その他バグフィックス多数

# 機能の概要

改めて紹介すると、RubyJumpはvimでRubyスクリプトを編集する際に、バッファ中のメソッド、モジュール、クラス定義に素早くジャンプするためのプラグインだ。

`RubyJump`コマンドで開いている全てのウィンドウの、`RubyJumpLocal`コマンドでカレントウィンドウの、定義にジャンプすることができる。定義の選択にはあいまいな補完が利用可能だ。他に`RubyJumpCursor`コマンドでカーソル下の単語で`RubyJump`することができる。

また`RubyJumpNextForward`と`RubyJumpPrevBackward`コマンドにより、ジャンプ直後に同名の別の定義に飛ぶことや、カーソル位置の前後にある別の定義にカーソル移動することができる。

設定例などは[githubの日本語READMEファイル](https://github.com/xmisao/rubyjump.vim/blob/master/README.ja.md)を参照。

# 開発の動機と設計思想

Rubyの定義へ移動するには、ctagsを使ったタグジャンプや、rails.vimといったプラグインを使った方法がある。
これらは便利だが、タグジャンプはファイルを更新する度にタグを生成するのが手間だし、rails.vimはrailsの構造に依存していてrails以外では使えないという欠点がある。

もっと手軽にあらゆるRubyスクリプトで高速なカーソル移動をすることはできないものか、と考えはじめたのが開発の動機だ。

RubyJumpは、多くの場合、カーソル移動したいファイルは既に開いている、という仮定に基づいて設計している。
RubyJumpが目指しているのは、バッファ中の定義にいかに早く簡単にジャンプするか、ということだ。

バッファ中の定義に飛び先を限定しているので、タグの生成も不要で、特定のファイル構造に依存するということもない。
RubyJumpの機能は、あらゆるRubyスクリプトを対象に、即座に高速なカーソル移動が可能になるようになっている。
