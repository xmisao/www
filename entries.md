---
layout: default
title: 過去のエントリ一覧
title-string: "過去のエントリ一覧"
active-tab: "posts"
---

<dl class="posts">
  {% for post in site.posts %}
  <dt>{{ post.date | date: "%Y-%m-%d" }}</dt>
  <dd>
  <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a>
  <a href="http://b.hatena.ne.jp/entry/{{ site.url }}{{ post.url }}"><img src="https://b.hatena.ne.jp/entry/image/{{ site.url }}{{ post.url }}"></a>
  </dd>
  {% endfor %}
</dl>
