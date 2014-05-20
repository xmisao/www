---
layout: default
title: エントリ一覧
---

<h3>エントリ一覧</h3>
<ul class="posts">
  {% for post in site.posts %}
    <li>
      <span>{{ post.date | date: "%Y-%m-%d" }}</span> &raquo; <a href="http://www.xmisao.com{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a>
      <a href="http://b.hatena.ne.jp/entry/http://www.xmisao.com{{ BASE_PATH }}{{ post.url }}">
      <img src="http://b.hatena.ne.jp/entry/image/http://www.xmisao.com{{ BASE_PATH }}{{ post.url }}">
      </a>
    </li>
  {% endfor %}
</ul>
