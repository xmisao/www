---
layout: blog
title: X Window Systemでマウスの場所を記録し続けるプログラム
tag: linux
---

# X Window Systemでマウスの場所を記録し続けるプログラム

私はPCを触っている時間がかなり長い。
家のマシンは常に起動しているので、家に居る間はほとんどと言っても良い。
ここまでPCに張り付いているなら、いっそPCの操作を記録しておけば、何か得られるものもあるのでは、と思った。

手始めにマウスの移動を記録してみようと考え、以下のプログラムを書いた。
`mouselogger.c`である。

[Gist/mouselogger.c](https://gist.github.com/xmisao/6792485)

~~~~
#include<X11/Xlib.h>
#include<stdio.h>
#include<time.h>

typedef struct{
	int x, y;
} Pos;

Pos get_pos(Display *dpy, Window root){
		Window w;
		Window root_return, child_return;
		Pos root_pos;
		int win_x, win_y;
		unsigned int mask;

		XQueryPointer(dpy, root, &root_return, &child_return, &root_pos.x, &root_pos.y, &win_x, &win_y, &mask);

		return root_pos;
}

int main(){
		Display* dpy;
		Window root;
		Pos pos;
		time_t t;

		dpy = XOpenDisplay(NULL);
		root = DefaultRootWindow(dpy);

		while(1){	
			time(&t);
			pos = get_pos(dpy, root);
			printf("%d,%d,%s", pos.x, pos.y, ctime(&t));
			fflush(stdout);
			sleep(1);
		}
}
~~~~

Xのプログラミングはあまりしたことがないので手探りだが、どうにか30行ほどで実装できた。

`XOpenDisplay()`でXのディスプレイを、その後`DefaultRootWindow()`でルートウィンドウを取得する。それらを使って1秒ごとに`XQueryPointer()`を使ってマウスの座標を得ている。取得したディスプレイを開放してやりたいが、それは割愛。

このプログラムを実行すると、標準出力に以下の形式でマウスのX座標、Y座標、時刻が出力される。

~~~~
1230,899,Wed Oct  2 21:01:45 2013
~~~~

これをリダイレクトして、裏で動かしておけば、寝起きの時間くらいならわかりそうだ。

今後の方向性だが、フォーカスしているウィンドウのタイトル等も保存してやって、「何をしていたのか」もわかるようにできたら良いと思っている。
