---
layout: blog
title: Rubyからaws-sdkを使ってCloudWatchのメトリックス一覧を取得する
tag:
---

# Rubyからaws-sdkを使ってCloudWatchのメトリックス一覧を取得する

CloudWatchのメトリックス一覧はListMetrics APIで取得することができる。
aws-sdkを使ってCloudWatchのメトリックス一覧を取得するには以下のようにする。

~~~~ruby
require 'aws-sdk'

AWS.config(:access_key_id => 'YOUR_ACCESS_KEY',
           :secret_access_key => 'YOUR_SECRET_KEY',
           :region => 'YOUR_REGION')

metrics = AWS::CloudWatch::MetricCollection.new()
metrics.each{|metric|
  p metric
}
~~~~

結果は以下のようになる。

~~~~
...
<AWS::CloudWatch::Metric namespace:AWS/EC2 metric_name:CPUUtilization dimensions:[{:name=>"InstanceId", :value=>"i-12345678"}]>
<AWS::CloudWatch::Metric namespace:AWS/EBS metric_name:VolumeTotalWriteTime dimensions:[{:name=>"VolumeId", :value=>"vol-23456789"}]>
<AWS::CloudWatch::Metric namespace:AWS/EC2 metric_name:DiskReadBytes dimensions:[{:name=>"InstanceId", :value=>"i-34567890"}]>
~~~~

メトリックス一覧は`filter`によりフィルタすることが可能である。
`filter`にはフィルタ対象の属性と値を与える。

以下はネームスペースが`AWS/EBS`のメトリックス一覧を取得する。

~~~~ruby
metrics = AWS::CloudWatch::MetricCollection.new()
metrics.filter('namespace', 'AWS/EBS').each{|metric|
  p metric
}
~~~~

以下はメトリック名が`CPUUtilization`のメトリックス一覧を取得する。

~~~~ruby
metrics = AWS::CloudWatch::MetricCollection.new()
metrics.filter('metric_name', 'CPUUtilization').each{|metric|
  p metric
}
~~~~

以下はディメンションによるフィルタの例である。
`InstanceId`が`i-12345678`のメトリックス一覧だけを取得する。

~~~~ruby
metrics = AWS::CloudWatch::MetricCollection.new()
metrics.filter('dimention', [{:name => 'InstanceId'}, {:value => 'i-12345678'}]).each{|metric|
  p metric
}
~~~~

ネームスペース、メトリック名、ディメンションによるフィルタは`with_*`メソッドでも行える。

~~~~ruby
metrics = AWS::CloudWatch::MetricCollection.new()
metrics.with_namespace('AWS/EBS')
metrics.with_metric_name('CPUUtilization')
metircs.with_dimention([{:name => 'InstanceId'}, {:value => 'i-12345678'}])
~~~~

- 参考
  - [ListMetrics - Amazon CloudWatch](http://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_ListMetrics.html)
  - [Class: AWS::CloudWatch::MetricCollection ](http://docs.aws.amazon.com/AWSRubySDK/latest/AWS/CloudWatch/MetricCollection.html)
