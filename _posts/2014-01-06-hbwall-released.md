---
layout: blog
title: はてブが画面を埋め尽くす! ぼくのかんがえたさいきょうのホッテントリ一覧ページ はてなブックマーク ウォールβ
tag: web hbwall
---

# はてブが画面を埋め尽くす! ぼくのかんがえたさいきょうのホッテントリ一覧ページ はてなブックマーク ウォールβ

![はてなブックマーク ウォールβ]({{ site.url }}/assets/2014_01_06_hbwall.jpg)

正月休みで作った。

はてなブックマーク ウォールβ
http://hbwall.xmisao.com/

なんだかんだ言ってもはてなブックマーク(以下、はてブ)は国内で最大のネット情報源だ。
私のような情報中毒者にとって、はてブのホッテントリは非常に重要で、はてブのホッテントリ一覧をチェックすることが日課になっている。
しかし、はてブのホッテントリ一覧ページに対し、以前から私は以下の不満を感じていた。

1. 固定幅のレイアウトでFullHDを超える高解像度なディスプレイではスペースが無駄になり情報の密度も低い
2. カテゴリが細分化されていてすべてのホッテントリをチェックするには複数ページをブラウズしないといけない
3. 逐次更新されているので1日にホッテントリ化したすべての記事を網羅的にチェックすることができない
4. Windowsで表示するとMSゴシックで表示されてフォントが汚く感じる

このような不満を解消するにはRSSリーダを使う事も考えられるが、ふつうRSSリーダではブックマーク数を表示することはできない。
はてブにおいてブックマーク数はエントリの重要度を示す指標であり、それを活用できないことは非常に痛い。
このため結局はてブのRSSを購読したところでRSSリーダは情報の洪水で役立たずとなり、はてブのトップページを見るはめになるのだ。

そこで、私は上記の不満点を解消して、自分用のホッテントリ一覧ページを作ることにした。
それが、ぼくのかんがえたさいきょうのホッテントリ一覧ページ、はてなブックマーク ウォールβである。
はてなブックマーク ウォールβを作るにあたり、不満点に対してそれぞれ以下の対策を行った。

1. 動的グリッドレイアウトによるレスポンシブなデザインを採用、画面いっぱいにホッテントリが表示されるようにした
2. すべてのカテゴリを統合して1ページにまとめた、エントリはブックマーク数に応じた大きさで表示され、カテゴリは色で区別できるようにした
3. ホッテントリのクロールは毎時行うが、更新は朝刊・夕刊という形で1日に2回としてその日の全ホッテントリをまとめて表示するようにした
4. M+ FONTSをWebフォント化して適用し、あらゆる環境でM+ FONTSを使ってホッテントリを表示できるようにした

基本的には全体をざっと眺めて、気になるエントリはブラウザの機能でバックグラウンドで開いておき、後からまとめ読みする使い方を想定している。
このページが似たような不満を持つ人の役に立てばうれしい。