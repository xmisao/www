---
layout: blog
title: Debian Jessieで複数バージョンのRubyをインストールしalternativesで切り替える
tag: ['debian', 'ruby']
---

# Debian Jessieで複数バージョンのRubyをインストールしalternativesで切り替える

## はじめに

このエントリは、Rubyのバージョンを切り替えられるようにする設定を例に、alternativesの使い方をまとめたメモです。

Debian Wheezyだと何もせずにRubyはalternativesで管理してくれていた気がするのですが、手元のJessieの環境だとalternativesで管理されていなかったので、自分で管理対象に追加しました。
Jessieで変わったのか、私が何かのはずみでこうしてしまったのかは、確かめていません。

## alternativesの概要

Debian等のディストリビューションでは、例えばバージョン違いのRubyのように、似たようなパッケージを混在してインストールすることが可能です。
そのようなパッケージのファイルを候補として登録して管理しておき、デフォルトで使用するファイルを切り替えられるようにする仕組みが、alternativesシステムです。
alternativesの仕組みは、ユーザの設定に基づいて、シンボリックリンクの参照先を適切なファイルに張り替えることで実現されています。
シンプルな仕組みですが、裏を返せば、それ以上賢くはないです。

Debian Jessieでは、alternativesを使用していない場合、`/usr/bin/ruby`はシンボリックリンクで、同じディレクトリにあるRubyの実行ファイル`/usr/bin/ruby2.1`を参照します。

~~~~
/usr/bin/ruby -> /usr/bin/ruby2.1
~~~~

これをalternativesで`/usr/bin/ruby`を管理するように設定すると、シンボリックリンクの参照関係は以下のように`/etc/alternatives`以下のリンクを経由するようになります。

~~~~
/usr/bin/ruby -> /etc/alternatives/ruby -> /usr/bin/ruby2.1
~~~~

alternativesは、ユーザが指定した候補に応じて`/etc/alternatives`のシンボリックリンクの参照先を張り替えて、別のファイル(例えば違うバージョンのRuby)をシステムのデフォルトとして使用できるようになります。

## alternativesの管理対象の確認

Debianでalternativesで管理されているかは`/var/lib/dpkg/alternatives`以下の設定ファイルを見ればわかります。
以下のようにファイル一覧を表示し、`ruby`が無ければalternativesで管理されていません。
本当はコマンドで一覧できれば良いと思うのですが、`update-alternatives`コマンドに、一覧を表示するオプションは無いようです。

~~~~
ls /var/lib/dpkg/alternatives
~~~~

## 管理対象とするファイルの調査

複数のバージョンのRubyを切り替えて使用できるようにします。
以下では実行ファイルのみを対象としますが、本来は`man`の参照先等も切り替える必要があります。
手間ですし実害は無いと思いますので、今回はコマンドに的を絞って説明します。

`ruby`コマンドを切り替えたら、普通は`gem`など他のRubyパッケージのコマンドも切り替わらないと困ります。
下準備としてRubyをalternativesで管理するにあたって、まず参照先を変更する必要があるコマンドを洗い出します。

`dpkg -L`を使用して`/usr/bin`以下のファイルを調べます。
調査対象はDebianのRubyパッケージの親玉である`ruby`パッケージです。
以下のような結果が得られますので、ここで一覧されたファイルを、バージョン毎のシンボリックリンクに張り替えるように、alternativesを設定します。

~~~~
dpkg -L ruby | grep /usr/bin/
~~~~

~~~~
/usr/bin/erb
/usr/bin/testrb
/usr/bin/irb
/usr/bin/rdoc
/usr/bin/gem
/usr/bin/ruby
/usr/bin/ri
~~~~

## alternativesの管理対象の追加

alternativesの管理に追加するには`update-alternatives --install`コマンドを使用します。
書式は以下のとおりです。

~~~~
update-alternatives --install link name path priority [--slave link name path]...
~~~~

オプションについて説明します。
`link`がマスターリンク(リンク元のシンボリックリンク)で、`name`がalternativesディレクトリ上での名前、`path`がマスターリンクが参照するリンク先です。`priority`は数値で指定し、高いほど優先されます。
`--slave`はマスタに従属して切り替えるリンクを指定します。書式は同じです。`--slave`は複数指定できます。
このようにマスタとそれに従属するスレーブを、alternativesではリンクグループと呼んでいるようです。

ではRubyをalternativesに追加します。
恐ろしいことに、私の環境には、`ruby1.8`と`ruby1.9.1`と`ruby2.0`と`ruby2.1`パッケージがインストールされていますので、それぞれ候補に追加します。

なお管理対象の削除の節で後述しますが、この操作は`link`で指定したシンボリックリンク(`/usr/bin/ruby等`)を上書きしますので、完全に元の状態に戻すことはできません。事前に参照先を控えておくなどして、注意深く実行して下さい。
影響を少なくするなら、`/usr/local/bin`等の`/usr/bin`より優先順位が高いパスに、マスターリンクを作成した方が良いかも知れません。

以下はDebian JessieでRubyをalternativesの管理に追加する例です。
実行にはroot権限が必要です。

~~~~
# Ruby 2.1
update-alternatives --install /usr/bin/ruby ruby /usr/bin/ruby2.1 40 \
--slave /usr/bin/erb erb /usr/bin/erb2.1 \
--slave /usr/bin/testrb testrb /usr/bin/testrb2.1 \
--slave /usr/bin/irb irb /usr/bin/irb2.1 \
--slave /usr/bin/rdoc rdoc /usr/bin/rdoc2.1 \
--slave /usr/bin/gem gem /usr/bin/gem2.1 \
--slave /usr/bin/ri ri /usr/bin/ri2.1
~~~~

~~~~
# Ruby 2.0
update-alternatives --install /usr/bin/ruby ruby /usr/bin/ruby2.0 30 \
--slave /usr/bin/erb erb /usr/bin/erb2.0 \
--slave /usr/bin/testrb testrb /usr/bin/testrb2.0 \
--slave /usr/bin/irb irb /usr/bin/irb2.0 \
--slave /usr/bin/rdoc rdoc /usr/bin/rdoc2.0 \
--slave /usr/bin/gem gem /usr/bin/gem2.0 \
--slave /usr/bin/ri ri /usr/bin/ri2.0
~~~~

~~~~
# Ruby 1.9.1
update-alternatives --install /usr/bin/ruby ruby /usr/bin/ruby1.9.1 20 \
--slave /usr/bin/erb erb /usr/bin/erb1.9.1 \
--slave /usr/bin/testrb testrb /usr/bin/testrb1.9.1 \
--slave /usr/bin/irb irb /usr/bin/irb1.9.1 \
--slave /usr/bin/rdoc rdoc /usr/bin/rdoc1.9.1 \
--slave /usr/bin/gem gem /usr/bin/gem1.9.1 \
--slave /usr/bin/ri ri /usr/bin/ri1.9.1
~~~~

~~~~
# Ruby 1.8
update-alternatives --install /usr/bin/ruby ruby /usr/bin/ruby1.8 10 \
--slave /usr/bin/erb erb /usr/bin/erb1.8 \
--slave /usr/bin/testrb testrb /usr/bin/testrb1.8 \
--slave /usr/bin/irb irb /usr/bin/irb1.8 \
--slave /usr/bin/rdoc rdoc /usr/bin/rdoc1.8 \
--slave /usr/bin/gem gem /usr/bin/gem1.8 \
--slave /usr/bin/ri ri /usr/bin/ri1.8
~~~~

## alternativesの管理対象の確認

管理対象に追加できたか`ruby`の候補の一覧を確認します。

~~~~
update-alternatives --display ruby
~~~~

以下のように先ほど`--install`した候補の一覧が表示されます。

~~~~
ruby - auto mode
  link currently points to /usr/bin/ruby2.1
/usr/bin/ruby1.8 - priority 10
  slave erb: /usr/bin/erb1.8
  slave gem: /usr/bin/gem1.8
  slave irb: /usr/bin/irb1.8
  slave rdoc: /usr/bin/rdoc1.8
  slave ri: /usr/bin/ri1.8
  slave testrb: /usr/bin/testrb1.8
/usr/bin/ruby1.9.1 - priority 20
  slave erb: /usr/bin/erb1.9.1
  slave gem: /usr/bin/gem1.9.1
  slave irb: /usr/bin/irb1.9.1
  slave rdoc: /usr/bin/rdoc1.9.1
  slave ri: /usr/bin/ri1.9.1
  slave testrb: /usr/bin/testrb1.9.1
/usr/bin/ruby2.0 - priority 30
  slave erb: /usr/bin/erb2.0
  slave gem: /usr/bin/gem2.0
  slave irb: /usr/bin/irb2.0
  slave rdoc: /usr/bin/rdoc2.0
  slave ri: /usr/bin/ri2.0
  slave testrb: /usr/bin/testrb2.0
/usr/bin/ruby2.1 - priority 40
  slave erb: /usr/bin/erb2.1
  slave gem: /usr/bin/gem2.1
  slave irb: /usr/bin/irb2.1
  slave rdoc: /usr/bin/rdoc2.1
  slave ri: /usr/bin/ri2.1
  slave testrb: /usr/bin/testrb2.1
Current 'best' version is '/usr/bin/ruby2.1'.
~~~~

試しに`ruby -v`を実行すると2.1系のバージョンが表示されます。

~~~~
ruby 2.1.4p265 (2014-10-27) [x86_64-linux-gnu]
~~~~

## 使用するバージョンの切り替え

以上の例では優先度の最も高い`ruby2.1`が`ruby`コマンドで実行されるようになりました。

不幸にも1.8系でしか実行できないスクリプトをガリガリいじる必要があるシチュエーションに陥ったとします。
`ruby1.8`を実行するように切り替えてみましょう。

切り替えは`update-alternatives --config`コマンドで対話的に行えます。
非対話的に行うには`update-alternatives --set`を使用して下さい。
以下はインタラクションの例です。

~~~~
update-alternatives --config ruby
~~~~

~~~~
There are 4 choices for the alternative ruby (providing /usr/bin/ruby).

  Selection    Path                Priority   Status
------------------------------------------------------------
* 0            /usr/bin/ruby2.1     40        auto mode
  1            /usr/bin/ruby1.8     10        manual mode
  2            /usr/bin/ruby1.9.1   20        manual mode
  3            /usr/bin/ruby2.0     30        manual mode
  4            /usr/bin/ruby2.1     40        manual mode

Press enter to keep the current choice[*], or type selection number: 1
update-alternatives: using /usr/bin/ruby1.8 to provide /usr/bin/ruby (ruby) in manual mode
~~~~

切り替え後の`ruby -v`の結果です。

~~~~
ruby 1.8.7 (2012-02-08 patchlevel 358) [x86_64-linux]
~~~~

優先度が最も高いものに戻すには以下のように`update-alternatives --auto`します。

~~~~
update-alternatives --auto ruby
~~~~

## alternativesの管理対象の削除

管理対象から候補を削除するには`update-alternatives --remove`を使用します。
オプション指定は以下のとおりです。

~~~~
update-alternatives --remove name path
~~~~

これまでの例で候補に追加した`ruby1.8`を候補から削除するには以下のようにします。

~~~~
update-alternatives --remove ruby /usr/bin/ruby1.8
~~~~

ここで注意点があります。
削除しても、名前に対する候補が残っていれば、マスターリンクは最適な候補を参照します。
もし、名前に対する候補がすべてなくなると、マスターリンクも削除されます。
ようは`/usr/bin/ruby`も消えてしまうということです。
以下に`man`の内容を引用します。

> Remove an alternative and all of its associated slave links.  name is a name in the alternatives directory, and path is an absolute  filename to  which  name  could be linked. If name is indeed linked to path, name will be updated to point to another appropriate alternative (and the group is put back in automatic mode), or removed if there is no such alternative left.  Associated slave links will be  updated  or  removed, correspondingly.  If the link is not currently pointing to path, no links are changed; only the information about the alternative is removed.

ある管理対象のすべての候補を削除するには`update-alternatives --remove-all`が使用できます。

~~~~
update-alternatives --remove-all ruby
~~~~

## おわりに

このエントリで紹介した使い方は一例ですので、alternativesの仕組みと、`update-alternatives`の詳しい使い方は`man`を参照して下さい。

~~~~
update-alternatives man
~~~~

興味深いのは`--altdir`や`--admindir`オプションで、候補のリンクを作成する場所や、alternativesの設定ファイルの場所が指定できることでしょうか。
普通はこれらのオプションを指定せず`/etc/alternatives`と`/var/lib/dpkg/alternatives`を使用して、システム全体の切り替えに使用しますが、その気になればユーザだけでもalternativesの仕組みを使うことができます。

以上、いろいろ書きましたが、ユーザ毎にRubyのバージョンを切り替えたい場合、あるいはRubyに固有のもっと細かい制御をしたい場合は、素直にRVM等のRubyのバージョンマネージャを使用することをおすすめします。
