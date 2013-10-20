---
layout: blog
title: Twitter Bootstrapのcontainer、row、col(span)の正しい使い方
tag: css
---

# Twitter Bootstrapのcontainer、row、col(span)の正しい使い方

![Bootstrap Tips]({{ site.url }}/assets/2013_10_20_bootstrap_container_tips.jpg)

Twitter Bootstrap 3.0.0のcontainer、row、col(Bootstrap 2.xならspan)クラスの使い方を説明する。公式サイトでも例示されているが、体系だった説明がされていないのでBootstrap初心者の役に立つはずだ。

## 1. containerは中身をセンタリングし幅を固定する

containerクラスは中身を画面の中央に幅を固定するクラスだということを理解しよう。containerクラスはBootstrapのレイアウトを使う上でルートとなるクラスである。

2.で述べるcontainerクラスより幅の広いレイアウトをする場合を除いて、Webページのほとんどの内容をcontainerクラスの内部に書くことになるだろう。

~~~~
<div class="container">
	container
</div>
~~~~

containerクラスはWebページの中に複数個作っても全く構わない。また3.で詳しく述べるが、グリッドシステムを使わなくて良いのなら、コンテンツを書くのにrowやcolクラスは不要だ。containeクラス直下にコンテンツを書いてしまって構わない。

## 2. containerより幅広の要素はcontainerを囲うように書く

ヘッダやフッタなど、containerクラスの幅を超えるレイアウトを作りたい場合がある。この場合は、containerクラスを内部に囲ってしまえば良い。

1.で述べたようにcontainerはレイアウトのルートとなるクラスではあるが、センタリングと幅固定をするだけのものに過ぎない。Bootstrapを使うにしても特別視しすぎない事が大切だ。

~~~~
<div>
	div
	<div class="container">
		container
	</div>
</div>
~~~~

## 3. container -> row -> col -> row -> colと入れ子にする

Bootstrapのグリッドシステムで複雑な段組をするのなら、以下のようにcontainer -> row -> col -> row -> colの入れ子を作ってやれば良い。rowが何段目であっても、配下のcolの幅の合計は12グリッドである。

~~~~
<div class="container">
	container
	<div class="row">
		row<br>
		<div class="col-md-6">
			Level 1: col-md-6
			<div class="row">
				row<br>
				<div class="col-md-6">
					Level 2: col-md-6
				</div>
				<div class="col-md-6">
					Level 2: col-md-6
				</div>
			</div>
		</div>
		<div class="col-md-6">
			Level 1: col-md-6
		</div>
	</div>
</div>
~~~~

ポイントは、コンテンツはcontainerクラスかcolクラスの内部に記述するようにすることだ。rowクラスの直下にはコンテンツを書いてはいけない。

というのも、Bootstrapのグリッドシステムは、(1)containerクラスがパディングを確保する。(2)rowクラスがネガティブマージンでそれを打ち消す。この組み合わせでコンテンツの始点が整列するように作られている。そのため、rowクラスの直下に何かを書くと、少し左にずれてしまうのだ。
