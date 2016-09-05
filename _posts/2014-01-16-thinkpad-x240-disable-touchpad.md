---
layout: blog
title: ThinkPad X240のタッチパッドを無効化する設定(Debian Jessie)
tag: ['linux', 'thinkpad']
---



最近のThinkPadは、タッチパッドがクリック式になっており、独立していた左、中央、右のボタンが無くなってしまった。
誰のせいとは言わないが、こんな馬鹿げたインタフェースが流行するのは、絶対に林檎マークのあいつのせいである。

私はポインタの移動にはトラックポイントしか使わないので、タッチパッドでポインタが移動するのは邪魔なだけだ。しかも、Debianでは中クリックと右クリックのエリアがデフォルトでは認識されず、すべて左クリックになってしまう。

少し調べたところ左・中央・右クリックの機能を生かしつつ、タッチパッドを無効化する設定を見つけたので紹介する。

- [How to use trackpoint but keep touchpad disabled on Lenovo ThinkPad e531](http://askubuntu.com/questions/370505/how-to-use-trackpoint-but-keep-touchpad-disabled-on-lenovo-thinkpad-e531)

1. `/usr/share/X11/xorg.conf.d/50-synaptics.conf`を編集する
2. `Identifier "Default clickpad buttons"`を含む`Section "InputClass"`を探す
3. `SoftButtonAreas`オプションの値を`64% 0 1 42% 36% 64% 1 42%`に変更する
4. `AreaBottomEdge`オプションの行を有効化し、値を"1"とする。

編集後の`InputClass`セクションの内容を以下に示す。

~~~~
Section "InputClass"
    Identifier "Default clickpad buttons"
    MatchDriver "synaptics"
    Option "SoftButtonAreas" "64% 0 1 42% 36% 64% 1 42%"
    Option "AreaBottomEdge" "1"
EndSection
~~~~

以上でXを再起動すれば左・中央・右クリックが可能になり、タッチパッドによるカーソルの移動は無効化される。

ただ、この設定を行なっても中クリックしながらトラックポイントを操作してもスクロールにならない問題がある。
この操作、とても良く使っていたのだが、何とかならないものだろうか…。
