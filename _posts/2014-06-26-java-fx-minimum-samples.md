---
layout: blog
title: JavaFXの最小のサンプル
tag: ['java', 'javafx']
---

# JavaFXの最小のサンプル

Java8からSwingに次ぐ新しいGUIライブラリとしてJavaFXが標準で使えるようになった。
今日はJavaFXを使い始めるにあたって参考になる最小のサンプルを書いてみる。

## ウィンドウの表示

![Sample1]({{ site.url }}/assets/2014_06_26_sample1.png)

まずはウィンドウを表示しなければはじまらない。

JavaFXのアプリケーションは`Application`を継承して作成する。
`Application`は`launch()`で起動させる。
`launch()`すると`start()`が呼ばれるのでここに初期化の処理を書く。

JavaFXではシーングラフを表す`Scene`で描画対象を指定する。
最小のシーングラフは適当なルートノードのみを含むグラフである。
この例では空の`VBox`をルートノードとすることにする。

あとは`start()`に渡される`Stage`に`setScene()`でシーングラフを設定して、`Stage`の`show()`を呼べばウィンドウが表示される。

### Sample1.java

~~~~
import javafx.application.Application;
import javafx.scene.Scene;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;

public class Sample1 extends Application {
	public void start(Stage stage) throws Exception {
		VBox root = new VBox();
		stage.setScene(new Scene(root, 640, 480));
		stage.show();
	}
	public static void main(String[] args) {
		launch(args);
	}
}
~~~~

## ラベルの追加

![Sample2]({{ site.url }}/assets/2014_06_26_sample2.png)

続いて`VBox`にラベルを追加してみることにする。

`VBox`などレイアウトへの要素の追加は、`getChildren()`で得られる`ObservableList`に`add()`することで行う。
JavaFXのラベルコントロールは`Label`である。
コンストラクタに文字列を与えるとその文字列を表示するラベルとなる。便利だ。

以下は`Hello, JavaFX!`という文字列を表示する例である。

### Sample2.java

~~~~
import javafx.application.Application;
import javafx.scene.Scene;
import javafx.scene.control.Label;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;

public class Sample2 extends Application {
	public void start(Stage stage) throws Exception {
		VBox root = new VBox();
		root.getChildren().add(new Label("Hello, JavaFX!"));
		stage.setScene(new Scene(root, 640, 480));
		stage.show();
	}
	public static void main(String[] args) {
		launch(args);
	}
}
~~~~

## FXMLの読み込み

![Sample3]({{ site.url }}/assets/2014_06_26_sample3.png)

JavaFXではFXMLという言語でインタフェースを記述できることが特徴となっている。
次の例では__sample2.java__と同じウィンドウをFXMLを使って表示させてみよう。

FXMLの実体はXMLである。
まず`import`でインポートするコントロールを記述し、シーングラフの構造はタグで記述する。
以下に示す__Sample3.fxml__は、__sample2.java__でプログラムで記述したシーングラフを、FXMLで書き起こしたものである。

FXMLのロードには`FXMLLoader`を利用する。
`load()`は引数にURLを取るので、JavaのリソースのURLを`getResource()`で取得している。
EclipseであればJavaファイルと同一のフォルダにFXMLファイルを配置してやれば読み込めるはずである。

# Sample3.fxml

~~~~
<?xml version="1.0" encoding="UTF-8"?>
<?import javafx.scene.control.Label?>
<?import javafx.scene.layout.VBox?>
<VBox>
	<children>
		<Label text="Hello, JavaFX!"/>
	</children>
</VBox>
~~~~

### Sample3.java

~~~~
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;

public class Sample3 extends Application {
	public void start(Stage stage) throws Exception {
		VBox root = (VBox) FXMLLoader.load(getClass().getResource("Sample3.fxml"));
		stage.setScene(new Scene(root, 640, 480));
		stage.show();
	}
	public static void main(String[] args) {
		launch(args);
	}
}
~~~~
