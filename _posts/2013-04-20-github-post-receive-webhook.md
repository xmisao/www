---
layout: blog
title: githubのwebhookでpushの通知をHTTPで受信する
tag: github
---



githubはリポジトリにpushされたことを外部に通知する機能としてService Hooksを備えている。
Service Hooksの1つにwebhookがあり、pushされたことをJSONで任意のURLにHTTPでPOSTできる。

webhookの設定は、githubのリポジトリの"Settings"のページ、左のメニュー"Service Hooks"から、"WebHook URLs"を選び、URLを入力、"Update Setting"するだけで良い。

1度設定してしまえば、同じ画面で"Test Hook"ボタンをクリックすれば、即座にgithubからPOSTされ、Webhookをテストできる。
githubのページには、RubyのSinatraでPOSTを受信しJSONをパースする以下の例が掲載されている。

    post '/' do
      push = JSON.parse(params[:payload])
      "I got some JSON: #{push.inspect}"
    end

POSTされるJSONにはブランチやファイルパスが含まれるので、例えばmasterにpushされたらデプロイするような仕組みを、自由に作り込めるだろう。

見た限りWebHookに限らずService HooksにはIRCなど様々な通知方法が用意されていて、他にも工夫次第で何でもできるようだ。

参考:
[Post-Receive Hooks](https://help.github.com/articles/post-receive-hooks)
