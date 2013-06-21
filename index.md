---
layout: default
---
[ぺけみさお](/about.html)(xmisao)の記録。

# エントリ
<ul class="posts">
  {% for post in site.posts %}
    <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>

# ページ
<ul class="posts">
	<li><a href="/jirorian/">ラーメン二郎マップ</a> -- お近くの二郎をお探しの際に。</li>
</ul>

# プロジェクト

- [x2ch](https://github.com/xmisao/x2ch) -- Rubyで簡単に2chへアクセスするためのライブラリ

  
