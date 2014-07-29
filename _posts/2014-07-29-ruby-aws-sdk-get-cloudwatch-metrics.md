---
layout: blog
title: Rubyからaws-sdkを使ってCloudWatchのメトリックスを取得する
tag: ['aws', 'ruby']
---

# Rubyからaws-sdkを使ってCloudWatchのメトリックスを取得する

AWS SDKを使えばAWSにプログラムからアクセスできる。
Ruby向けのSDKも提供されており、RubyからAWSを自在に制御することが可能だ。
このエントリではAWS SDKの使用例としてRubyからCloudWatchのメトリックスを取得してみることにする。

Ruby向けのAWS SDKは`aws-sdk`というgemで提供されている。
以下でインストールできる。

~~~~
gem install aws-sdk
~~~~

あるEC2インスタンスの過去1日分のCPUUtilizationを5分間の平均値で取得してみよう。
下記のRubyスクリプトを記述する。

~~~~ruby
require 'aws-sdk'

AWS.config(:access_key_id => 'YOUR_ACCESS_KEY',
           :secret_access_key => 'YOUR_SECRET_KEY',
           :region => 'YOUR_REGION')

metric = AWS::CloudWatch::Metric.new('AWS/EC2', 'CPUUtilization')

result = metric.statistics(:start_time => Time.now - 24 * 60 * 60,
                           :end_time => Time.now,
                           :statistics => ['Average'],
                           :period => 300,
                           :dimensions=>[{:name=>"InstanceId", :value=>"YOUR_EC2_INSTANCE_ID"}])

result.each{|datapoint|
  p datapoint
}
~~~~

スクリプト中の次の値はそれぞれ自分の環境に合わせて書き換えること。

- `YOUR_ACCESS_KEY` -- AWSのアクセスキー
- `YOUR_SECRET_KEY` -- AWSのシークレットキー
- `YOUR_REGION` -- EC2インスタンスのリージョン 例. `ap-northeast-1`
- `YOUR_EC2_INSTANCE_ID` -- EC2インスタンスのID 例. `i-12345678`

このスクリプトを実行すると以下のような出力がされるはずだ。

~~~~
...
{:timestamp=>2014-07-28 19:38:00 UTC, :unit=>"Percent", :average=>26.666000000000004}
{:timestamp=>2014-07-28 16:23:00 UTC, :unit=>"Percent", :average=>88.95}
{:timestamp=>2014-07-29 02:38:00 UTC, :unit=>"Percent", :average=>17.002000000000002}
~~~~

確かにCloudWatchのメトリックスをRubyから取得することができた。

なお`AWS::CloudWatch::Metric.new`に指定するネームスペースとメトリックスは公式ドキュメントに一覧がある。

- [Amazon CloudWatch Namespaces, Dimensions, and Metrics Reference](http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/CW_Support_For_AWS.html)
