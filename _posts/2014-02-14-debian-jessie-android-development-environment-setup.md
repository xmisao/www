---
layout: blog
title: Debian jessieでAndroidアプリの開発環境を整えるメモ
tag: ['debian', 'android']
---



以下のページから"adt-bundle-linux-x86_64-20131030.zip"をダウンロードして展開。

-[Get the Android SDK](http://developer.android.com/sdk/index.html)

中にeclipseが含まれているのでeclipseを起動。

するとコンソールに以下のようなエラーが出た。

> Unexpected exception 'Cannot run program "/home/antz/Development/adt-bundle-linux/sdk/platform-tools/adb": error=2 No such file or directory' while attempting to get adb version from /home/antz/Development/adt-bundle-linux/sdk/platform-tools/adb

32bitのライブラリが必要なので以下のパッケージをインストール。

~~~~
sudo apt-get install libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5
~~~~

eclipseを再起動するとさらに以下のようなエラー。

> android-sdks/build-tools/17.0.0/aapt: error while loading shared libraries: libz.so.1: cannot open shared object file: No such file or directory

足りていないライブラリをインストール。

~~~~
sudo apt-get install lib32z1
~~~~

これでeclipse上ではエラーが消えたがAVDのエミュレータが起動しなかった。
`emurator`コマンドを直接叩いてみると以下のエラー。

> Failed to load libGL.so  
> error libGL.so: cannot open shared object file: No such file or directory

以下のパッケージをインストール。

~~~~
sudo apt-get install libgl1-mesa-dev
~~~~

以上でAndroidアプリの開発環境が整った。

- [Android adb not found](http://stackoverflow.com/questions/13571145/android-adb-not-found)
- [android-sdks/build-tools/17.0.0/aapt: error while loading shared libraries: libz.so.1: cannot open shared object file: No such file or directory](http://stackoverflow.com/questions/17020298/android-sdks-build-tools-17-0-0-aapt-error-while-loading-shared-libraries-libz)
