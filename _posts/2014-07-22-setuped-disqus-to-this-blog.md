---
layout: blog
title: このブログにDIDQUSのコメント欄を設置した / JekyllでDISCUSを設置する方法
tag: ['dicqus', 'jekyll']
---



DIDQUSは中央集権型のコメント蘭を提供するWebサービスだ。
コメント機能を持たないブログなどに、コメント欄を設置することができる。
Jekyllは静的サイトのため、DISQUSは非常に役に立つ。

このエントリでは、DISCUSへの登録と、Jekyllのlayoutの書き方を紹介する。

# DISQUSへの登録

以下のページにアクセスする。

- [https://disqus.com/}(https://disqus.com/)

![Page1]({{ site.url }}/assets/2014_07_22_disqus_1.jpg)

右上にあるLog inというリンクから登録画面に進む。

![Page2]({{ site.url }}/assets/2014_07_22_disqus_2.jpg)

DISQUSはFacebook、Twitter、Googleアカウントで使用可能だ。
今回はこれらは利用せず、DISQUSに直接ユーザ登録する。

フォームにメールアドレスとパスワードを入力し、Create an Accountをクリックするとアカウントを作成できる。

メールが送付されるので、Verificationすること。

# サイトの登録

トップページに戻されるので、Add Disqus to Your Siteというリンクをクリックする。

![Page3]({{ site.url }}/assets/2014_07_22_disqus_3.jpg)

すると以下のページが表示される。

![Page4]({{ site.url }}/assets/2014_07_22_disqus_4.jpg)

- サイト名
- DISQUSのURL
- カテゴリ

を入力してFinish registrationを実行する。

# コメント欄の設置

Choose your platform画面に遷移する。

![Page5]({{ site.url }}/assets/2014_07_22_disqus_5.jpg)

この画面ではプラットフォーム毎にDISQUSを設置する方法が説明されている。

Word Pressなどでは、既に用意されたテンプレートが利用できるようだ。

Jekyllは選択肢に無いのでUniversal Codeを選択する。
このUniversal Codeというのはちょっとわかりにくい気がする。
最初意味がわからなかった。

コードスニペットが表示されるのでこのコードをコメント蘭を表示したい場所に埋め込めば設定は完了。
コードスニペットの例は以下である。なおdisqus_shortnameは私のDISQUS URLであるwwwxmisaocomとなっている。

~~~~html
<div id="disqus_thread"></div>
    <script type="text/javascript">
        /* * * CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE * * */
        var disqus_shortname = 'animedbxmisaocom'; // required: replace example with your forum shortname

        /* * * DON'T EDIT BELOW THIS LINE * * */
        (function() {
            var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
            dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
            (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
        })();
    </script>
    <noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
    <a href="http://disqus.com" class="dsq-brlink">comments powered by <span class="logo-disqus">Disqus</span></a>
~~~~

# JellyでDISQUSをいい感じで使用する

Jekyllではページごとに変数を設定できる。
ヘルプで[変数によりDISQUSコメント蘭を表示するかを切り替える実装](https://help.disqus.com/customer/portal/articles/472138-jekyll-installation-instructions)を見つけた。

ページのヘッダでは以下のように設定をする。
`comments:`がコメント欄の表示・非表示を切り替えるフラグである。

~~~~
---
layout: default
comments: true
---
~~~~

レイアウトでは先ほどのコードスニペットを`% if page.comments %`と`% endif %`で囲むようにする。

~~~~html
{% raw %}
{% if page.comments %}
<div id="disqus_thread"></div>
    <script type="text/javascript">
        /* * * CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE * * */
        var disqus_shortname = 'animedbxmisaocom'; // required: replace example with your forum shortname

        /* * * DON'T EDIT BELOW THIS LINE * * */
        (function() {
            var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
            dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
            (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
        })();
    </script>
    <noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
    <a href="http://disqus.com" class="dsq-brlink">comments powered by <span class="logo-disqus">Disqus</span></a>
{% endif %}
{% endraw %}
~~~~

こうすることで`page.comments`変数が`true`の場合だけコメント欄を表示するようにできる。
