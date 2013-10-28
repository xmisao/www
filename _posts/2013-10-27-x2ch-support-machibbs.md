---
layout: blog
title: x2ch 0.9.2リリース、まちＢＢＳに対応
tag: x2ch
---

# x2ch 0.9.2リリース、まちＢＢＳに対応

2chのダウンロード＆パーサライブラリ、x2chの0.9.2をリリースした。
0.9.1から0.9.2の主な変更点はまちＢＢＳへの対応だ。

まちＢＢＳは2chとSubject.txtやDATファイルの構造が違っており、こまで対応できていなかった。
今回はSubjext.txtとDATファイルのパーサを、2chとまちＢＢＳの両方に対応させる変更を行い、まちＢＢＳをサポートした。

以下のようにまちＢＢＳも2chのカテゴリの1つとして扱える。

~~~~
require 'x2ch'
include X2CH

bbs = Bbs.load
thread = bbs['まちＢＢＳ']['神奈川'].threads.first
p thread

thread.each{|post|
        p post
}
~~~~

~~~~
#<X2CH::Thread:0x0000000285bdd8 @url="http://kanto.machi.to/kana/", @dat="1376197077.cgi", @name="告知スレ", @num=19>
#<X2CH::Post:0x00000002b90300 @name="SABERTIGER@神奈川φ", @mail="", @metadata="2013/08/11(日) 13:57:57 ID:Lv1SQsDg", @body="運営からの告知スレです。<br><br>トップページにも報告しますが、専ブラユーザーが多くて予想以上に<br>見てない方が多いのでルールスレッド（常時１番スレ）に設定します。<br>キャップ持ち以外は書き込めません。">
#<X2CH::Post:0x00000002b90120 @name="SABERTIGER@神奈川φ", @mail="", @metadata="2013/08/11(日) 14:02:52 ID:Lv1SQsDg", @body="8/18にdat落ちスレを700まで処理します。<br>重要スレなどありましたら早めに保全処理など行ってください。">
#<X2CH::Post:0x00000002b990b8 @name="zenzen", @mail="", @metadata="2013/08/12(月) 18:52:52 ID:dMd1VY1Q", @body="神奈川の気象情報２７<br>http://kanto.machi.to/bbs/read.cgi/kana/1376301133/<br><br>New Step！">
~~~~
