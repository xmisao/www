---
layout: blog
title: Firefoxを徹底的に黒くする テーマ / Stylish / Vimperator
tag: firefox
---



# はじめに

ついカッとなってFirefoxを徹底的に黒くしたので手順をメモする。

この設定を施したFirefoxでこのブログを表示すると以下のような見た目になる。

![Dark Firefox]({{ site.url }}/assets/2014_08_08_dark_firefox.jpg)

# テーマ

これは簡単なカスタマイズだ。

[Firefoxのテーマ一覧](https://addons.mozilla.org/ja/firefox/themes/)から黒っぽいものを探してインストールするだけ。

私は[Simple brow](https://addons.mozilla.org/ja/firefox/addon/simple-brow/)を使った。流行っていないようだが、こういうシンプルなのが一番良い。

# Stylish

最近は歳のせいか白いWebページを苦痛に感じるようになってきた。Webページ自体を黒くしたい。

そんな要望を叶えてくれるのがStylishというアドオンと、Midnight Surfing - Global Dark Styleというスタイルだ。

## Stylishとは

StylishはWebページの見た目を自在にカスタマイズするためのアドオンだ。

このアドオンにより、[userstyles.org](https://userstyles.org/)からスタイルをインストールすることで、Webページの見た目をカスタマイズできるようになる。

## Stylishのインストール

Stylishをまだインストールしていないなら、まずStylishをインストールする。以下からインストールできる。インストール後はFirefoxの再起動が必要。

- [Stylish](https://addons.mozilla.org/ja/firefox/addon/stylish/)

## Midnight Surfing - Global Dark Styleのインストール

Midnight Surfing - Global Dark Styleは、その名の通りあらゆるサイトを黒背景・白文字のハイコントラストにするスタイルだ。

Stylishをインストールした上で、以下のページにアクセスし、"Install with Stylish"のボタンをクリックすることで、このスタイルをインストールできる。

- [Midnight Surfing - Global Dark Style ](https://userstyles.org/styles/23516/midnight-surfing-global-dark-style)

# Vimperator

以上で9割方のユーザは黒いFirefoxに満足できるものと思われるが、私はVimperatorを使っている。

## Vimperatorとは

VimperatorとはFirefoxをVim風に操作できるVimmer垂涎のFirefoxアドオンである。このプラグインのためにFirefoxから離れられないVimmerも多いと思われる。

Vimperatorの色は、カラースキームという独自の仕組みで設定する。Vimperatorも黒くするために、以下の手順でカラースキームを適用する。

## カラースキーム

[abyss](https://github.com/revivre/Vimperator/blob/master/colors/abyss.vimp)という黒ベースのカラースキームを見つけた。少々古く最新のVimperatorに読み込ませたらエラーが出たので、少しカスタマイズした。

以下の内容を`~/.vimperator/colors/abyss.vimp`として保存する。

~~~~vim
hi Bell               display: none;
hi CmdLine            font-family: monospace; font-size: 9pt; padding: 3px 2px;

hi CompResult         font-family: monospace; width: 35%; overflow: hidden;
hi CompDesc           width: 60%; color: LightGray; font-size: 9pt;
hi CompItem           font-size: 9pt; color: PaleGreen;
hi CompItem[selected] background-color: DimGray;
hi CompTitle          color: DeepPink; font-size: 11pt;

" Hints
hi Hint               font-family: monospace; font-size: 16px; font-weight: normal; color: white; background-color: rgba(0, 0, 0, 0.5); border: solid 1px LightGray;
hi HintElem           background-color: Khaki; color: Black;
hi HintActive         background-color: Orange; color: White;

hi Keyword            color: DodgerBlue;
hi NonText            background-color: #333;
hi Normal             color: LightGray; background-color: #333;
hi Question           color: LightGray; background-color: #333;

" Status Line
hi StatusLine         color: LightGray; background-color: #333; font-size: 9pt; font-family: monospace; font-weight: normal; padding: 2px 3px;

hi Tag                color: Orchid;
hi Title              color: DeepPink;
hi URL                color: LimeGreen;

" Messages
hi Message            color: LightGray; background-color: #333; font-family: monospace; font-size: 9pt;
hi ErrorMsg           background-color: DarkRed;
hi InfoMsg            background-color: #333;
hi ModeMsg            background-color: #333;
hi MoreMsg            background-color: #333;
hi WarningMsg         background-color: #333;

"" JavaScript Objects
hi Boolean            color: Chocolate;
hi Function           color: RoyalBlue;
hi Null               color: SlateGray;
hi Number             color: Crimson;
hi Object             color: Khaki;
hi String             color: LimeGreen;
~~~~

さらにカラースキームを読み込む設定を`~/.vimperatorrc`に追加する。

~~~~vim
:colorscheme abyss
~~~~

# おわりに

以上でFirefoxを満足いくまで黒くすることができた。いろいろ試行錯誤していたら2時間ぐらいかかってしまった。一体何をやっているのやら…。
