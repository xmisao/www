---
layout: blog
title: しょぼいカレンダーを使ってRubyできょう放送されるアニメの一覧を表示する
tag: ['ruby', 'anime']
---



![anime]({{ site.url }}/assets/2014_04_10_anime.png)

[しょぼいカレンダー](https://cal.syoboi.jp/)はその筋では有名なアニメ番組表サイトで、アニメの放送予定などをXMLで取得することもできる。APIと呼べるほど整理されていはいないが、サイトの[仕様が公開](https://sites.google.com/site/syobocal/spec)されており、その気になればアニメに関する様々な情報が取得可能だ。

ふとした興味からRubyでしょぼいカレンダーにアクセスするライブラリが無いのか調査したところ、[syoboi_calendar](https://github.com/r7kamura/syoboi_calendar)というgemを見つけた。ただ、しょぼいカレンダーのすべての機能を網羅しているわけでもないようなので、自分なりに少し手を動かしてみようかと考えた。

しょぼいカレンダーの最も基本的な機能は[cal_chk.php](http://cal.syoboi.jp/cal_chk.php)によるアニメの放送予定の取得である(たぶん)。手始めに、この情報を取得してきて、きょう放送される首都圏のアニメの一覧を出力するRubyスクリプト`anime.rb`を書いてみた。

このスクリプトを実行すると、現在から次の朝5時までに放送される首都圏(1都3県)の地上波のアニメをリストアップするようになっている。深夜のアニメは深夜アニメらしく時刻を表示する。冒頭の画像はそのSSである。

まだちょっと書いてみたというレベルだが、そもそもどういうAPIにすれば直感的にしょぼいカレンダーをラップできるのか?だとか、考えることが多い。
時間があればこれをベースとして、しょぼいカレンダーのすべての機能を網羅したgemを作ってみたい。時間があれば…。

~~~~
require 'open-uri'
require 'rexml/document'
require 'delegate'

module Syoboi
  module CalChk
    def get()
      xml = REXML::Document.new(open('http://cal.syoboi.jp/cal_chk.php'))

      result = Result.new

      syobocal = xml.elements['syobocal']
      result.url = syobocal.attribute("url").to_s
      result.version = syobocal.attribute("version").to_s
      result.last_update = Time.parse(syobocal.attribute("LastUpdate").to_s)
      result.spid = syobocal.attribute("SPID").to_s
      result.spname = syobocal.attribute("SPNAME").to_s

      xml.elements.each('syobocal/ProgItems/ProgItem'){|item|
        result << {
          :pid => item.attribute("PID").to_s.to_i,
          :tid => item.attribute("TID").to_s.to_i,
          :st_time => Time.parse(item.attribute("StTime").to_s),
          :ed_time => Time.parse(item.attribute("EdTime").to_s),
          :ch_name => item.attribute("ChName").to_s,
          :ch_id => item.attribute("ChID").to_s.to_i,
          :count => item.attribute("Count").to_s.to_i,
          :st_offset => item.attribute("StOffset").to_s.to_i,
          :sub_title => item.attribute("SubTitle").to_s,
          :title => item.attribute("Title").to_s,
          :prog_comment => item.attribute("ProgComment").to_s
        }
      }

      result
    end
    module_function :get

    class Result < DelegateClass(Array)
      attr_accessor :url, :version, :last_update, :spid, :spname

      def initialize
        super([])
      end
    end
  end
end

def format_time(time)
  h = time.hour
  h += 24 if h < 5
  m = time.min

  sprintf("%2d:%02d", h, m)
end

result = Syoboi::CalChk.get()

puts "これから放送されるアニメ＠首都圏\n"

result.select{|prog|
  # 現在から
  st = Time.now

  # 次の朝5時まで
  day = Time.now.hour < 5 ? Date.today : Date.today + 1
  ed = Time.new(day.year, day.month, day.day, 5)

  # 首都圏のチャンネルで放送されるアニメ
  syutoken_ch = [
    1, # NHK総合
    2, # NHK Eテレ
    3, # フジテレビ
    4, # 日本テレビ
    5, # TBS
    6, # テレビ朝日
    7, # テレビ東京
    8, # TVK
    13, # チバテレビ
    14, # テレ玉
    19, # TOKYO MX
  ]

  st < prog[:st_time] and prog[:st_time] < ed and syutoken_ch.include?(prog[:ch_id])
}.sort_by{|prog|
  prog[:st_time] # 放送開始日時で降順に並べ替え
}.each{|prog|
  puts "#{format_time(prog[:st_time])} [#{prog[:ch_name]}] #{prog[:title]} / #{prog[:sub_title]}"
}
~~~~
