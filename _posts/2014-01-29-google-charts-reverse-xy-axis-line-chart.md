---
layout: blog
title: Google Chartsで逆方向のX/Y軸を描画する方法
tag: ['javascript', 'google_charts']
---

# Google Chartsで逆方向のX/Y軸を描画する方法

![Reverse X/Y Axis Line Chart]({{ site.url }}/assets/2014_01_29_reverse_xy_axis_sample.png)

[BestGems.org](http://bestgems.org/)を作る上で知ったGoogle Chartsの使い方 その2。
順位などの折れ線グラフは値が小さい方を上にした方が望ましい。
Google Chartsでは折れ線グラフの軸の方向を`vAxis.direction`または`hAxis.direction`オプションで設定できる。
これらのオプションの値を`-1`にしてやると、X軸またはY軸が逆方向に描画されるようになる。
冒頭の画像は以下のサンプルコードで描画したものだ。
本来A, B, C, DとなるX軸はD, C, B, Aと逆順に。
Y軸はより値の小さい方が上に描画されるようになっている。

~~~~
<html>
  <head>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
      google.load("visualization", "1", {packages:["corechart"]});
      google.setOnLoadCallback(drawChart);
      function drawChart() {
        var data = google.visualization.arrayToDataTable([
          ['x', 'Rank'],
          ['A',      1],
          ['B',      3],
          ['C',      2],
          ['D',      4]
        ]);

        var options = {
          title: 'Reverse X/Y Axis Sample',
          vAxis: {direction:-1},
          hAxis: {direction:-1} 
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
