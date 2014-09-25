---
layout: blog
title: JavaFX 8でタイマー(処理の定期実行)を実装する
tag: javafx
---

# JavaFX 8でタイマー(処理の定期実行)を実装する

JavaFX 8で定期的に何か処理を行う場合は`Timeline`を使うと簡単に実装できる。
JavaFXのイベントハンドラで処理が実行されるため、GUIを操作することも可能。
以下は0からはじめて1秒ごとにラベルの数字をカウントアップする例。

~~~~
import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.application.Application;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.scene.Scene;
import javafx.scene.control.Label;
import javafx.stage.Stage;
import javafx.util.Duration;

public class Timer  extends Application {
    public void start(Stage stage) throws Exception {
        final Label label = new Label("0");

        Timeline timer = new Timeline(new KeyFrame(Duration.millis(1000), new EventHandler<ActionEvent>(){
            @Override
            public void handle(ActionEvent event) {
                label.setText(String.valueOf(Integer.parseInt(label.getText()) + 1));
            }
        }));
        timer.setCycleCount(Timeline.INDEFINITE);
        timer.play();

        stage.setScene(new Scene(label, 100, 100));
        stage.show();
    }
    public static void main(String[] args) {
        launch(args);
    }
}
~~~~

![JavaFX Timer]({{ site.url }}/assets/2014_09_25_timer.png)

- 参考
  - [JavaFX periodic background task](http://stackoverflow.com/questions/9966136/javafx-periodic-background-task)
