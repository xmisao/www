---
layout: blog
title: Rubyからaws-sdkを使ってEC2のインスタンスとEBSのボリューム一覧を取得する
tag: ['ruby', 'aws']
---



Rubyのaws-sdkの使い方。

EC2のインスタンスとEBSのボリュームは、いずれも`AWS::EC2`クラスを使って取得する。
`AWS::EC2#instances`でEC2インスタンスの一覧が、`AWS::EC2#volumes`でEBSのボリューム一覧が取得できる。

以下がEC2のインスタンスとEBSのボリュームを一覧するスクリプトの例だ。

~~~~ruby
require 'aws-sdk'

AWS.config(:access_key_id => 'YOUR_ACCESS_KEY',
           :secret_access_key => 'YOUR_SECRET_KEY',
           :region => 'YOUR_REGION')

ec2 = AWS::EC2.new

puts 'EC2 Instances:'
ec2.instances.each{|instance|
  p instance
}

puts 'EBS Volumes:'
ec2.volumes.each{|volume|
  p volume
}
~~~~

このスクリプトの実行結果は以下のようになる。

~~~~
EC2 Instances:
<AWS::EC2::Instance id:i-12345678>
<AWS::EC2::Instance id:i-23456789>
<AWS::EC2::Instance id:i-34567890>
EBS Volumes:
<AWS::EC2::Volume id:vol-12345678>
<AWS::EC2::Volume id:vol-23456789>
<AWS::EC2::Volume id:vol-34567890>
~~~~

- 参考
  - [Class: AWS::EC2 ](http://docs.aws.amazon.com/AWSRubySDK/latest/AWS/EC2.html)
