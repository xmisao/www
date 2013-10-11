---
layout: blog
title: sudoersのsecure_pathについて
tag: linux
---

# sudoersのsecure_pathについて

sudoを使う際に環境変数PATHは意外とつまづきやすい部分だ。

`env_reset`オプションが有効になっている場合(sudoのデフォルト)、sudoは実行時に各種環境変数を初期化する。PATHも例外ではなく、最小限のパスだけが指定された状態に初期化される。

そのためsudo実行時に`/sbin`, `/usr/sbin`, `/usr/local/sbin`にパスが通っていない状態になり、明らかに特権で実行できるはずのコマンドが実行できない、という状況に陥る。

解決方法は、`/etc/sudoers`で`secure_path`を設定することだ。`secure_path`が指定されていると、sudoは実行時に環境変数PATHを`secure_path`に指定されたパスで初期化する。設定を抜粋すると、以下のようにすれば意図どおりに動作するはずだ。

~~~~
Defaults	env_reset
Defaults	secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
~~~~

大抵はOSインストール時に正しく設定されているのだが、VPS等の普及で初期設定が良くわからない環境を使う機会も増えているので覚えておきたい。個人的にはS@@SesのOsukiniサーバを借りた際に、自分でパスを設定してやる必要があった。
