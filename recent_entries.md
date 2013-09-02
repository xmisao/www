---
layout: blankslate
---

<ul class="posts">
  {% for post in site.posts limit:10 %}
    <li>{{ post.date | date: "%Y-%m-%d" }} &raquo; <br><a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>
