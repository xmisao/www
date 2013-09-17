---
layout: blog
title: jekyllプラグインの作り方 タグ編
tag: jekyll
---

# jekyllプラグインの作り方 タグ編

jekyllはプラグインを使って自由に機能を追加することができる。このエントリでは、独自のタグを作ってみることにする。jekyllのタグを作るということは、テンプレートエンジンliquidのタグを作ることとイコールだ。

## 単純なタグ

まず最も簡単なHello, World!タグを作ってみよう。
Hello, World!タグは、Hello, World!をその場に挿入するものだ。

`_plugins`ディレクトリを作成し、`helloworldtag.rb`という名前で、以下の内容を記述する。

~~~~
module Jekyll
		class HelloWorldTag < Liquid::Tag
			def render(context)
				"Hello, World!"
			end
		end
end

Liquid::Template.register_tag('helloworld', Jekyll::HelloWorldTag)
~~~~

jekyllのタグは`Liquid::Tag`を継承して作成する。必ず実装しなければならないのは、`render()`メソッドだ。`render()`メソッドは、lequidによりタグがレンダリングされる際に呼び出され、戻り値がその場に埋め込まれる。

タグの実装はこれだけだが、最後に`Liquid::Template.register_tag()`を呼んで、liquidにタグ名とそのタグを処理するクラスの対を登録をしてやる必要がある。この例ではhelloworldタグを、HelloWorldTagクラスで処理するように登録している。

このHello, World!タグの使用法は以下のとおりだ。
これで`jekyll build`すれば、文書中のhelloworldタグがHello, World!に置き換わることが確認できるだろう。

~~~~
{% raw %}{% helloworld %}{% endraw %}
~~~~

## 引数つきタグ

続いて引数を取るタグを作成してみよう。以下に示すRandomタグはランダムな整数を出力するタグだ。

~~~~
module Jekyll
		class RandomTag < Liquid::Tag
			def initialize(tag_name, markup, tokens)
				@max = markup.to_i
				super
			end

			def render(context)
				rand(@max)
			end
		end
end

Liquid::Template.register_tag('random', Jekyll::RandomTag)
~~~~

引数の受け渡しはコンストラクタで行う。第2引数の`markup`でタグに渡された文字列が受け取れるので、これを元にインスタンス変数を設定して、`render()`で読み込んで結果に反映させる。なお、コンストラクタの最後で忘れずに`super`すること。

このタグを使用する例は以下。10を引数に与えている。
これで10未満の整数がランダムに埋め込まれる。

~~~~
{% raw %}{% random 10 %}{% endraw %}
~~~~

## タグブロック

タグと同様に、独自のタグブロックを作成することもできる。以下に示すrepeatタグブロックは、タグブロックで囲んだ内容を、任意の回数繰り返して出力するタグブロックだ。

~~~~
module Jekyll
		class RepeatBlock < Liquid::Block
			def initialize(tag_name, markup, tokens)
				@repeat = markup.to_i
				@text = tokens[0]
				super
			end

			def render(context)
				result = ""
				@repeat.times{
					result << @text
				}
				result
			end
		end
end

Liquid::Template.register_tag('repeat', Jekyll::RepeatBlock)
~~~~

タグブロックは、`Liquid::Tag`の代わりに`Liquid::Block`を継承して作成する。登録の方法を含め、その他はタグと同様だ。

コンストラクタの第3引数`tokens`は良くわからない引数だ。実行させて中身を見ると、タグブロック開始以降のソースが配列で渡されるように見える。(タグブロックの中身だけが渡されるわけではない)

タグブロック内に他のタグが含まれていたり、タグブロックがネストしている場合は、自分でタグブロックの終端を判定してやる必要がある。この例では単純に0番目の要素を、タグの中身と仮定して処理している。

このrepeatタグブロックを使用する例は以下。
これでRepeat!が10回繰り返して挿入される。

~~~~
{% raw %}{% repeat 10 %}
Repeat!
{% endrepeat %}{% endraw %}
~~~~

## コンテキストの取得

これまでの例では触れなかったが、jekyllプラグインでは往々にして、jekyllコンテキストに従って出力内容を決めたい場合が考えられる。実は`render()`に渡される引数`context`からjekyllのコンテキストを取得できるようになっている。

一例として、jekyllのサイト設定で指定されたURLを取得するには、以下のような`render()`を実装してやれば良い。

~~~~
def render(context)
	site = context.registers[:site]
	config = site.config
	url = config['url']
	"some output"
end
~~~~
