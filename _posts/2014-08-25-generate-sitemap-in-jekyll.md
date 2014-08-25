---
layout: blog
title: jekyllでサイトマップ(sitemap.xml)を生成する
tag: jekyll
---

# jekyllでサイトマップ(sitemap.xml)を生成する

SEOを目的として、jekyllでsitemap.xmlを生成する方法についてまとめる。
jekyllでsitemap.xmlを出力するには、Sitemap.xml Generatorプラグインを使う方法と、プラグインを使わず自力でsitemap.xmlを生成する方法がある。

## Sitemap.xml Generatorプラグインを使う方法

Sitemap.xml Generatorはsitemap.xmlを出力するためのjekyllプラグインだ。
以下からダウンロードできる。

- [Jekyll Plugin: Sitemap.xml Generator](https://github.com/kinnetica/jekyll-plugins)

`sitemap_generator.rb`をjekyllの`plugins`ディレクトリ以下に配置する。

サイトの設定ファイル`_config.yaml`に以下のように設定をする。

~~~~yaml
url: "http://example.com/"

sitemap:
    file: "/sitemap.xml"
    exclude:
        - "/atom.xml"
        - "/feed.xml"
        - "/feed/index.xml"
    include_posts:
        - "/index.html"
    change_frequency_name: "monthly"
    priority_name: "0.5"
~~~~

`_config.yaml`での設定についてソースをチラ見するなどして得た知見を書いておく。

`url:`にはサイトを公開するURLを設定する。
この値はsitemap.xml中のURLの出力に利用される。

`sitemap: file:`にはsitemap.xmlの出力先のパスを設定する。

`sitemap: exclude:`にはsitemap.xmlには含めたくないファイルのリストを指定する。
一般的にはRSSフィードのパスなどを指定する。

`sitemap: include_posts:`にはポストの一覧が含まれるページのパスを指定する。
このオプションは一見して意味がわからないので、ソースを読んでの解釈になる。
通常Sitemap.xml Generatorは、sitemap.xml中でページの更新日時を示す`lastmod`の値に、ファイルのタイムスタンプ(`mtime`)を使用する。
しかし、ここで指定したパスについては、`lastmod`の値がサイト中で最も新しいページと同じになる。
ポストの一覧のページは、ページそのものの`mtime`より、各ポストの中で最も新しい時刻を採用する方が適切なので、このオプションが用意されているのだろう。

`sitemap: change_frequency_name:`はsitemap.xml中の更新頻度(`changefreq`)のデフォルト値を指定する。
有効な値は`always`, `hourly`, `daily`, `weekly`, `monthly`, `yearly`, `never`のいずれかである。

`sitemap: priority_name:`はsitemap.xml中の優先度(`priority`)のデフォルト値を指定する。
有効な値は`0.0`から`1.0`までの数値である。

`changefreq`と`priority`については、各ページで個別の値をYAML Front Matterで設定することができる。
あるページだけ`changefreq`を`daily`に、`priority`を`0.8`に設定するYAML Front Matterの例は以下である。

~~~~yaml
sitemap:
  change_frequency_name: "daily"
  priority_name: "0.8"
~~~~

長くなったが、このプラグインを導入した状態で`jekyll build`すると設定ファイルの`sitemap: file:`で指定したパスにサイトマップが出力されるようになる。

## 自力でsitemap.xmlを生成する方法

プラグインを使うよりお手軽なのは、sitemap.xmlを他のページと同じように自力で生成してしまう方法である。
プラグインが使えないjekyll環境でも使うことができるのがメリットだ。

次のページを参考にした。

- [SEO with Jekyll](http://jethrokuan.github.io/2013/12/20/SEO-with-Jekyll.html)

以下を`sitemap.xml`として配置する。

~~~~xml
{% raw %}
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>http://example.com/</loc>
    <lastmod>{{ site.time | date_to_xmlschema }}</lastmod>
    <changefreq>weekly</changefreq>
    <priority>1.0</priority>
  </url>
  {% for post in site.posts %}
    <url>
      <loc>http://example.com{{ post.url }}</loc>
      {% if post.lastmod == null %}
        <lastmod>{{ post.date | date_to_xmlschema }}</lastmod>
      {% else %}
        <lastmod>{{ post.lastmod | date_to_xmlschema }}</lastmod>
      {% endif %}
      <changefreq>monthly</changefreq>
      <priority>0.5</priority>
    </url>
  {% endfor %}
  {% for page in site.pages %}
  <url>
    <loc>http://example.com{{ page.url }}</loc>
    {% if page.sitemap.lastmod %}
      <lastmod>{{ page.sitemap.lastmod | date: "%Y-%m-%d" }}</lastmod>
    {% elsif page.lastmod %}
      <lastmod>{{ page.lastmod | date: "%Y-%m-%d" }}</lastmod>
    {% elsif page.date %}
      <lastmod>{{ page.date | date: "%Y-%m-%d" }}</lastmod>
    {% else %}
      <lastmod>{{ site.time | date: "%Y-%m-%d" }}</lastmod>
    {% endif %}
    {% if page.sitemap.changefreq %}
      <changefreq>{{ page.sitemap.changefreq }}</changefreq>
    {% else %}
      <changefreq>monthly</changefreq>
    {% endif %}
    {% if page.sitemap.priority %}
      <priority>{{ page.sitemap.priority }}</priority>
    {% else %}
      <priority>0.3</priority>
    {% endif %}
  </url>
  {% endfor %}
</urlset>
{% endraw %}
~~~~

`http://example.com/`は自分のサイトのURLに置き換える。
また`priority`や`changefreq`のデフォルト値も必要に応じて書き換えておくと良いだろう。
