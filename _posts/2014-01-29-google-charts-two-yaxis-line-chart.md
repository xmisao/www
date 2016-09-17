---
layout: blog
title: Google Chartsで左右2つのY軸を使った折れ線グラフを描画する方法
tag: ['javascript', 'google_charts']
---



![Two Y Axis Line Chart](/assets/2014_01_29_two_y_axis_sample.png)

[BestGems.org](http://bestgems.org/)を作る上で知ったGoogle Chartsの使い方 その1。
値が大きく異なる2系列以上の折れ線グラフを描画したい場合がある。
そのような場合は左右に別々のY軸を表示して、系列をそれぞれ別のY軸に割り当てることで、グラフを見やすくしたいものだ。
これは折れ線グラフの描画時に`series`オプションの`targetAxisIndex`を指定することで可能である。
`targetAxisIndex`の値が`0`だと左のY軸が、値が`1`だと右のY軸が使用される。
冒頭の画像は以下のサンプルコードで描画したものだ。

~~~~
<html>
  <head>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
      google.load("visualization", "1", {packages:["corechart"]});
      google.setOnLoadCallback(drawChart);
      function drawChart() {
        var data = google.visualization.arrayToDataTable([
          ['x', 'Data 1', 'Data 2'],
          ['A',    10000,      100],
          ['B',    12000,      200],
          ['C',     8000,      300],
          ['D',    10000,      400]
        ]);

        var options = {
          title: 'Two Y Axis Sample',
          series:[
              {targetAxisIndex:0}, // 第1系列は左のY軸を使用
              {targetAxisIndex:1}, // 第2系列は右のY時を使用
            ]
        };

        var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
        chart.draw(data, options);
      }
    </script>
  </head>
  <body>
    <div id="chart_div" style="width: 900px; height: 500px;"></div>
  </body>
</html>
~~~~
