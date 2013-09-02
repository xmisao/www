---
layout: blog
title: LinuxでCDをリッピングするならabcdeを使おう
tag: linux
---

# LinuxでCDをリッピングするならabcdeを使おう

音楽を楽しむならもはやリッピングが欠かせない。私はこれまでLinuxでCDをリッピングするのに[grip](http://sourceforge.net/projects/grip/)を使っていたが、開発が停滞しsqueeze以降ではdebianのリポジトリには含まれなくなってしまった。代わりのツールを探していたらabcdeというソフトがとても手に馴染んだので紹介する。

abcdeはコマンドラインで動作するリッピングツールだが、非常にパワフルだ。なおabcdeといういいかげんなネーミングは、A Better CD Encoderの頭文字をとったものらしい。

debianではaptでインストールできる。

    apt-get install abcde

abcdeには多数のオプションがあるが、単にリッピングするだけならCDをドライブに挿入し、abcdeコマンドを実行すれば良い。

    abcde

途中、対話的にCDDBのデータを編集するか、複数アーティストによるCDか聞かれる。普通はどちらもnを入力してやれば良いだろう。

    Grabbing entire CD - tracks: 01 02 03 04 05 06 07 08 09 10 11
    Retrieving 1 CDDB match...done.
    ---- Jazztronik / 七色 ----
    1: 七色
    2: 鳳凰 - PHOENIX
    3: Arabesque
    4: Magic Lady (Interlude)
    5: Don't hold in your tears
    6: Nana
    7: Sky Fallin'
    8: Someday (Etude For The Right)
    9: 影
    10: SAMURAI - 侍 (Album Version)
    11: Walk into the Memory

Edit selected CDDB data? [y/n] (n): n
Is the CD multi-artist [y/N]? n

あとは自動的にCDをリッピングし、CDのタイトルのディレクトリ以下に、CDDBから曲名やアーティストの情報をタグ付けしたoggファイルを出力してくれる。

オプションで出力形式をmp3にすることや、高いビットレートでエンコードするように指示することもできる。以下はその例。

    abcde -o mp3 -q high

他にも多数のオプションがあり、/etc/abcde.confや~/.abcde.confに従って規定の設定でエンコードさせることもできる。詳しくはmanを参照して自分の使い方を見つけよう。

    man abcde
