---
layout: blog
title: スプリアスウェイクアップ問題 -- Javaのwait() / notify()を信用してはならない
tag: java
---



Javaでスレッドを使っている時、`wait()`したら、Threadが`notify()`されるまで処理が止まると思ったら大間違いという話である。

Javaでは`wait()`が`notify()`なしで勝手に動いてしまうことがあるそうなのだ。この現象はスプリアスウェイクアップ(Spurious wakeup)と呼ばれている。

このスプリアスウェイクアップを考慮して、Javaで`wait()`する場合は、再開の条件をアプリケーション側で管理して、条件が満たされなければ再度`wait()`する実装上の配慮が必要だ。

スプリアスウェイクアップを念頭に置いて、スレッドをwaitする`Lockクラス`を考えてみる。このクラスは`lock()`でスレッドを停止させ、別スレッドから`unlock()`で再開させるものだ。

以下は危険な例である。
`wait()`がスプリアスウェイクアップで実行され、意図せずスレッドが再開される可能性がある。

~~~~
	class LockClass1{
		public void lock() throws InterruptedException{
			wait();
		}
		
		public void unlock(){
			notify();
		}
	}
~~~~
	
次はスプリアスウェイクアップを考慮した例だ。再開可否のフラグを持たせて、スレッドを再開させる際は、フラグを立ててから再開させる。もしスプリアスウェイクアップが生じても、フラグが立っていないので再び`wait()`する。

~~~~
	class LockClass2{
		public boolean flag = false;
		public void lock2() throws InterruptedException{
			while(!flag){
				wait();
			}
			flag = false;
		}
		
		public void unlock2(){
			flag = true;
			notify();
		}
	}
~~~~

しかし、このスプリアスウェイクアップ、概念はわかるのだが、実際どれほどの確率で発生するものなのだろうか。JavaのObjectのリファレンスには一応この事が書かれているのだが…。

- java.lang.Object (http://docs.oracle.com/javase/7/docs/api/java/lang/Object.html#wait%28%29)
