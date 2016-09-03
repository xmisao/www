---
layout: blog
title: jQueryでクロスブラウザのonhashchangeイベント処理 jquery-hashchangeプラグイン
tag: javascript
---



非常に古いプラグインだが、役に立ったのでメモしておく。

# 背景

最近のブラウザは、URLの`#`以降が変更された時に、`window.onhashchange`イベントハンドラを呼び出す。
`#`以降の異なるURLはブックマークが可能で、履歴にも残りブラウザの戻る・進むも使うことができる。
このため`window.onhashchange`イベントは、JavaScriptで動的なページ書き換えを行う場合に重宝する。

しかし、このイベントハンドラはInternet Explorer 7以前など、古いブラウザではサポートされていない。

# jquery-hashchange

jquery-hashchangeは、`window.onhashchange`イベントに相当するイベントハンドラを、そのような古いブラウザでも使用可能にするjQueryプラグインだ。

jquery-hashchangeプラグインを使うと、以下のように`#`以降が変更された時のイベントハンドラを記述できるようになる。

~~~~javascript
$(window).hashchange(
  function(){
    // do something
  }
);
~~~~

# 2つのバージョン

注意点として、[公式のjquery-hashchange](https://github.com/cowboy/jquery-hashchange)は2010年で更新が止まっており、jQuery 1.9など比較的新しいjQueryには対応していない。

これをforkしてjQuery 1.9にも対応させた[新しいjquery-hashchange](https://github.com/georgekosmidis/jquery-hashchange)が公開されているので、現在はこちらを利用した方が良い。

# おわりに

最近はブラウザの`window.onhashchange`イベントへの対応が進んだことや、HTML5のpushState・popStateがあるため、jquery-hashchangeの出番は少ないかも知れない。

とはいえ枯れたプラグインなので、古い環境も考慮して確実に見かけのページ遷移を行いたい場合には、覚えておいて損はないように思う。
