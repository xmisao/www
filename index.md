---
layout: default
---
[ぺけみさお](/about.html)(xmisao)の記録。

<h3>最近のエントリ</h3>
<ul class="posts">
  {% for post in site.posts limit:10 %}
    <li><span>{{ post.date | date: "%Y-%m-%d" }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>
<p><a href="entries.html">過去のエントリ一覧</a></p>

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

<h3>Webサービス</h3>

- [BestGems](http://bestgems.org/) -- RubyGemsのダウンロード数集計サイト
  
