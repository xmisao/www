---
layout: blog
title: Debianでロケールの問題が発生した場合の対処法
tag: linux
---



原因は良くわからないのだが、Debian SqueezeからDebian Wheezyにdis-upgradeした時あたりから、様々なコマンドで以下のエラーが発生する現象に遭遇した。ロケールが正しく設定されていないという主旨のメッセージのようだ。

~~~~
perl: warning: Setting locale failed.
perl: warning: Please check that your locale settings:
	LANGUAGE = (unset),
	LC_ALL = (unset),
	LC_CTYPE = "UTF-8",
	LANG = "en_US"
    are supported and installed on your system.
 .
locale: Cannot set LC_CTYPE to default locale: No such file or directory
locale: Cannot set LC_MESSAGES to default locale: No such file or directory
locale: Cannot set LC_ALL to default locale: No such file or directory
~~~~

いろいろと弄ったので解決した操作も特定できていないのだが、[Fixing the locale problem in Debian](http://hexample.com/2012/02/05/fixing-locale-problem-debian/)に記載されていた以下の手順を実行したら正常な状態になったように思う。手順は以下のとおりで、rootで実行すること。

~~~~
apt-get install locales
locale
locale -a
dpkg-reconfigure locales
~~~~

歯切れの悪いエントリになってしまったが、発生する原因、回復のための手順、が確認できる機会がもう1度あったら追記したい。
