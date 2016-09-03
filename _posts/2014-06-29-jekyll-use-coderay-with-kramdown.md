---
layout: blog
title: Jekyllでkramdown使用時にcoderayでシンタックスハイライトする
tag: jekyll
---



`_config.yml`に以下の内容を記述する。

~~~~ yml
markdown: kramdown
kramdown:
  use_coderay: true
~~~~

シンタックスハイライトの対象にするコードはfenced codeblockで記述する。

    ~~~~ ruby
    def hoge
      puts 'Hello, World!'
    end
    ~~~~

~~~~ ruby
def hoge
  puts 'Hello, World!'
end
~~~~

デフォルトだと行番号が先頭に付加される。
これが邪魔な場合は`coderay_line_numbers`オプションを`nil`にする。

~~~~ yml
markdown: kramdown
kramdown:
  use_coderay: true
  coderay_line_numbers: nil
~~~~

なお`table`を指定すれば行番号をテーブルで表示するようにも指定できる。

~~~~ yml
markdown: kramdown
kramdown:
  use_coderay: true
  coderay_line_numbers: table
~~~~
