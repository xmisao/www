---
layout: blog
title: Twitter Bootstrapのcontainer、row、col(span)の正しい使い方
tag: css
---

# Twitter Bootstrapのcontainer、row、col(span)の正しい使い方

![Bootstrap Tips]({{ site.url }}/assets/2013_10_20_bootstrap_container_tips.jpg)

Twitter Bootstrap 3.0.0のcontainer、row、col(Bootstrap 2.xならspan)クラスの使い方を説明する。

## 1. containerは中身をセンタリングし幅を固定する

containerは中身を画面の中央に幅固定するクラスだ。Bootstrapの枠組みを使うのであれば、2.で述べる場合を除いて、Webページのほとんどの内容をこの内部に書くことになるだろう。

~~~~
<div class="container">
	container
</div>
~~~~

containerはWebページの中に複数個作っても全く構わない。また3.で詳しく述べるが、グリッドシステムを使わなくて良いのなら、rowやcolクラスは不要だ。container直下に内容を書いてしまって構わない。

## 2. containerより幅広の要素はcontainerを囲うように書く

ヘッダやフッタなど、containerの幅を超える要素を作りたければ、containerを内部に囲ってしまえば良い。こうするとconteinr内部のコンテンツと、ヘッダやフッタの中身の開始位置が揃って綺麗にレイアウトできる。

1.で述べたようにcontainerはセンタリングと幅固定をするだけのクラスなので、Bootstrapを使うにしても特別視しすぎない事が大切だ。

~~~~
<div>
	div
	<div class="container">
		container
	</div>
</div>
~~~~

## 3. container -> row -> col -> row -> colと入れ子にする

Bootstrapのグリッドシステムで複雑な段組をするのなら、以下のようにcontainer -> row -> col -> row -> colの入れ子を作ってやれば良い。rowが何段目であっても、配下のcolの幅の合計は12グリッドにする。

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

ポイントは、コンテンツはcontainerかcolクラスの内部に記述するようにし、rowクラスの内部にはコンテンツを書いてはいけないことだ。

というのも、Bootstrapのグリッドシステムは、containerクラスが確保したパディングを、rowクラスがネガティブマージンで打ち消すことで、要素の始点が整列するように作られている。このため、rowの下に直接何かを書くと、左に少しずれてしまうのだ。
