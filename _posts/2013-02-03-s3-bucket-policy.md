---
layout: default
title: Amazon S3のポリシーを設定してバケットの中身をすべて公開する
---

# Amazon S3のポリシーを設定してバケットの中身をすべて公開する

静的なサイトを公開する場合など、いちいちACLを設定するのが煩わしい場合に利用できる。

まずAmazon AWSの画面からポリシーを作成する。

[http://awspolicygen.s3.amazonaws.com/policygen.html](http://awspolicygen.s3.amazonaws.com/policygen.html)

以下の項目を設定する。<bucket_name>は自分のバケット名に差し替える。

* Select Type of Policy -- S3 Bucket Policy
* Effect -- Allow
* Principal -- *
* AWS Service -- Amazon S3
* Actions -- GetObject
* Amazon Resource Name (ARN) -- arn:aws:s3:::<bucket_name>/

「Add Statement」ボタンを押して、「Generate Policy」ボタンを押すと、ポリシーが表示される。

    {
      "Id": "PolicylXXXXXXXXXXXX",
      "Statement": [
        {
          "Sid": "StmtXXXXXXXXXXXXX",
          "Action": [
            "s3:GetObject"
          ],
          "Effect": "Allow",
          "Resource": "arn:aws:s3:::<bucket_name>/*",
          "Principal": {
            "AWS": [
              "*"
            ]
          }
        }
      ]
    }

Web Consoleでバケットのプロパティを開き、「Bucket Policy Editor」で上記ポリシーをペーストすれば、バケット内の全オブジェクトが公開できる。

参考 [http://www.jppinto.com/2011/12/access-denied-to-file-amazon-s3-bucket/](http://www.jppinto.com/2011/12/access-denied-to-file-amazon-s3-bucket/)
