---
layout: blog
title: JavaのSAXPaserをどのように停止させるべきか? 例外で停止させるしかない。
tag: java
---

# JavaのSAXPaserをどのように停止させるべきか? 例外で停止させるしかない。

JavaでSAXPaserを使ってXMLをパースしている際に、例えばstartElement()ハンドラで以降の処理が不要だと判断し、パースを停止するにはどのようにプログラムすれば良いのか?
例外を制御に使うのは非常に気持ち悪いが、残念ながらSAXExceptionをthrowするのが一番簡単で確実なようだ。
サンプルコードはStackoverflowから引用する。以下の例ではSAXExceptionを継承した、MySaxTerminatorExceptionを定義している。

    public class MySAXTerminatorException extends SAXException {
        ...
    }
    
    public void startElement (String namespaceUri, String localName, String qualifiedName, Attributes attributes) throws SAXException {
        if (someConditionOrOther) {
            throw new MySAXTerminatorException();
        }
        ...
    }

参考:  
[How to stop parsing xml document with SAX at any time?](http://stackoverflow.com/questions/1345293/how-to-stop-parsing-xml-document-with-sax-at-any-time)
