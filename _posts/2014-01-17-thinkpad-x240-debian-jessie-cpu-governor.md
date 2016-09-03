---
layout: blog
title: Debian Jessieではcpufreq-set -g ondemandが失敗する?
tag: ['thinkpad', 'linux']
---



ThinkPad X240にDebian Jessieをインストールして使っているが、`cpufrequtils`パッケージをインストールしても、CPUのクロック数が変化しないことに気づいた。X240のCPUはCore i7-4600Uで定格2.1GHzだが、`/proc/cpuinfo`を確認しても常に定格の2.1GHz前後で動作している。

~~~~
$ grep MHz /proc/cpuinfo
cpu MHz         : 2100.093
cpu MHz         : 2100.621
cpu MHz         : 2099.988
cpu MHz         : 2103.152
~~~~

`cpufreq-info`で確認すると、Core i7-4600Uは0.8GHzから3.3GHzの間で動作できるはずである。`cpufrequtils`を導入するとその範囲で適度にCPUのクロック数が制御されると期待していたのだが、どうもうまく動かないようだ。そもそも`cpufreq-info`の出力からはgovernorが`powersave`と`performance`しか選択できないように見えるし、`cpufreq-set -g ondemand`しても以下のエラーで失敗する。

~~~~
# cpufreq-set -g ondemand
Error setting new values. Common errors:
- Do you have proper administration rights? (super-user?)
- Is the governor you requested available and modprobed?
- Trying to set an invalid policy?
- Trying to set a specific frequency, but userspace governor is not available,
   for example because of hardware which cannot be set to a specific frequency
   or because the userspace governor isn't loaded?
~~~~

少し調べてgovernorのモジュールをロードすれば`ondemand`が選択できるようになるかもしれないと思い、`modprobe cpufreq_ondemand`してみても状況は変わらなかった。結局、ThinkPad X240にインストールしたDebian Jessie上でCPUのクロックを適度に上下させる方法はわからなかった。

ただ試行錯誤の成果として、CPUのクロック数を最低に固定する方法と、逆にCPUのクロック数を最高に固定する方法はわかった。具体的には`cpufreq-set`でそれぞれ以下のようにすればCPUのクロック数を固定できる。

- クロック数を最低にしたい場合

~~~~
# cpufreq-set -c 0 --min 0.8GHz --max 0.8GHz
# cpufreq-set -g powersave
~~~~

- クロック数を最大にしたい場合(※これで2.1GHz、負荷がかかると3.3GHzとなる)

~~~~
# cpufreq-set -c 0 --min 3.3GHz --max 3.3GHz
# cpufreq-set -g performance
~~~~

この方法でクロック数を上下させられるということは、`cpufreqd`等を使ってクロック数を制御する設定をすれば、狙いどおりの設定が実現できるのかもしれない。とりあえず今日はここまで。

参考までに調査したURLをあげておく。

- [http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=723065](http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=723065)
- [http://forums.debian.net/viewtopic.php?f=5&t=107843](http://forums.debian.net/viewtopic.php?f=5&t=107843)
