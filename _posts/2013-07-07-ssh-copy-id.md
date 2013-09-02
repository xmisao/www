---
layout: blog
title: sshの公開鍵をコマンド1発でリモートホストに登録するssh-copy-id
tag: ssh
---

# sshの公開鍵をコマンド1発でリモートホストに登録するssh-copy-id

あまり話題にならないが、sshで公開鍵認証を使う場合、リモートホストに公開鍵を登録する作業は、ssh-copy-idというコマンド1発で行える。

    ssh-copy-id .ssh/id_rsa.pub user@host

登録の作業は、リモートホストの~/.ssh/authorized_keysに、公開鍵の内容を1行書き加えるだけだ。この作業は、リモートホストで以下のような操作をするように説明されることもある。

    cat id_rsa.pub >> ~/.ssh/authorized_keys

しかし、この操作は誤って>でリダイレクトして登録済みの公開鍵を失うリスクや、authorized_keysファイルが新規作成された場合にパーミッションを設定する手間がある。

そのため特別な理由がない限り、ssh-copy-idコマンドを使う方が簡単だし、良いと思う。
