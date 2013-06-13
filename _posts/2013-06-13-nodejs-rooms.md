---
layout: default
title: Node.jsでチャットルームを実現する方法
---

# Node.jsでチャットルームを実現する方法

Node.jsの接続中のクライアントを区分して、一部のクライアントにのみサーバからイベントを送出するRooms機能がある。この機能を使えば、例えばユーザがいくつかのチャットルームに分かれて、チャットルーム毎に独立してチャットを行うような仕組みを簡単に実現できる。

接続済みsocketオブジェクトでjoin()メソッドを呼び出すと、引数で指定したRoomに加えることができる。

    socket.join('room')

逆にRoomから抜くには、socketオブジェクトのleave()メソッドを用いる。
ただし切断時は自動的に処理されるので、dissconnectイベントでleave()を呼ぶ必要はない。

    socket.leave('room')

Roomに所属するクライアントにのみイベントを送出するには、以下のようにする。

    io.sockets.in('room').emit('event_name', data)

Roomに関する情報の取得はそれぞれ以下のように行える。

すべてのRoomを取得する。これはハッシュで、Room名をキーとし、所属するsocketのIDの配列が値となっている。

    io.sockets.manager.rooms

指定したRoomに所属するsocketを取得する。socketインスタンスが返却される。

    io.sockets.clients('room')

socketが所属するRoomを取得する。

    io.sockets.manager.roomClients[socket.id]

(Rooms - LearnBoost/socket.io Wiki)[https://github.com/LearnBoost/socket.io/wiki/Rooms]
