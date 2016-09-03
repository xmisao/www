---
layout: blog
title: BestGemsの開発環境の構築
tag: bestgems
---



[BestGems.org](http://bestgems.org/)をオープンソース化して早2ヶ月。
幸いなことに、ちょこちょこではあるが、プロジェクトに協力してくれる人も現れている。

BestGemsが使用するGemパッケージはBundlerを使用して管理しているし、依存するソフトウェアもSQLite3くらいしかないため、開発環境の構築はさほど難しくない。
しかしBestGemsで実際にデータを表示するには、RubyGems.orgをスクレイピングする必要があり、それがBestGems.orgを開発するにあたっての障壁になっていると感じていた。

そこでソースコードの取得から、BestGemsの実行まで、開発環境構築の一連の手順をここにまとめてみようと思う。
このエントリを通じてBestGems.orgの開発がさらに活発になることを期待している。

なお同様の内容を英語で[wiki](https://github.com/xmisao/bestgems.org/wiki/For-Developers)にアップロードしているので、最新の情報はそちらを参照して欲しい。

# ソースコードの取得

githubから最新版のソースコードを取得する。

~~~~
git clone https://github.com/xmisao/bestgems.org.git bestgems.org
cd bestgems.org
~~~~

# Gemパッケージのインストール

BestGemsの依存関係はBundlerで管理されている。
Bundlerを使って依存するGemパッケージをインストールする。

~~~~
bundle install
~~~~

# DBスキーマのマイグレーション

BestGemsはORMにSequelを使用している。
Sequelのマイグレーション機能を使ってデータベースをマイグレーションする。

なおSequelは開発環境にSQLite3を、本番環境ではPostgreSQLを使用する。
移行はSQLite3を使用する手順を紹介する。

~~~~
sequel -m migrations sqlite://db/master.sqlite3
~~~~

# サンプルデータの取得

1週間分のデータを含むサンプルデータが用意されている。
サンプルデータをダウンロードして展開する。

~~~~
wget http://bestgems.org.s3.amazonaws.com/bestgems_db_v5_sample_csv.tar.gz
tar zxvf bestgems_db_v5_sample_csv.tar.gz
cd  bestgems_db_v5_sample_csv
~~~~

# サンプルデータのインポート

サンプルデータはCSVである。
SQLite3にサンプルデータをインポートする。

まずSQLite3のデータベースに接続する。

~~~~
sqlite3 ../db/master.sqlite3
~~~~

SQLite3で以下のコマンドを実行する。

~~~~
.separator ,
.import gems.csv `gems`
.import values.csv `values`
.import rankings.csv `rankings`
.import reports.csv `reports`
.import report_data.csv `report_data`
.import statistics.csv `statistics`
.import master.csv `master`
.quit
~~~~

元のディレクトリに戻る。

~~~~
cd ..
~~~~


# テストの実行

BestGemsのテストは`rake`で実行する。

~~~~
rake
~~~~

# BestGemsの実行

BestGemsは`rack`で起動する。

~~~~
rackup
~~~~

これで`http://localhost:9292/`にアクセスすればBestGemsの画面が確認できるはずだ。
