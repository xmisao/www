---
layout: blog
title: JekyllでHTMLをminifyする
tag: jekyll
---

# サマリ

Jekyllが生成するHTMLを圧縮(minify)したいことがあります。
そのような場合は[jekyll-compress-html](https://github.com/penibelst/jekyll-compress-html)を試してみる価値があるかも知れません。

## 前提バージョン 

|ソフトウェア          |バージョン    |備考                                                   |
|:-                    |:-            |:-                                                     |
|jekyll                |3.8.3         |-                                                      |
|jekyll-compress-html  |3.0.4         |-                                                      |

# jekyll-compress-html

jekyll-compress-htmlはpure Liquidで書かれた圧縮したHTMLのjekyllのレイアウトです。
Gemやプラグインではなく、2つほどファイルを配置するだけでjekyllの出力をminifyできます。

以下ではjekyll-compress-htmlの使い方を説明します。

## compress layoutの追加

`compress.html`をjekyllの`_layouts`以下に配置します。
`compress.html`はjekyll-compress-htmlの最新のリリースから取得して下さい。

[https://raw.githubusercontent.com/penibelst/jekyll-compress-html/master/site/_layouts/compress.html](https://raw.githubusercontent.com/penibelst/jekyll-compress-html/master/site/_layouts/compress.html)

jekyll-compress-htmlの3.0.4時点の`compress.html`は以下のとおりです。
見ての通り改行や不要な要素を取り除く複雑なLiquidであることがわかります。
なんだこのLiquidはっ! と思いますが、こういうものなのでこのまま利用させてもらいましょう。

```
{% base64 LS0tDQotLS0NCg0KeyUgY2FwdHVyZSBfTElORV9GRUVEICV9DQp7JSBlbmRjYXB0dXJlICV9eyUgaWYgc2l0ZS5jb21wcmVzc19odG1sLmlnbm9yZS5lbnZzIGNvbnRhaW5zIGpla3lsbC5lbnZpcm9ubWVudCAlfXt7IGNvbnRlbnQgfX17JSBlbHNlICV9eyUgY2FwdHVyZSBfY29udGVudCAlfXt7IGNvbnRlbnQgfX17JSBlbmRjYXB0dXJlICV9eyUgYXNzaWduIF9wcm9maWxlID0gc2l0ZS5jb21wcmVzc19odG1sLnByb2ZpbGUgJX17JSBpZiBzaXRlLmNvbXByZXNzX2h0bWwuZW5kaW5ncyA9PSAiYWxsIiAlfXslIGFzc2lnbiBfZW5kaW5ncyA9ICJodG1sIGhlYWQgYm9keSBsaSBkdCBkZCBwIHJ0IHJwIG9wdGdyb3VwIG9wdGlvbiBjb2xncm91cCBjYXB0aW9uIHRoZWFkIHRib2R5IHRmb290IHRyIHRkIHRoIiB8IHNwbGl0OiAiICIgJX17JSBlbHNlICV9eyUgYXNzaWduIF9lbmRpbmdzID0gc2l0ZS5jb21wcmVzc19odG1sLmVuZGluZ3MgJX17JSBlbmRpZiAlfXslIGZvciBfZWxlbWVudCBpbiBfZW5kaW5ncyAlfXslIGNhcHR1cmUgX2VuZCAlfTwve3sgX2VsZW1lbnQgfX0+eyUgZW5kY2FwdHVyZSAlfXslIGFzc2lnbiBfY29udGVudCA9IF9jb250ZW50IHwgcmVtb3ZlOiBfZW5kICV9eyUgZW5kZm9yICV9eyUgaWYgX3Byb2ZpbGUgYW5kIF9lbmRpbmdzICV9eyUgYXNzaWduIF9wcm9maWxlX2VuZGluZ3MgPSBfY29udGVudCB8IHNpemUgfCBwbHVzOiAxICV9eyUgZW5kaWYgJX17JSBmb3IgX2VsZW1lbnQgaW4gc2l0ZS5jb21wcmVzc19odG1sLnN0YXJ0aW5ncyAlfXslIGNhcHR1cmUgX3N0YXJ0ICV9PHt7IF9lbGVtZW50IH19PnslIGVuZGNhcHR1cmUgJX17JSBhc3NpZ24gX2NvbnRlbnQgPSBfY29udGVudCB8IHJlbW92ZTogX3N0YXJ0ICV9eyUgZW5kZm9yICV9eyUgaWYgX3Byb2ZpbGUgYW5kIHNpdGUuY29tcHJlc3NfaHRtbC5zdGFydGluZ3MgJX17JSBhc3NpZ24gX3Byb2ZpbGVfc3RhcnRpbmdzID0gX2NvbnRlbnQgfCBzaXplIHwgcGx1czogMSAlfXslIGVuZGlmICV9eyUgaWYgc2l0ZS5jb21wcmVzc19odG1sLmNvbW1lbnRzID09ICJhbGwiICV9eyUgYXNzaWduIF9jb21tZW50cyA9ICI8IS0tIC0tPiIgfCBzcGxpdDogIiAiICV9eyUgZWxzZSAlfXslIGFzc2lnbiBfY29tbWVudHMgPSBzaXRlLmNvbXByZXNzX2h0bWwuY29tbWVudHMgJX17JSBlbmRpZiAlfXslIGlmIF9jb21tZW50cy5zaXplID09IDIgJX17JSBjYXB0dXJlIF9jb21tZW50X2JlZm9yZXMgJX0ue3sgX2NvbnRlbnQgfX17JSBlbmRjYXB0dXJlICV9eyUgYXNzaWduIF9jb21tZW50X2JlZm9yZXMgPSBfY29tbWVudF9iZWZvcmVzIHwgc3BsaXQ6IF9jb21tZW50cy5maXJzdCAlfXslIGZvciBfY29tbWVudF9iZWZvcmUgaW4gX2NvbW1lbnRfYmVmb3JlcyAlfXslIGlmIGZvcmxvb3AuZmlyc3QgJX17JSBjb250aW51ZSAlfXslIGVuZGlmICV9eyUgY2FwdHVyZSBfY29tbWVudF9vdXRzaWRlICV9eyUgaWYgX2NhcnJ5ICV9e3sgX2NvbW1lbnRzLmZpcnN0IH19eyUgZW5kaWYgJX17eyBfY29tbWVudF9iZWZvcmUgfX17JSBlbmRjYXB0dXJlICV9eyUgY2FwdHVyZSBfY29tbWVudCAlfXslIHVubGVzcyBfY2FycnkgJX17eyBfY29tbWVudHMuZmlyc3QgfX17JSBlbmR1bmxlc3MgJX17eyBfY29tbWVudF9vdXRzaWRlIHwgc3BsaXQ6IF9jb21tZW50cy5sYXN0IHwgZmlyc3QgfX17JSBpZiBfY29tbWVudF9vdXRzaWRlIGNvbnRhaW5zIF9jb21tZW50cy5sYXN0ICV9e3sgX2NvbW1lbnRzLmxhc3QgfX17JSBhc3NpZ24gX2NhcnJ5ID0gZmFsc2UgJX17JSBlbHNlICV9eyUgYXNzaWduIF9jYXJyeSA9IHRydWUgJX17JSBlbmRpZiAlfXslIGVuZGNhcHR1cmUgJX17JSBhc3NpZ24gX2NvbnRlbnQgPSBfY29udGVudCB8IHJlbW92ZV9maXJzdDogX2NvbW1lbnQgJX17JSBlbmRmb3IgJX17JSBpZiBfcHJvZmlsZSAlfXslIGFzc2lnbiBfcHJvZmlsZV9jb21tZW50cyA9IF9jb250ZW50IHwgc2l6ZSB8IHBsdXM6IDEgJX17JSBlbmRpZiAlfXslIGVuZGlmICV9eyUgYXNzaWduIF9wcmVfYmVmb3JlcyA9IF9jb250ZW50IHwgc3BsaXQ6ICI8cHJlIiAlfXslIGFzc2lnbiBfY29udGVudCA9ICIiICV9eyUgZm9yIF9wcmVfYmVmb3JlIGluIF9wcmVfYmVmb3JlcyAlfXslIGFzc2lnbiBfcHJlcyA9IF9wcmVfYmVmb3JlIHwgc3BsaXQ6ICI8L3ByZT4iICV9eyUgYXNzaWduIF9wcmVzX2FmdGVyID0gIiIgJX17JSBpZiBfcHJlcy5zaXplICE9IDAgJX17JSBpZiBzaXRlLmNvbXByZXNzX2h0bWwuYmxhbmtsaW5lcyAlfXslIGFzc2lnbiBfbGluZXMgPSBfcHJlcy5sYXN0IHwgc3BsaXQ6IF9MSU5FX0ZFRUQgJX17JSBhc3NpZ24gX2xhc3RjaGFyID0gX3ByZXMubGFzdCB8IHNwbGl0OiAiIiB8IGxhc3QgJX17JSBhc3NpZ24gX291dGVybG9vcCA9IGZvcmxvb3AgJX17JSBjYXB0dXJlIF9wcmVzX2FmdGVyICV9eyUgZm9yIF9saW5lIGluIF9saW5lcyAlfXslIGFzc2lnbiBfdHJpbW1lZCA9IF9saW5lIHwgc3BsaXQ6ICIgIiB8IGpvaW46ICIgIiAlfXslIGlmIGZvcmxvb3AubGFzdCBhbmQgX2xhc3RjaGFyID09IF9MSU5FX0ZFRUQgJX17JSB1bmxlc3MgX291dGVybG9vcC5sYXN0ICV9e3sgX0xJTkVfRkVFRCB9fXslIGVuZHVubGVzcyAlfXslIGNvbnRpbnVlICV9eyUgZW5kaWYgJX17JSBpZiBfdHJpbW1lZCAhPSBlbXB0eSBvciBmb3Jsb29wLmxhc3QgJX17JSB1bmxlc3MgZm9ybG9vcC5maXJzdCAlfXt7IF9MSU5FX0ZFRUQgfX17JSBlbmR1bmxlc3MgJX17eyBfbGluZSB9fXslIGVuZGlmICV9eyUgZW5kZm9yICV9eyUgZW5kY2FwdHVyZSAlfXslIGVsc2UgJX17JSBhc3NpZ24gX3ByZXNfYWZ0ZXIgPSBfcHJlcy5sYXN0IHwgc3BsaXQ6ICIgIiB8IGpvaW46ICIgIiAlfXslIGVuZGlmICV9eyUgZW5kaWYgJX17JSBjYXB0dXJlIF9jb250ZW50ICV9e3sgX2NvbnRlbnQgfX17JSBpZiBfcHJlX2JlZm9yZSBjb250YWlucyAiPC9wcmU+IiAlfTxwcmV7eyBfcHJlcy5maXJzdCB9fTwvcHJlPnslIGVuZGlmICV9eyUgdW5sZXNzIF9wcmVfYmVmb3JlIGNvbnRhaW5zICI8L3ByZT4iIGFuZCBfcHJlcy5zaXplID09IDEgJX17eyBfcHJlc19hZnRlciB9fXslIGVuZHVubGVzcyAlfXslIGVuZGNhcHR1cmUgJX17JSBlbmRmb3IgJX17JSBpZiBfcHJvZmlsZSAlfXslIGFzc2lnbiBfcHJvZmlsZV9jb2xsYXBzZSA9IF9jb250ZW50IHwgc2l6ZSB8IHBsdXM6IDEgJX17JSBlbmRpZiAlfXslIGlmIHNpdGUuY29tcHJlc3NfaHRtbC5jbGlwcGluZ3MgPT0gImFsbCIgJX17JSBhc3NpZ24gX2NsaXBwaW5ncyA9ICJodG1sIGhlYWQgdGl0bGUgYmFzZSBsaW5rIG1ldGEgc3R5bGUgYm9keSBhcnRpY2xlIHNlY3Rpb24gbmF2IGFzaWRlIGgxIGgyIGgzIGg0IGg1IGg2IGhncm91cCBoZWFkZXIgZm9vdGVyIGFkZHJlc3MgcCBociBibG9ja3F1b3RlIG9sIHVsIGxpIGRsIGR0IGRkIGZpZ3VyZSBmaWdjYXB0aW9uIG1haW4gZGl2IHRhYmxlIGNhcHRpb24gY29sZ3JvdXAgY29sIHRib2R5IHRoZWFkIHRmb290IHRyIHRkIHRoIiB8IHNwbGl0OiAiICIgJX17JSBlbHNlICV9eyUgYXNzaWduIF9jbGlwcGluZ3MgPSBzaXRlLmNvbXByZXNzX2h0bWwuY2xpcHBpbmdzICV9eyUgZW5kaWYgJX17JSBmb3IgX2VsZW1lbnQgaW4gX2NsaXBwaW5ncyAlfXslIGFzc2lnbiBfZWRnZXMgPSAiIDxlOzxlOyA8L2U+OzwvZT47PC9lPiA7PC9lPiIgfCByZXBsYWNlOiAiZSIsIF9lbGVtZW50IHwgc3BsaXQ6ICI7IiAlfXslIGFzc2lnbiBfY29udGVudCA9IF9jb250ZW50IHwgcmVwbGFjZTogX2VkZ2VzWzBdLCBfZWRnZXNbMV0gfCByZXBsYWNlOiBfZWRnZXNbMl0sIF9lZGdlc1szXSB8IHJlcGxhY2U6IF9lZGdlc1s0XSwgX2VkZ2VzWzVdICV9eyUgZW5kZm9yICV9eyUgaWYgX3Byb2ZpbGUgYW5kIF9jbGlwcGluZ3MgJX17JSBhc3NpZ24gX3Byb2ZpbGVfY2xpcHBpbmdzID0gX2NvbnRlbnQgfCBzaXplIHwgcGx1czogMSAlfXslIGVuZGlmICV9e3sgX2NvbnRlbnQgfX17JSBpZiBfcHJvZmlsZSAlfSA8dGFibGUgaWQ9ImNvbXByZXNzX2h0bWxfcHJvZmlsZV97eyBzaXRlLnRpbWUgfCBkYXRlOiAiJVklbSVkIiB9fSIgY2xhc3M9ImNvbXByZXNzX2h0bWxfcHJvZmlsZSI+IDx0aGVhZD4gPHRyPiA8dGQ+U3RlcCA8dGQ+Qnl0ZXMgPHRib2R5PiA8dHI+IDx0ZD5yYXcgPHRkPnt7IGNvbnRlbnQgfCBzaXplIH19eyUgaWYgX3Byb2ZpbGVfZW5kaW5ncyAlfSA8dHI+IDx0ZD5lbmRpbmdzIDx0ZD57eyBfcHJvZmlsZV9lbmRpbmdzIH19eyUgZW5kaWYgJX17JSBpZiBfcHJvZmlsZV9zdGFydGluZ3MgJX0gPHRyPiA8dGQ+c3RhcnRpbmdzIDx0ZD57eyBfcHJvZmlsZV9zdGFydGluZ3MgfX17JSBlbmRpZiAlfXslIGlmIF9wcm9maWxlX2NvbW1lbnRzICV9IDx0cj4gPHRkPmNvbW1lbnRzIDx0ZD57eyBfcHJvZmlsZV9jb21tZW50cyB9fXslIGVuZGlmICV9eyUgaWYgX3Byb2ZpbGVfY29sbGFwc2UgJX0gPHRyPiA8dGQ+Y29sbGFwc2UgPHRkPnt7IF9wcm9maWxlX2NvbGxhcHNlIH19eyUgZW5kaWYgJX17JSBpZiBfcHJvZmlsZV9jbGlwcGluZ3MgJX0gPHRyPiA8dGQ+Y2xpcHBpbmdzIDx0ZD57eyBfcHJvZmlsZV9jbGlwcGluZ3MgfX17JSBlbmRpZiAlfSA8L3RhYmxlPnslIGVuZGlmICV9eyUgZW5kaWYgJX0= %}
```

## compressレイアウトを指定したレイアウトの定義

続いて`compress`を指定したレイアウトを定義します。

レイアウトを指定していないすべてのページでcompressを適用したいなら`_layouts/default.html`として以下の内容を書きます。
他のレイアウトでも構いませんが、その場合はcompressを適用したいページの`layout:`で、明示的に`compress`を適用しているレイアウトを指定する必要があります。

このレイアウトでは`layout: compress`がポイントです!
これでこのレイアウトが適用されたページは先程配置した`compress.html`で出力前にレイアウトされ、HTMLでは不要な空白などが除去されるようになります。
この例では`<html>`要素内に`{% base64 e3sgY29udGVudCB9fQ== %}`を配置していますが、`layout: compress`さえ指定していれば内容は任意です。

```
{% base64 LS0tDQpsYXlvdXQ6IGNvbXByZXNzDQotLS0NCg0KPGh0bWw+DQp7eyBjb250ZW50IH19DQo8L2h0bWw+ %}
```

## jekyll-compress-htmlの設定

`_config.yml`で`compress.html`の挙動を変更することができます。

改めて元のLiquidテンプレートを良く見ると、所々に分岐が書かれていることがわかります。
これが`_config.yml`で挙動を切り替える処理です。

`compress_html`以下に以下の値を設定できます。

```yaml
compress_html:
  clippings: []
  comments: []
  endings: []
  ignore:
    envs: []
  blanklines: false
  profile: false
  startings: []
```

詳細な解説は[公式の解説](http://jch.penibelst.de/#configuration)をご覧下さい。

私が試行錯誤した限り、おそらく大抵の用途を満たしつつ問題を起こさずにHTMLを圧縮する設定は以下のとおりです。

```yaml
compress_html:
  clippings: all
  comments: all
  endings: all
  ignore:
    envs: []
  blanklines: true
  profile: false
  startings: []
```

この設定は以下の挙動になります。

* 空白を除去しても安全なすべての要素に囲まれた空白を除去する
* すべてのコメントを除去する
* 任意の終了タグをすべて除去する
* 環境変数によってcompressレイアウトを無効化(無視)しない
* 空白行を除去する
* プロファイルモードを無効化
* 任意の開始タグを除去しない

## 制限事項

jekyll-compress-htmlには制限事項がドキュメントに明記されています。
ここだけはきちんと翻訳しておきます。

> * Whitespaces inside of the textarea element are squeezed. Please don’t use the layout on pages with non-empty textarea.
> * Inline JS can become broken where // comments used. Please remove the comments or change to /**/ style.
> * Invalid markup can lead to unexpected results. Please make sure your markup is valid before.

* textarea要素の内部の空白が除去されます。textareaが空でないページでcompressレイアウトを使用しないでください。
* インラインJavaScriptは`//`のコメントが使用されている箇所で破壊されることがあります。コメントを削除するか`/ ** /`スタイルのコメントに変更してください。
* 不正なマークアップは予期しない結果を招く恐れがあります。マークアップが正しいことを確認してください。

# まとめ

jekyll-compress-htmlはLiquidだけでminifyを実現していて、なかなか興味深いレイアウトです。
Gemも必要ありませんので、必要に応じてレイアウトをコピペするだけで、Jekyllで生成されるHTMLをminifyできます。
defaultのレイアウトにしてしまえば勝手にminifyされますので、1バイトでもHTMLの容量を縮めたいときには重宝します。

なおこのブログはjekyll-compress-htmlでminifyしてあります。
