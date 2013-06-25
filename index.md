---
layout: default
---
[ぺけみさお](/about.html)(xmisao)の記録。

<h3>エントリ</h3>
<ul class="posts">
  {% for post in site.posts %}
    <li><span>{{ post.date | date: "%Y-%m-%d" }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>

<h3>ページ</h3>
<ul class="posts">
	<li><a href="/jirorian/">ラーメン二郎マップ</a> -- お近くの二郎をお探しの際に。</li>
	<li><a href="/cigarette/">世界のたばこレビュー</a> -- ぺけみさおの吸ったたばこをレビューしていきます。</li>
</ul>

<h3>プロジェクト</h3>

- [x2ch](https://github.com/xmisao/x2ch) -- Rubyで簡単に2chへアクセスするためのライブラリ

  
