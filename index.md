---
layout: default
title-string: "ぺけみさお(xmisao)のポートフォリオ"
active-tab: "home"
---

<!--TODO 購読のリンクをつけるか要検討 -->

<h1>最近のエントリ</h1>
<dl class="posts">
  {% for post in site.posts limit:20 %}
  <dt>{{ post.date | date: "%Y-%m-%d" }}</dt>
  <dd>
  <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a>
  <a href="http://b.hatena.ne.jp/entry/http://www.xmisao.com{{ BASE_PATH }}{{ post.url }}"><img src="http://b.hatena.ne.jp/entry/image/http://www.xmisao.com{{ BASE_PATH }}{{ post.url }}"></a>
  </dd>
  {% endfor %}
</dl>
<p><a href="entries.html">過去のエントリ一覧</a></p>

<h1>検索</h1>
<div>
<script>
  (function() {
    var cx = '010316783992048822387:wtqk9pesgts';
    var gcse = document.createElement('script');
    gcse.type = 'text/javascript';
    gcse.async = true;
    gcse.src = (document.location.protocol == 'https:' ? 'https:' : 'http:') +
        '//www.google.com/cse/cse.js?cx=' + cx;
    var s = document.getElementsByTagName('script')[0];
    s.parentNode.insertBefore(gcse, s);
  })();
</script>
<gcse:search></gcse:search>
</div>

<h1>タグクラウド</h1>
<ul class="tagcloud">
{% for tag in site.tags %}
  <li style="font-size: {{ tag | last | size | times: 200 | divided_by: site.tags.size | plus: 100 }}%">
      <a href="/tags/{{ tag | first | slugize }}">
          {{ tag | first }}({{ tag | last | size }})
      </a>
  </li>
{% endfor %}
</ul>

<h1>プロジェクト</h1>

- [x2ch](https://github.com/xmisao/x2ch) -- Rubyで簡単に2chへアクセスするためのライブラリ
- [xfonts-umplus](https://github.com/xmisao/xfonts-umplus) -- Unicodeエンコードのmplusフォントdebパッケージ
- [xcal](https://github.com/xmisao/xcal) -- 日本の休日に対応したcalライクなカレンダーコマンド
- [featuredimage](https://github.com/xmisao/featuredimage) -- Webページから目を引く画像を抽出するライブラリ
- [mplus-webfonts](http://mplus-webfonts.sourceforge.jp/) -- M+ FONTSをEOT, TTF, WOFFに変換したWebフォント
- [syobocal](https://github.com/xmisao/syobocal) -- しょぼいカレンダーからデータを取得するライブラリ
- [rubyjump.vim](https://github.com/xmisao/rubyjump.vim) -- バッファ内のRubyの定義に簡単に飛べるVimプラグイン
- [aws-reporting](https://github.com/xmisao/aws-reporting) -- CloudWatchからデータを取得してAWSの性能をHTMLでレポーティングするツール
- [xwebhookexe](https://github.com/xmisao/xwebhookexe) -- webhookを受信して任意のコマンドを実行するGo製Webサーバ
- [wliconfig](https://github.com/xmisao/wliconfig) -- バッファローのWLIシリーズの設定を変更する非公式CLI

<h1>Webサービス</h1>

- [BestGems](http://bestgems.org/) -- RubyGemsのダウンロード数集計サイト
- [ぺけアニメデータベース](http://animedb.xmisao.com/) -- 似たアニメが一目瞭然! アニメのデータベースサイト

<h2>公開中止</h2>
- はてなブックマーク ウォールβ -- レスポンシブなはてなブックマークのホッテントリ一覧ページ
- よく使うハンドサイン画像ジェネレータ -- SNSで話題のハンドサイン画像を作ろう!
