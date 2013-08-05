---
layout: default
title: タグ一覧
---

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
