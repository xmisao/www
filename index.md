---
layout: default
---
<img src="{{ root }}/xmisao_icon_16x16.png">[ぺけみさお](/about.html)(xmisao)の記録。 <a href="https://twitter.com/xmisao" class="twitter-follow-button" data-show-count="false">Follow @xmisao</a><script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>

<img src="{{ root }}/feed_icon_14x14.png"><a href="{{root}}/feed.xml">このブログを購読</a>

<div>
<a href="http://reader.livedoor.com/subscribe/http://www.xmisao.com/feed.xml" target="_blank" title="Subscribe with livedoor Reader"><img src="http://image.reader.livedoor.com/img/banner/88_31_3.gif" border="0" width="88" height="31" alt="Subscribe with livedoor Reader"></a>
<a href='http://cloud.feedly.com/#subscription%2Ffeed%2Fhttp%3A%2F%2Fwww.xmisao.com%2Ffeed.xml'  target='blank'><img id='feedlyFollow' src='http://s3.feedly.com/img/follows/feedly-follow-rectangle-volume-medium_2x.png' alt='follow us in feedly' width='71' height='28'></a>
</div>

<h3>最近のエントリ</h3>
<ul class="posts">
  {% for post in site.posts limit:20 %}
    <li>
      <span>{{ post.date | date: "%Y-%m-%d" }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a>
      <a href="http://b.hatena.ne.jp/entry/http://www.xmisao.com{{ BASE_PATH }}{{ post.url }}">
      <img src="http://b.hatena.ne.jp/entry/image/http://www.xmisao.com{{ BASE_PATH }}{{ post.url }}">
      </a>
    </li>
  {% endfor %}
</ul>
<p><a href="entries.html">過去のエントリ一覧</a></p>

<h3>検索</h3>
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

<h3>タグクラウド</h3>
<ul class="tagcloud">
{% for tag in site.tags %}
    <li style="font-size: {{ tag | last | size | times: 200 | divided_by: site.tags.size | plus: 100 }}%">
        <a href="/tags/{{ tag | first | slugize }}">
            {{ tag | first }}({{ tag | last | size }})
        </a>
    </li>
{% endfor %}
</ul>

<h3>ページ</h3>
<ul class="posts">
	<li><a href="/jirorian/">ラーメン二郎マップ</a> -- お近くの二郎をお探しの際に。</li>
	<li><a href="/cigarette/">世界のたばこレビュー</a> -- ぺけみさおの吸ったたばこをレビューしていきます。</li>
</ul>

<h3>プロジェクト</h3>

- [x2ch](https://github.com/xmisao/x2ch) -- Rubyで簡単に2chへアクセスするためのライブラリ
- [xfonts-umplus](https://github.com/xmisao/xfonts-umplus) -- Unicodeエンコードのmplusフォントdebパッケージ
- [xcal](https://github.com/xmisao/xcal) -- 日本の休日に対応したcalライクなカレンダーコマンド
- [featuredimage](https://github.com/xmisao/featuredimage) -- Webページから目を引く画像を抽出するライブラリ
- [mplus-webfonts](http://mplus-webfonts.sourceforge.jp/) -- M+ FONTSをEOT, TTF, WOFFに変換したWebフォント
- [syobocal](https://github.com/xmisao/syobocal) -- しょぼいカレンダーからデータを取得するライブラリ
- [rubyjump.vim](https://github.com/xmisao/rubyjump.vim) -- バッファ内のRubyの定義に簡単に飛べるVimプラグイン
- [aws-reporting](https://github.com/xmisao/aws-reporting) -- CloudWatchからデータを取得してAWSの性能をHTMLでレポーティングするツール

<h3>Webサービス</h3>

- [BestGems](http://bestgems.org/) -- RubyGemsのダウンロード数集計サイト
- [はてなブックマーク ウォールβ](http://hbwall.xmisao.com/) -- レスポンシブなはてなブックマークのホッテントリ一覧ページ
- [よく使うハンドサイン画像ジェネレータ](http://handsign.xmisao.com/) -- SNSで話題のハンドサイン画像を作ろう!  
- [ぺけアニメデータベース](http://animedb.xmisao.com/) -- 似たアニメが一目瞭然! アニメのデータベースサイト
