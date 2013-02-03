---
layout: default
title: error
---
このページは表示できません。
<a href="{{ root }}/">トップページ</a>へどうぞ。

# エントリ
<ul class="posts">
  {% for post in site.posts %}
    <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>
