---
layout: blog
title: Rubyからaws-sdkを使ってアラームの一覧を取得する
tag: ['ruby', 'aws']
---



Rubyのaws-sdkの使い方。

CloudWatchのアラームは、`AWS::CloudWatch`クラスを使って取得する。`AWS::CloudWatch#alarms`でアラームの一覧が得られる。一例としてアラーム名と現在の状態を出力してみよう。

アラーム名は`AWS::CloudWatch::Alarm#alarm_name`で、現在の状態は`AWS::CloudWatch::Alarm#state_value`でそれぞれ取得できる。

~~~~ruby
require 'aws-sdk'

AWS.config(:access_key_id => 'YOUR_ACCESS_KEY',
           :secret_access_key => 'YOUR_SECRET_KEY',
           :region => 'YOUR_REGION')

cw = AWS::CloudWatch.new
cw.alarms.each do |alarm|
  p [alarm.alarm_name, alarm.state_value]
end
~~~~

このスクリプトの実行結果は以下のようになる。

~~~~
["foo", "OK"]
["bar", "ALARM"]
~~~~

なおアラームの状態変化の履歴は`AWS::CloudWatch::Alarm#history_items`で取得することができる。このメソッドで取得できる要素は`AWS::CloudWatch::AlarmHistoryItem`であるが、この要素には少し癖がある。

`AWS::CloudWatch::AlarmHistoryItem`の主だったデータは`AWS::CloudWatch::AlarmHistoryItem#history_data`で取得できるが、データがJSONで格納されているのである。

このデータにアクセスするには標準ライブラリの`json`を使って以下のようにする。

~~~~ruby
require 'json'

alarm.history_items.each{|history|
  p JSON.parse(history.history_data)
}
~~~~

以下は1件の`history_data`のパース結果の例である。

~~~~
{"version"=>"1.0", "type"=>"Create", "createdAlarm"=>{"namespace"=>"AWS/EBS", "threshold"=>1800.0, "metricName"=>"VolumeIdleTime", "period"=>3600, "dimensions"=>[{"name"=>"VolumeId", "value"=>"vol-XXXXXXXX"}], "stateValue"=>"INSUFFICIENT_DATA", "alarmName"=>"foo", "okactions"=>[], "alarmActions"=>["arn:aws:sns:ap-northeast-1:XXXXXXXXXXXX:Notify"], "actionsEnabled"=>true, "evaluationPeriods"=>1, "comparisonOperator"=>"LessThanOrEqualToThreshold", "insufficientDataActions"=>[], "alarmDescription"=>"", "statistic"=>"Sum", "alarmArn"=>"arn:aws:cloudwatch:ap-northeast-1:XXXXXXXXXXXX:alarm:foo", "alarmConfigurationUpdatedTimestamp"=>"2014-08-23T15:48:26.693+0000", "stateUpdatedTimestamp"=>"2014-08-23T15:48:26.693+0000"}}
~~~~
