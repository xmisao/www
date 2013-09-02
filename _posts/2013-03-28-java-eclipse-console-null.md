---
layout: blog
title: EclipseでJavaのConsoleクラスから入力を得る方法
tag: java
---

# EclipseでJavaのConsoleクラスから入力を得る方法

簡単なプログラムで、JavaのSystem.console()で得られるjava.io.Consoleから入力を与えたい場合がある。

    Console console = System.console();
    String s = console.readLine();
    System.out.println(s);

しかし、このプログラムはEclipseで動作させた場合、System.console()の返却値がnullになり動作せず、Null Pointer Exceptionが発生する。

Eclipse内のコンソールでこの手のプログラムを動作させたい場合、System.console()を使わずに、System.input()をBufferedReader等でくるんだインスタンスを代用にすると良い。これでEclipseのコンソールの入力した内容が、行単位でプログラムに渡せる。

    BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
    String s = br.readLine();
    System.out.println(s);

参考:  
[How To Get Input From Console Class In Java?](http://stackoverflow.com/questions/4644415/how-to-get-input-from-console-class-in-java)
