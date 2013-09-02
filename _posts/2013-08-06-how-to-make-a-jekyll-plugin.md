---
layout: blog
title: jekyllプラグインの作り方 ジェネレータ編
tag: jekyll
---

# jekyllプラグインの作り方 ジェネレータ編

jekyllはプラグインを使って自由に機能を追加することができる。
このエントリーでは、自動的にページを生成するジェネレータという種類のプラグインを作ってみることにする。

## Hello, World!

まずHello, World!というページを作成するプラグインを作ってみよう。_pluginsディレクトリを作成し、helloworld.rbという名前で、以下の内容を記述する。

{% highlight ruby %}
module Jekyll
	class HelloWorldPage < Page
		def initialize(site, base, dir)
			@site, @base, @dir = site, base, dir
			@name = 'helloworld.html'

			self.process(@name)
			self.content = '<html><body>Hello, World!</body></html>'
			self.data = {}
		end
	end

	class HelloWorldGenerator < Generator
		safe true

		def generate(site)
			site.pages << HelloWorldPage.new(site, site.source, '/')
		end
	end
end
{% endhighlight %}

jekyllは、サイト生成時にすべてのGeneratorのサブクラスを探し、generateメソッドを実行する。通常はgenerateメソッドにサイトにページを追加する処理を記述する。

このソースではHelloWorldGeneratorのgenerateが実行される。
generateではHelloWorldPageインスタンスを作成し、サイトのページとして追加している。

HelloWorldPageクラスはHello, World!とだけ書かれたページを表すクラスとしよう。
コンストラクタの処理でページの内容を生成する。
インスタンス変数への代入とprocessメソッドの呼び出しは、最低限必要なのでおまじないと考えておこう。
続いて変数contentに表示する内容を書く。内容にはLiquidテンプレートが使用できる。この例では直書きしたHTMLがそのまま出力内容になる。
dataは本来、ページのYAMLヘッダをパースしたハッシュを保持する変数だ。nilだと生成時にエラーが出るので、空のハッシュを作ってやる。

このプラグインを保存して、jekyll buildすればサイトのルートディレクトリ直下にhelloworld.htmlが生成されるようになる。

## タグ一覧

Hello, World!の出力では全くジェネレータを作る意味がないので、今度はサイトのタグ毎にエントリーを一覧するページを生成するプラグインを作ろう。

このプラグインでは例えばtag1, tag2, tag3というタグがあったとして、以下のようなページを生成することにする。各HTMLファイルでは、そのタグを含むすべてのエントリーを一覧する。

    /tags/tag1/index.html
    /tags/tag2/index.html
    /tags/tag3/index.html

ソースコードは以下のとおり。これを_pulgins/tagpage.rbとして保存する。

    module Jekyll
    	class TagPage < Page
    		def initialize(site, base, dir, tag)
    			@site, @base, @dir = site, base, dir
    			@name = 'index.html'
    
    
    			self.process(@name)
    			raise 'name is null' unless @name
    			self.read_yaml(File.join(base, '_layouts'), 'tagpage.html')
    			self.data['title'] = "Entries of #{tag}"
    			self.data['posts'] = site.tags[tag]
    			self.data['tag'] = tag
    		end
    	end
    
    	class TagPageGenerator < Generator
    		safe true
    
    		def generate(site)
    			site.tags.keys.each do |tag|
    				site.pages << TagPage.new(site, site.source, File.join('tags', tag), tag)
    			end
    		end
    	end
    end

ジェネレータの実装TagPageGeneratorクラスのgenerateメソッドは、サイトの全タグをなめて個々のタグのTagPageオブジェクトを生成するようにする。

タグのページを表すTagPageクラスは、タグを追加でコンストラクタの引数に取り、そのタグに対するページを出力する。

read_yamlメソッドは、パスとファイル名を引数にとって、それをレイアウトファイルとして解釈し、先ほどは手書きしたdataとcontentの2変数を初期化するメソッドだ。さらにページに表示するタイトルと、ページ中に列挙するポストをdateに追加している。

続いて、レイアウトファイルとして_layouts以下にtagpage.htmlというレイアウトファイルを作ろう。内容は以下のように、渡されたポストの一覧を作るLiquidテンプレートとする。

{% raw %}
    <html>
    <title>\{\{ page.title \}\}</title>
    <body>
    <ul>
    {% for post in page.posts %}
    <li>{{ post.date }} &raquo; {{ post.title }}</li>
    {% endfor %}
    </ul>
    </body>
    </html>
{% endraw %}

あとは適当にタグをつけたページを作成し、jekyll buildするとタグの一覧ページがサイトのtags以下に出力される。
